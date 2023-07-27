import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../TokenType.dart';

/// A [SymbolNode] object is a member of a tree that contains all possible prefixes
/// of allowable symbols. Multi-character symbols appear in a [SymbolNode] tree
/// with one node for each character.
///
/// For example, the symbol `=:~` will appear in a tree as three nodes. The first
/// node contains an equals sign, and has a child; that child contains a colon and has a child;
/// this third child contains a tilde, and has no children of its own. If the colon node had
/// another child for a dollar sign character, then the tree would contain the symbol `=:$`.
///
/// A tree of [SymbolNode] objects collaborate to read a (potentially multi-character)
/// symbol from an input stream. A root node with no character of its own finds an initial node
/// that represents the first character in the input. This node looks to see if the next character
/// in the stream matches one of its children. If so, the node delegates its reading task to its child.
/// This approach walks down the tree, pulling symbols from the input that match the path down the tree.
///
/// When a node does not have a child that matches the next character, we will have read the longest
/// possible symbol prefix. This prefix may or may not be a valid symbol.
/// Consider a tree that has had `=:~` added and has not had `=:` added.
/// In this tree, of the three nodes that contain `=:~`, only the first and third contain
/// complete symbols. If, say, the input contains `=:a`, the colon node will not have
/// a child that matches the 'a' and so it will stop reading. The colon node has to "unread": it must
/// push back its character, and ask its parent to unread. Unreading continues until it reaches
/// an ancestor that represents a valid symbol.
class SymbolNode {
  final SymbolNode? _parent;
  final int _character;
  CharReferenceMap<SymbolNode>? _children;
  var _tokenType = TokenType.Unknown;
  bool _valid = false;
  String? _ancestry;

  /// Constructs a SymbolNode with the given parent, representing the given character.
  /// - [parent] This node's parent
  /// - [character] This node's associated character.
  SymbolNode(SymbolNode? parent, int character)
      : _parent = parent,
        _character = character;

  /// Find or create a child for the given character.
  /// - [value] chararacters’s number
  /// Returns symbol’s node
  SymbolNode ensureChildWithChar(int value) {
    _children ??= CharReferenceMap<SymbolNode>();

    var childNode = _children!.lookup(value);
    if (childNode == null) {
      childNode = SymbolNode(this, value);
      _children!.addInterval(value, value, childNode);
    }
    return childNode;
  }

  /// Add a line of descendants that represent the characters in the given string.
  /// - [value] symbol value
  /// - [tokenType] type of the token
  void addDescendantLine(String value, TokenType tokenType) {
    if (value.isNotEmpty) {
      var childNode = ensureChildWithChar(value.codeUnitAt(0));
      childNode.addDescendantLine(value.substring(1), tokenType);
    } else {
      _valid = true;
      _tokenType = tokenType;
    }
  }

  /// Find the descendant that takes as many characters as possible from the input.
  /// - [scanner] scanner
  /// Returns symbol’s node
  SymbolNode deepestRead(IScanner scanner) {
    var nextSymbol = scanner.read();
    var childNode =
        !CharValidator.isEof(nextSymbol) ? findChildWithChar(nextSymbol) : null;
    if (childNode == null) {
      scanner.unread();
      return this;
    }
    return childNode.deepestRead(scanner);
  }

  /// Find a child with the given character.
  /// - [value] symbol value
  /// Returns symbol’s node
  SymbolNode? findChildWithChar(int value) {
    return _children != null ? _children!.lookup(value) : null;
  }

  /// Find a descendant which is down the path the given string indicates.
  /// - [value] symbol value
  /// Returns symbol’s node

  SymbolNode? findDescendant(String value) {
    var tempChar = value.isNotEmpty ? value.codeUnitAt(0) : CharValidator.Eof;
    var childNode = findChildWithChar(tempChar);
    if (!CharValidator.isEof(tempChar) &&
        childNode != null &&
        value.length > 1) {
      childNode = childNode.findDescendant(value.substring(1));
    }
    return childNode;
  }

  /// Unwind to a valid node; this node is "valid" if its ancestry represents a complete symbol.
  /// If this node is not valid, put back the character and ask the parent to unwind.
  /// - [scanner] scanner
  /// Returns symbol’s node
  SymbolNode unreadToValid(IScanner scanner) {
    if (!_valid && _parent != null) {
      scanner.unread();
      return _parent!.unreadToValid(scanner);
    }
    return this;
  }

  bool get valid => _valid;

  set valid(bool value) => _valid = value;

  TokenType get tokenType => _tokenType;

  set tokenType(TokenType value) => _tokenType = value;

  /// Show the symbol this node represents.
  /// Returns The symbol this node represents.
  String? ancestry() {
    _ancestry ??= (_parent != null ? _parent!.ancestry() : '')! +
        (_character != 0 ? String.fromCharCode(_character) : '');
    return _ancestry;
  }
}
