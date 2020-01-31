package org.perses.antlr.ast;

public enum AstTag {
  GRAMMAR(Precedence.NONE),

  RULE_DEFINITION_PARSER(Precedence.RULE),
  RULE_DEFINITION_LEXER(Precedence.RULE),
  LEXER_FRAGMENT_DEFINITION(Precedence.RULE),

  LEXER_SKIP_COMMAND(Precedence.SKIP),

  ALTERNATIVE_BLOCK(Precedence.ALTERNATIVE),

  SEQUENCE(Precedence.SEQUENCE),

  NOT(Precedence.NOT),

  STAR(Precedence.QUANTIFIER),
  PLUS(Precedence.QUANTIFIER),
  OPTIONAL(Precedence.QUANTIFIER),

  ACTION(Precedence.UNIT),
  TOKEN_SET(Precedence.UNIT),
  TERMINAL(Precedence.UNIT),
  RULE_REF(Precedence.UNIT),
  LEXER_CHAR_SET(Precedence.UNIT),

  EPSILON(Precedence.NONE);

  private final Precedence precedence;

  AstTag(Precedence precedence) {
    this.precedence = precedence;
  }

  public Precedence getPrecedence() {
    return precedence;
  }

  public boolean isQuantifier() {
    return this == STAR || this == PLUS || this == OPTIONAL;
  }
}