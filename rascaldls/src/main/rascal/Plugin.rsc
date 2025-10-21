module Plugin

import ParseTree;
import util::IDEServices;
import Syntax;

void main() {
    registerLanguage("ALU", "alu", Tree (str, loc) {
        return parse(#start[Program], str, loc);
    });
}