module Plugin

import ParseTree;
import util::IDEServices;
import Syntax;

public void main() {
    registerLanguage(
        "ALU",     
        "alu",     
        (Tree t, loc l) { return parse(#start[Program], l); }
    );
}