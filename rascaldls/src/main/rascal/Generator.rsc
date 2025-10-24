module main::rascal::Generator

import IO;
import String;
import List;
import Set;
import ParseTree;

import main::rascal::Syntax;
import main::rascal::Parser;
import main::rascal::AST;

public str text(Tree t) =unparse(t);
public str charAt(str s, int i) = substring(s, i, i+1);
public bool isWs(str c) = c == " " || c == "\t" || c == "\n" || c == "\r";
public bool isHorizWs(str c) = c == " " || c == "\t";

public bool isDigit(str c) = c == "0" || c == "1" || c == "2" || c == "3" || c == "4" || c == "5" || c == "6" || c == "7" || c == "8" || c == "9";

public bool isLetter(str c) = (c >= "a" && c <= "z") || (c >= "A" && c <= "Z");

public bool isIdStart(str c) = isLetter(c) || c == "_";
public bool isIdChar(str c) = isIdStart(c) || isDigit(c);

public int indexOfFrom(str src, str sub, int from) {
    int n = size(sub), m = size(src);
    if (n == 0) {
        return from <= m ? from: -1;
    }
    if (m - from < n) {
        return -1;
    }
    for (int i <- [from..m - n]) {
        if (substring(src, i, i + n) == sub) {
            return i;
        }
    }
    return -1;
}

public str lastIdentifier(str src) {
    int m = size(src);
    if (m == 0) {
        return "?";
    }
    int i = m - 1;
    while (i >= 0 && isWs(charAt(src, i))) i = i - 1;
    int j = i;
    while (j >= 0 && isIdChar(charAt(src, j))) j = j - 1;
    return substring(src, j + 1, i + 1);
}

public str firstIdentifier(str src) {
    int m = size(src), i=0;
    while (i < m && isIdStart(charAt(src, i))) i = i + 1;
    if (i>=m) {
        return "?";
    }   
    int j = i + 1;
    while (j < m && isIdChar(charAt(src, j))) j = j + 1;
    return substring(src, i, j);
}

public tuple[bool ok,str inside] betweenFirstParens(str src) {
    int i = indexOfFrom(src, "(", 0);
    if (i < 0) {
        return <false, "">;
    }
    for (int j <- [i + 1 .. size(src) - 1]) {
        if (charAt(src, j) == ")") {
            return <true, substring(src, i + 1, j)>;
        }
    }
    return <false, "">;
}

public list[str] splitCommaNames(str src) {
    list[str] out = [];
    for (str part <- split(",", src)) {
        str t = trim(part);
        if (t != "") {
            out += [t];
        }
    }
    return out;
}

public str joinWith(list[str] items, str sep) {
    if (items == []) {
        return "";
    }
    str out = "";
    bool first = true;
    for (str item <- items) {
        if (first) {
            out = out + item;
            first = false;
        } else {
            out = out + sep + item;
        }
    }
    return out;
}

public int countSub(str src, str sub) {
    int count = 0, pos = 0,n = size(sub),m= size(src);
    if (n == 0 ) {
        return 0;
    }
    while (pos <= m-n) {
        if (substring(src, pos, pos + n) == sub) {
            count = count + 1;
            pos = pos + n;
        }
        else {
            pos = pos + 1;
        }
    }
    return count;
}

public int countMethodCalls(str src) {
    int m = size(src), i = 0, count = 0;
    while (i < m) {
        while (i < m && isWs(charAt(src, i))) i = i + 1;

        if (i >= m || !isIdStart(charAt(src, i))) {
            i = i + 1;
            continue;
        }
        int j = i + 1;
        while (j < m && isIdChar(charAt(src, j))) j = j + 1;
        int k = j;
        while (k < m && isWs(charAt(src, k))) k = k + 1;
        if (k >= m || charAt(src, k) != ".") {
            i = j;
            continue;
        }
        k = k + 1;
        while (k < m && isWs(charAt(src, k))) k = k + 1;
        if (k >= m || !isIdStart(charAt(src, k))) {
            i = j;
            continue;
        }
        int h = k + 1;
        while (h < m && isIdChar(charAt(src, h))) h = h + 1;
        while (h < m && isWs(charAt(src, h))) h = h + 1;
        if (h < m && charAt(src, h) == "(") {
            count = count + 1;
            i = h + 1;
        }
        else {
            i = j;
        }
    }
    return count;
}
public set[str] collectFunctions(str src) {
    set[str] out = {};
    int pos = 0, m = size(src);

    while(true) {
        int p = indexOfFrom(src, "function", pos);
        if (p < 0) break;

        int scan = p + 8;
            while (true) {
                int e = indexOfFrom(src, "end", scan);
                if (e < 0) {
                    scan = -1;
                    break;
                }
                 int i = e + 3;
                while (i < m && isHorizWs(charAt(src, i))) {
                    i = i + 1;
                }

                if (i < m && isIdStart(charAt(src, i))) {
                    int j = i + 1;
                    while (j < m && isIdChar(charAt(src, j))) {
                        j = j + 1;
                    }
                    out += {substring(src, i, j)};
                    scan = j;
                    break;
                    }
                scan = e + 3;
            }
        pos = scan >= 0 ? scan : p+8;
    }
    return out;
}


public set[str] collectDataLines(str src) {
    set[str] Lines = {};
    int pos = 0, m = size(src);
    while(true) {
        int p = indexOfFrom(src, "data with", pos);
        if (p < 0) break;
        int q = indexOfFrom(src, "end", p);
        if (q < 0) break;

        int i = q + 3;
        while (i < m && isWs(charAt(src, i))) i= i + 1;
        str dataName="?";
        if (i < m && isIdStart(charAt(src, i))) {
                int j = i + 1;
                while (j < m && isIdChar(charAt(src, j))) {
                    j = j + 1;
                }
                dataName = substring(src, i, j);
            }

        str block = substring(src, p, q);
        int bp=0, mb=size(block);
        while (true) {
            int sc = indexOfFrom(block, "struct(", bp);
            if (sc < 0) break;

            int eq = sc - 1;
            while (eq >= 0 && isWs(charAt(block, eq))) eq = eq - 1;
            while (eq >= 0 && !isWs(charAt(block, eq))) eq = eq - 1;
            if (eq < 0 ) {
                bp = sc + 1;
                continue;
            }
            
            str left = substring(block, 0, eq + 1);
            str ctorName= lastIdentifier(left);

            bool ok = false;
            str inside = "";

            <ok, inside> = betweenFirstParens(substring(block, sc + 6));
            list[str] fields= ok? splitCommaNames(inside) : [];

            list[str] cleanFields = [f|f<-fields, trim(f) != ""];
            str line = " - " + dataName + "." + ctorName + "(" + joinWith(cleanFields, ", ") + ")";
            Lines += {line};
            bp = sc + 7;
        }
        pos = q + 3;
    }
    return Lines;
}


public str runReport(start[Module] cst) {
    str src = text(cst);

    set[str] funNames = collectFunctions(src);
    set[str] dataLinesS = collectDataLines(src);
    int dollarCalls = countSub(src, "$(");
    int methodCalls = countMethodCalls(src);

    str header = "ALU Report\n"; 

    list[str] fnList = toList(funNames);
    str fns = fnList == [] ? "Functions:\n -(none)\n"
                            : "Functions:\n" + joinWith(fnList, "\n") + "\n";

    list[str] dataList = toList(dataLinesS);
    str datas = dataList == [] ? "Data/struct:\n -(none)\n"
                                : "Data/struct:\n" + joinWith(dataList, "\n") + "\n";

    str calls = "Calls: $" + dollarCalls + " . " + methodCalls + "\n";
    return header + fns + datas + calls;
}
public str runReportFromSource(str source) {
    set[str] funNames = collectFunctions(source);
    set[str] dataLinesS = collectDataLines(source);
    int dollarCalls = countSub(source, "$(");
    int methodCalls =countMethodCalls(source);

    str header = "ALU Report\n"; 

    list[str] fnList = toList(funNames);
    str fns = fnList == [] ? "Functions:\n -(none)\n"
                            : "Functions:\n" + joinWith(fnList, "\n") + "\n";

    list[str] dataList = toList(dataLinesS);
    str datas = dataList == [] ? "Data/struct:\n -(none)\n"
                                : "Data/struct:\n" + joinWith(dataList, "\n") + "\n";

    str calls = "Calls: $" + dollarCalls + " . " + methodCalls + "\n";
    return header + fns + datas + calls;
}  