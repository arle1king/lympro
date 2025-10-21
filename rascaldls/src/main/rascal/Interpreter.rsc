module Interpreter

import AST;
import IO;
import Map;
import Value;
import List;

alias Env = map[str, Value];

value eval(Program p) {
    Env env = (); 
    value result = integer(0);
    
    for (m <- p.modules) {
        if (m is functionDef && m.name == "main") {
            result = eval(m, env);
        }
    }
    return result;
}

value eval(Module m, Env env) {
    if (m is functionDef) {
        return evalStatements(m.body, env);
    }
    return integer(0);
}

value evalStatements(list[Statement] stmts, Env env) {
    value result = integer(0);
    for (stmt <- stmts) {
        result = eval(stmt, env);
    }
   
    return result;
}

value eval(Statement s, Env env) {
    return visit(s) {
        case assignment(str name, Expression value): {
            env[name] = eval(value, env);
            return env[name];
        }
        case ifStatement(Expression cond, list[Statement] thenBranch, list[Statement] elseBranch): {
            
            if (eval(cond, env).val) {
                return evalStatements(thenBranch, env);
            } else {
                return evalStatements(elseBranch, env);
            }
        }
        case expressionStatement(Expression expr): return eval(expr, env);
    }
}

value eval(Expression e, Env env) {
    return visit(e) {
        case variable(str name): {
            if ("<name>" in env) {
                return env[name];
            }
            throw "Error: Variable \'<name>\' no ha sido definida.";
        }
        case literal(num(int v)): return integer(v);
        case literal(bool(bool v)): return boolean(v);
        
        case add(Expression l, Expression r): return eval(l, env) + eval(r, env);
        case sub(Expression l, Expression r): return eval(l, env) - eval(r, env);
        case mul(Expression l, Expression r): return eval(l, env) * eval(r, env);
        case div(Expression l, Expression r): return eval(l, env) / eval(r, env);
        case lt(Expression l, Expression r): return eval(l, env) < eval(r, env);

        case call(str name, list[Expression] args): {
             if ("<name>" == "print") {
                for (arg <- args) {
                    println(eval(arg, env));
                }
                return integer(0); 
            }
            throw "Error: Función \'<name>\' no definida.";
        }
    }
}