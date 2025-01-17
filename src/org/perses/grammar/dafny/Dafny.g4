grammar Dafny;

DATATYPE: 'datatype';
METHOD: 'method';
FUNCTION: 'function';
MAIN: 'Main';

LBRACKET: '(';
RBRACKET: ')';

ASSERT: 'assert';
EXPECT: 'expect';
REQUIRES: 'requires';
ENSURES: 'ensures';
MODIFIES: 'modifies';
READS: 'reads';
RETURNS: 'returns';
RETURN: 'return';

MATCH: 'match';
CASE: 'case';

WHILE: 'while';
DECREASES: 'decreases';

BREAK: 'break';
CONTINUE: 'continue';

FOR: 'for';
TO: 'to';
DOWNTO: 'downto';
INVARIANT: 'invariant';

INT: 'int';
CHAR: 'char';
REAL: 'real';
STRING: 'string';
BOOL: 'bool';

ARRAY: 'array';
SEQ: 'seq';
SET: 'set';
MULTISET: 'multiset';
MAP: 'map';

KEYS: 'Keys';
VALUES: 'Values';
LENGTH: 'Length';
FLOOR: 'Floor';

VAR: 'var';
LCURLY: '{';
RCURLY: '}';
EQUAL: '=';
BAR: '|';

QUESTION_MARK: '?';

LANGLE: '<';
RANGLE: '>';

fragment EXCLAMATION: '!';

IFF: LANGLE EQUAL EQUAL RANGLE;
IMPLIES: EQUAL EQUAL RANGLE;
REVERSE_IMPLIES: LANGLE EQUAL EQUAL;
CONJUNCT: '&&';
DISJUNCT: BAR BAR;
MINUS: '-';
PLUS: '+';
EQUALITY: EQUAL EQUAL ;
DISEQUALITY: EXCLAMATION EQUAL;
LTE: LANGLE EQUAL;
GTE: RANGLE EQUAL;
IN: 'in';
NOT_IN: EXCLAMATION IN;
DISJOINT: EXCLAMATION EXCLAMATION;
MULT: '*';
DIV: '/';
MOD: '%';
NOT: EXCLAMATION;



LSQUARE: '[';
RSQUARE: ']';

COMMA: ',';
COLON: ':';

IF: 'if';
THEN: 'then';
ELSE: 'else';

SEMICOLON: ';';
HEX: '0x';
SPREAD: DECIMAL DECIMAL;
NEW: 'new';

PRINT: 'print';

BOOL_LITERAL: TRUE |
	FALSE ;
fragment TRUE: 'true';
fragment FALSE: 'false';

PARAM_NAME: 'p_' ('A'..'Z' |
	'a'..'z' |
	'_' |
	DIGIT)+;

VARIABLE_NAME: 'v_' ('A'..'Z' |
	'a'..'z' |
	'_' |
	DIGIT)+;

RETURN_NAME: 'ret_' ('A'..'Z' |
	'a'..'z' |
	'_' |
	DIGIT)+;

GENERIC_NAME: 'T_' ('A'..'Z' |
	'a'..'z' |
	'_' |
	DIGIT)+;

DATATYPE_NAME: 'DT_'
  ('A'..'Z' | 'a'..'z' | DIGIT)*;
DATATYPE_RULE_NAME: 'DT_'
  ('A'..'Z' | 'a'..'z' | DIGIT)*
	'_'
	('A'..'Z' | 'a'..'z' | DIGIT)*;
DATATYPE_RULE_FIELD_NAME: 'DT_'
  ('A'..'Z' | 'a'..'z' | DIGIT)*
	'_'
	('A'..'Z' | 'a'..'z' | DIGIT)*
	'_'
	('A'..'Z' | 'a'..'z' | DIGIT)*;

METHOD_NAME: ('m_' | 'safe_') ('A'..'Z' |
	'a'..'z' |
	'_' |
	DIGIT)*;
FUNCTION_NAME: 'f_' ('A'..'Z' |
	'a'..'z' |
	'_' |
	DIGIT)*;

UNDERSCORE: '_';


INT_LITERAL: DIGIT+ |
	'0b' BIN_DIGIT+ |
	'0c' OCT_DIGIT+ |
	'0x' HEX_DIGIT+ ;
REAL_LITERAL: DIGIT+ DECIMAL DIGIT+;
fragment DECIMAL: '.';

DOT: DECIMAL;

fragment DIGIT: '0'..'9' ;
fragment BIN_DIGIT: '0' |
	'1' ;
fragment OCT_DIGIT: '0'..'7' ;
fragment HEX_DIGIT: '0'..'9' |
	'A'..'F' ;

CHAR_LITERAL: SINGLE_QUOTE CHARACTER SINGLE_QUOTE;
STRING_LITERAL: DOUBLE_QUOTE CHARACTER* DOUBLE_QUOTE;

fragment SINGLE_QUOTE: '\'';
fragment DOUBLE_QUOTE: '"';
fragment CHARACTER: ~['"\\] |
	ESCAPE_CHAR ;

fragment ESCAPE_CHAR: ESCAPE_BACKSLASH (ESCAPE_ZERO |
	ESCAPE_BACKSPACE |
	ESCAPE_TAB |
	ESCAPE_NEWLINE |
	ESCAPE_FORMFEED |
	ESCAPE_CARRIAGERETURN |
	DOUBLE_QUOTE |
	SINGLE_QUOTE |
	ESCAPE_BACKSLASH) ;
fragment ESCAPE_ZERO : '0' ;
fragment ESCAPE_BACKSPACE : 'b' ;
fragment ESCAPE_TAB : 't' ;
fragment ESCAPE_NEWLINE : 'n' ;
fragment ESCAPE_FORMFEED : 'f' ;
fragment ESCAPE_CARRIAGERETURN : 'r' ;
fragment ESCAPE_BACKSLASH : '\\' ;

WS: [ \t\n\r]+ -> skip ;

ERROR: .;

translation_unit: program;
program: datatype* method* function* main;

datatype: DATATYPE DATATYPE_NAME (LANGLE typeList RANGLE)? EQUAL datatypeRuleList;
datatypeRuleList: datatypeRule (BAR datatypeRule)*;
datatypeRule: DATATYPE_RULE_NAME (LBRACKET datatypeRuleFieldList RBRACKET)?;
datatypeRuleFieldList: dataTypeField (COMMA dataTypeField)*;
dataTypeField: DATATYPE_RULE_FIELD_NAME COLON dafnyType;

main: METHOD MAIN LBRACKET RBRACKET RETURNS LBRACKET RBRACKET LCURLY stat* RCURLY;

method: METHOD METHOD_NAME LBRACKET paramList? RBRACKET (RETURNS LBRACKET returnList? RBRACKET)? requires* ensures* modifies* LCURLY stat* RCURLY;
function: FUNCTION FUNCTION_NAME LBRACKET paramList? RBRACKET (COLON LBRACKET returnList? RBRACKET)? requires* ensures* reads* LCURLY stat* expr RCURLY;

dafnyType: baseType |
	collectionType (LANGLE typeList RANGLE)? | LBRACKET typeList RBRACKET | DATATYPE_NAME (LANGLE typeList RANGLE)? | GENERIC_NAME ;

paramList: paramArg (COMMA paramArg)*;
returnList: returnArg (COMMA returnArg)*;

paramArg: PARAM_NAME (COLON dafnyType)?;
returnArg: RETURN_NAME (COLON dafnyType)?;

typeList: dafnyType (COMMA dafnyType)*;

baseType: INT |
	CHAR |
	REAL |
	STRING |
	BOOL;
collectionType: ARRAY |
	SEQ |
	SET |
	MULTISET |
	MAP;

stat: assignStat | assertStat | expectStat | printStat | ifElseStat | returnStat | matchStat | whileStat | forStat | breakStat | continueStat;

printStat: PRINT exprList SEMICOLON;
assertStat: ASSERT expr SEMICOLON;
expectStat: EXPECT expr SEMICOLON;
ensures: ENSURES expr SEMICOLON;
requires: REQUIRES expr SEMICOLON;
modifies: MODIFIES variableList SEMICOLON;
reads: READS variableList SEMICOLON;
returnStat: RETURN exprList? SEMICOLON;
matchStat: MATCH expr LCURLY matchStatCase+ RCURLY;
whileStat: WHILE expr decreasesClause? (invariantsClause SEMICOLON)? LCURLY stat* RCURLY;
forStat: FOR variable COLON EQUAL expr (TO | DOWNTO) expr invariantsClause* LCURLY stat* RCURLY;
breakStat: BREAK SEMICOLON;
continueStat: CONTINUE SEMICOLON;

invariantsClause: INVARIANT expr;

decreasesClause: DECREASES expr SEMICOLON;

matchStatCase: CASE (expr | UNDERSCORE) EQUAL RANGLE LCURLY stat* RCURLY;

ifElseStat: IF expr LCURLY stat* RCURLY (ELSE LCURLY stat* RCURLY)?;

assignStat: VAR? variableList COLON EQUAL exprList SEMICOLON;

variableList: variableArg (COMMA variableArg)*;
variableArg: expr (COLON dafnyType)?;

expr: LBRACKET expr RBRACKET |
	literal |
	variable |
	expr DOT (KEYS | VALUES | LENGTH | FLOOR | intLiteral | DATATYPE_RULE_FIELD_NAME | (DATATYPE_RULE_NAME QUESTION_MARK)) |
	expr (DOT intLiteral)+ |
	expr binaryOperator (expr) |
	unaryOperator expr |
	BAR expr BAR |
	callExpr |
	ifElseExpr |
	expr indexExpr |
	expr update |
	expr subsequence |
	matchExpr |
	variable DOT  |
	DATATYPE_RULE_NAME (LBRACKET exprList RBRACKET)?;

exprList: expr (COMMA expr)*;



matchExpr: MATCH expr LCURLY matchExprCase+ RCURLY;

matchExprCase: CASE (expr | UNDERSCORE) EQUAL RANGLE expr ;
literal: intLiteral |
	charLiteral |
	boolLiteral |
	realLiteral |
	arrayLiteral |
	setLiteral |
	seqLiteral |
	multisetLiteral |
	stringLiteral |
	mapLiteral |
	tupleLiteral;

intLiteral: INT_LITERAL;
charLiteral: CHAR_LITERAL;
boolLiteral: BOOL_LITERAL;
realLiteral: REAL_LITERAL;
arrayLiteral: NEW dafnyType LSQUARE expr? RSQUARE (LSQUARE exprList? RSQUARE)?;
setLiteral: LCURLY exprList? RCURLY;
seqLiteral: LSQUARE exprList? RSQUARE;
multisetLiteral: MULTISET (LBRACKET expr RBRACKET | LCURLY exprList? RCURLY);
stringLiteral: STRING_LITERAL;
mapLiteral: MAP LSQUARE (expr COLON EQUAL expr (COMMA expr COLON EQUAL expr)*)? RSQUARE;
tupleLiteral: LBRACKET exprList RBRACKET;

binaryOperator: op1 |
	op2 |
	op3 |
	op4 |
	//op5 |
	op6 |
	op7;

op1: IFF;
op2: IMPLIES |
	REVERSE_IMPLIES;
op3: CONJUNCT |
	DISJUNCT;
op4: EQUALITY |
	DISEQUALITY |
	RANGLE |
	LANGLE |
	GTE |
	LTE |
	IN |
	NOT_IN |
	DISJOINT;
//op5: SHIFT_LEFT |	SHIFT_RIGHT;
op6: PLUS |
	MINUS ;
op7: MULT |
	DIV |
	MOD;

unaryOperator: MINUS |
	NOT;

callExpr: (METHOD_NAME | FUNCTION_NAME) LBRACKET exprList? RBRACKET;

ifElseExpr: IF expr THEN expr ELSE expr;

indexExpr: LSQUARE expr RSQUARE;

update: LSQUARE expr COLON EQUAL expr RSQUARE;

subsequence: LSQUARE expr? SPREAD expr? RSQUARE;

variable: PARAM_NAME | VARIABLE_NAME | RETURN_NAME;