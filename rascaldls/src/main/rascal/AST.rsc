module main::rascal::AST

data Decl =funDecl(str name) | dataDecl(str name);
data Module = mkModule(list[Decl] decls, list[str] globals);