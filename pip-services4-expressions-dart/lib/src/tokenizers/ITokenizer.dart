import 'package:pip_services4_expressions/src/io/io.dart';

import 'ICommentState.dart';
import 'INumberState.dart';
import 'IQuoteState.dart';
import 'ISymbolState.dart';
import 'IWhitespaceState.dart';
import 'IWordState.dart';
import 'Token.dart';

/// A tokenizer divides a string into tokens.
///
/// This class is highly customizable with regard
/// to exactly how this division occurs, but it also has defaults that are suitable for many
/// languages. This class assumes that the character values read from the string lie in
/// the range 0-255. For example, the Unicode value of a capital A is 65,
/// so  `String.fromCharCode(65)` prints out a capital A.
///
/// The behavior of a tokenizer depends on its character state table. This table is an array
/// of 256 [TokenizerState] states. The state table decides which state to enter
/// upon reading a character from the input string.
///
/// For example, by default, upon reading an 'A', a tokenizer will enter a "word" state.
/// This means the tokenizer will ask a [IWordState] object to consume the 'A',
/// along with the characters after the 'A' that form a word. The state's responsibility
/// is to consume characters and return a complete token.
///
/// The default table sets a SymbolState for every character from 0 to 255,
/// and then overrides this with:
///
/// .. list-table::
///     :header-rows: 1
///     :widths: 10, 10, 25
///
///     * - From
///       - To
///       - State
///
///     * - 0
///       - ' '
///       - whitespaceState
///     * - 'a',
///       - 'z'
///       - wordState
///     * - 'A'
///       - 'Z'
///       - wordState
///     * - 160
///       - 255
///       - wordState
///     * - '0'
///       - '9'
///       - numberState
///     * - '-'
///       - '-'
///       - numberState
///     * - '.'
///       - '.'
///       - numberState
///     * - '"'
///       - '"'
///       - quoteState
///     * - '\''
///       - '\''
///       - quoteState
///     * - '/'
///       - '/'
///       - slashState
///
/// In addition to allowing modification of the state table, this class makes each of the states
/// above available. Some of these states are customizable. For example, wordState allows customization
/// of what characters can be part of a word, after the first character.

abstract interface class ITokenizer {
  /// Skip unknown characters
  abstract bool skipUnknown;

  /// Skips whitespaces.
  abstract bool skipWhitespaces;

  /// Skips comments.
  abstract bool skipComments;

  /// Skips End-Of-File token at the end of stream.
  abstract bool skipEof;

  /// Merges whitespaces.
  abstract bool mergeWhitespaces;

  /// Unifies numbers: "Integers" and "Floats" makes just "Numbers"
  abstract bool unifyNumbers;

  /// Decodes quoted strings.
  abstract bool decodeStrings;

  /// A token state to process comments.
  abstract ICommentState? commentState;

  /// A token state to process numbers.
  abstract INumberState? numberState;

  /// A token state to process quoted strings.
  abstract IQuoteState? quoteState;

  /// A token state to process symbols (single like "=" or muti-character like "<>")
  abstract ISymbolState? symbolState;

  /// A token state to process white space delimiters.
  abstract IWhitespaceState? whitespaceState;

  /// A token state to process words or indentificators.
  abstract IWordState? wordState;

  /// The stream scanner to tokenize.
  abstract IScanner? scanner;

  /// Checks if there is the next token exist.
  /// Returns `true` if scanner has the next token.
  bool hasNextToken();

  /// Gets the next token from the scanner.
  /// Returns Next token of `null` if there are no more tokens left.
  Token? nextToken();

  /// Tokenizes a textual stream into a list of token structures.
  /// - [scanner] A textual stream to be tokenized.
  /// Returns A list of token structures.
  List<Token> tokenizeStream(IScanner scanner);

  /// Tokenizes a string buffer into a list of tokens structures.
  /// - [buffer] A string buffer to be tokenized.
  /// Returns A list of token structures.
  List<Token> tokenizeBuffer(String buffer);

  /// Tokenizes a textual stream into a list of strings.
  /// - [scanner] A textual stream to be tokenized.
  /// Returns A list of token strings.
  List<String?> tokenizeStreamToStrings(IScanner scanner);

  /// Tokenizes a string buffer into a list of strings.
  /// - [buffer] A string buffer to be tokenized.
  /// Returns A list of token strings.
  List<String?> tokenizeBufferToStrings(String buffer);
}
