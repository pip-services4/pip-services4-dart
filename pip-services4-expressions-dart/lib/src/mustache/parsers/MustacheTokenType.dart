/// Define types of mustache tokens.
enum MustacheTokenType {
  Unknown,
  Value,
  Variable,
  EscapedVariable,
  Section,
  InvertedSection,
  SectionEnd,
  Partial,
  Comment
}
