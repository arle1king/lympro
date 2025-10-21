module AST

data Program = program(list[Module] modules);

data Module 
    = functionDef(str name, list[str] parameters, list[Statement] body);
    
data Statement
    = assignment(str name, Expression value)
    | ifStatement(Expression cond, list[Statement] thenBranch, list[Statement] elseBranch)
    | expressionStatement(Expression expr)
    ;
    
data Expression
    = bracket(Expression e)
    | call(str name, list[Expression] args)
    | literal(Literal val)
    | variable(str name)
    | add(Expression lhs, Expression rhs)
    | sub(Expression lhs, Expression rhs)
    | mul(Expression lhs, Expression rhs)
    | div(Expression lhs, Expression rhs)
    | pow(Expression lhs, Expression rhs)
    | lt(Expression lhs, Expression rhs)
    ;

data Literal
    = num(int val)
    | bool(bool val)
    ;