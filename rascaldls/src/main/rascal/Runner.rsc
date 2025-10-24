module main::rascal::Runner
import IO;
import String;
import ParseTree;
import main::rascal::Syntax;
import main::rascal::Parser;
import main::rascal::Generator;

public str stripBOM(str s) = (size(s) >= 1 && substring(s,0,1) == "\uFEFF") ? substring(s,1,size(s)) : s;
public str normalizeNewlines(str s) = replaceAll(replaceAll(s, "\r\n", "\n"), "\r", "\n");
public str stripLineComments(str s) {
    str t = normalizeNewlines(s);
    list[str] out = [];
    for (str ln <- split("\n",t)){
        list[str] parts = split("//",ln);
        out += [ parts == [] ? "" : parts[0] ]; 
    }
    str acc="";
    bool first=true;
    for (str x <- out) {
        acc =first ? x : acc + "\n" + x;
        first=false;
    }
    return acc;
}
public void runReportString(str code, loc origin){
    str src = stripLineComments(stripBOM(code));
    try {
        start[Module] cst=parseModule(code, file);
        println(runReport(cst));
    }
    catch: {
        println(runReportFromSource(code));
    }
}
public void runReportString(str code, loc origin) {
    str src = stripLineComments(stripBOM(code));
    try {
        start[Module] cst=parseModule(src,origin);
        println(runReport(cst));
    }
    catch: {
        println(runReportFromSource(src));
    }
}