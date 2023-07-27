/// Define states in mustache lexical analysis.
enum MustacheLexicalState {
  Value,
  Operator1,
  Operator2,
  Variable,
  Comment,
  Closure
}
