module main::rascal::Implode

import IO;
import String;
import List;
import Set;
import ParseTree;

import main::rascal::AST;
import main::rascal::Generator;
import main::rascal::Parser;
import main::rascal::Syntax;

public str normalizeNewlines(str src) {
    return replaceAll(replaceAll(src, "\r\n", "\n"), "\r", "\n");
}

public str stripBom(str src) {
    if (size(src) == 0) {
        return src;
    }
    if (substring(src, 0, 1) == "\uFEFF") {
        return substring(src, 1, size(src));
    }
    return src;
}


public bool isDigit(str c) = 
    c == "0" || c == "1" || c == "2" || c == "3" || c == "4" || 
    c == "5" || c == "6" || c == "7" || c == "8" || c == "9";

public bool isLetter(str c) = 
    (c >= "a" && c <= "z") || (c >= "A" && c <= "Z");

public bool isIdStart(str c) = isLetter(c) || c == "_";
public bool isIdCharCh(str c) = isIdStart(c) || isDigit(c);
public bool isIdChar(str c) = isIdStart(c) || isDigit(c);


public int indexOfFrom(str src, str sub, int from) {
    int n = size(sub), m = size(src);
    if (n == 0) {
        return from <= m ? from : -1;
    }
    if (m - from < n) {
        return -1;
    }
    for (int i <- [from .. m - n]) {
        if (substring(src, i, i + n) == sub) {
            return i;
        }
    }
    return -1;
}



public bool isIdName(str src, int dummy) {
    str t = trim(src);
    int m = size(t);
    if (m == 0) {
        return false;
    }

    int i = 0;
    str c = substring(t, i, i + 1);
    if (!isIdStart(c)) {
        return false;
    }

    i = i + 1;
    while (i < m) {
        c = substring(t, i, i + 1);
        if (!isIdChar(c)) {
            return false;
        }
        i = i + 1;
    }
    return true;
}


public str charAt(str s, int i) = substring(s, i, i + 1);
public bool isWs(str c) = c == " " || c == "\t" || c == "\n" || c == "\r";

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
    int m = size(src), i = 0;
    while (i < m && !isIdStart(charAt(src, i))) i = i + 1;
    if (i >= m) {
        return "?";
    }
    int j = i + 1;
    while (j < m && isIdChar(charAt(src, j))) j = j + 1;
    return substring(src, i, j);
}

public set[str] collectFunctions(str src) {
    set[str] out = {};
    int pos = 0;
    int m = size(src);

    while (true) {
        int p = indexOfFrom(src, "fun", pos);
        if (p < 0) break; 

        int i = p + 3;
      
        while (i < m && isWs(charAt(src, i))) i = i + 1;

    
        if (i < m && isIdStart(charAt(src, i))) {
            int j = i + 1;
            while (j < m && isIdChar(charAt(src, j))) j = j + 1;
            out += {substring(src, i, j)};
        }

        
        pos = i + 1;
    }

    return out;
}



public list[str] collectGlobals(str src) {
    list[str] ids = [];
    int m = size(src);
    int i = 0;

    
    while (i < m && isWs(charAt(src, i))) i = i + 1;

   
    if (i >= m || !isIdStart(charAt(src, i))) {
        return ids;
    }

    
    while (i < m) {
        int j = i + 1;
        while (j < m && isIdChar(charAt(src, j))) j = j + 1;
        ids += [substring(src, i, j)];

        int k = j;
        while (k < m && isWs(charAt(src, k))) k = k + 1;

        
        if (k < m && charAt(src, k) == ",") {
            i = k + 1;
            while (i < m && isWs(charAt(src, i))) i = i + 1;
            continue;
        } else {
            break;
        }
    }

    return ids;
}


public set[str] collectDataNames(str src) {
    set[str] out = {};
    int pos = 0;
    int m = size(src);

    while (true) {
        int p = indexOfFrom(src, "data", pos);
        if (p < 0) break; 

        int withPos = indexOfFrom(src, "with", p + 4);
        if (withPos < 0) { pos = p + 4; continue; }

        int q = indexOfFrom(src, "end", withPos);
        if (q < 0) break;

        int i = q + 3;
        while (i < m && isWs(charAt(src, i))) i = i + 1;

        if (i < m && isIdStart(charAt(src, i))) {
            int j = i + 1;
            while (j < m && isIdChar(charAt(src, j))) j = j + 1;
            out += {substring(src, i, j)};
        }

        pos = q + 3;
    }

    return out;
}




public Module implodeModule(start[Module] cst) {
   str src = unparse(cst);
   return buildModuleFromSource(src);
}

public Module buildModuleFromSource(str src) {
    str src = normalizeNewlines(stripBom(src));

    list[Decl] globals = collectGlobals(src);
    set[str] funNames = collectFunctions(src);
    set[str] dataNames = collectDataNames(src);

    list[Decl] decls = [ ];
    for (str n <- toList(funNames)) {
        decls += [ funDecl(n) ];
    }
    for (str n <- toList(dataNames)) {
        decls += [ dataDecl(n) ];
    }

    return mkModule(decls, globals);
}

public Module implodeFromString(str code, loc origin) {
    return buildModuleFromSource(code);
}

public Module implodeFromFile(loc file) {
    str code = readFile(file);
    return buildModuleFromSource(code);
}
