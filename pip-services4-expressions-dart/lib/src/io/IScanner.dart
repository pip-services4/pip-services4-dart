/// Defines scanner that can read and unread characters and count lines.
/// This scanner is used by tokenizers to process input streams.
abstract interface class IScanner {
  /// Reads character from the top of the stream.
  /// Returns A read character or -1 if stream processed to the end.
  int read();

  /// Gets the current line number
  /// Returns The current line number in the stream
  int line();

  /// Gets the column in the current line
  /// Returns The column in the current line in the stream
  int column();

  /// Returns the character from the top of the stream without moving the stream pointer.
  /// Returns A character from the top of the stream or -1 if stream is empty.
  int peek();

  /// Gets the next character line number
  /// Returns The next character line number in the stream
  int peekLine();

  /// Gets the next character column number
  /// Returns The next character column number in the stream
  int peekColumn();

  /// Puts the one character back into the stream stream.
  void unread();

  /// Pushes the specified number of characters to the top of the stream.
  /// - [count] A number of characcted to be pushed back.
  void unreadMany(int count);

  /// Resets scanner to the initial position
  void reset();
}
