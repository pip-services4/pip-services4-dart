/// Types (categories) of tokens such as "number", "symbol" or "word".
enum TokenType {
  Unknown,
  Eof,
  Eol,
  Float,
  Integer,
  HexDecimal,
  Number,
  Symbol,
  Quoted,
  Word,
  Keyword,
  Whitespace,
  Comment,
  Special
}
