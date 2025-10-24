module main::rascal::Syntax
syntax ParamList = params: "("Vars?")";
syntax Body = body:Stmt*;
syntax NonEmptyBody = body:Stmt+;
syntax Function = fun0e: "function" "do" "end" Id
| fun0n: "function" "do" NonEmptyBody "end" Id
| funPe: "function" ParamList "do" "end" Id
| funPn: "function" "do" NonEmptyBody "end" Id;
syntax Constructor = ctor: Id "=" "struct" "(" Vars? ")" ;
syntax DataBody = dbCtor: Constructor | dbFun:Function;
syntax Data = dataDef: "data" "with" Vars DataBody "end" Id;
syntax Invocation = invDollar: Id "$" "(" Vars?")" | invMethod: Id "." Id "(" Vars?")" ;
syntax Stmt = sIf: "if" Exp "then" Body "else" Body "end"
| sInv: Invocation 
| sVs: Vars
| sId: SimpleId
| sE: Exp;
syntax Principal = pTrue: "true" | pFalse: "false" | pInt: INT | pFloat: FLOAT | pId: Id;
syntax Exp = OrExp;
syntax OrExp = o1:AndExp | o2:OrExp "or" AndExp;
syntax AndExp = a1: EqExp | a2: AndExp "and" EqExp;
syntax EqExp = e1: EqExp "eq" CmpExp | eNe: EqExp "ne" CmpExp;
syntax CmpExp = c1: AddExp | cLt: CmpExp "lt" AddExp | cLe: CmpExp "le" AddExp | cGt: CmpExp "gt" AddExp | cGe: CmpExp "ge" AddExp;
syntax AddExp = ad1: AddExp "+" MulExp | ad2: AddExp "-" MulExp | ad3: MulExp;
syntax MulExp = m1: MulExp "*" PowExp | m2: MulExp "/" PowExp | m3: MulExp "%" PowExp | m4: PowExp;
syntax PowExp = pw1: UnaryExp "**" PowExp | pw2: UnaryExp;
syntax UnaryExp = uNeg: "-" UnaryExp | uPri:Primary;
syntax Primary= pr1:Principal | pr2:Invocation | pr3:"(" Exp ")"| pr4: "["Exp"]";
