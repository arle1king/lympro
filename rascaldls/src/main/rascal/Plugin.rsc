module main::rascal::Plugin

import ParseTree;
import main::rascal::Syntax;
import main::rascal::Parser;
import main::rascal::Generator;


public str reportFromFile(loc file) {
    start[Module] cst=parseModule(file);
    return runReport(cst);
}
public str reportFromString(str code, loc origin) {
    start[Module] cst=parseModule(code, origin);
    return runReport(cst);
}