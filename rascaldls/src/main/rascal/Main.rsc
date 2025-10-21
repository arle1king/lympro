module Main

import IO;
import Syntax;
import AST;
import Interpreter;
import ParseTree;

void main() {
    // CAMBIA ESTA RUTA a la ubicación de tu archivo de prueba.
    loc aluFile = |project://rascaldls/test.alu|;
    
    if (!exists(aluFile)) {
        println("Error: El archivo de prueba no se encuentra en <aluFile>");
        return;
    }
    
    str content = readFile(aluFile);
    
    // 1. Parsear el código a un ParseTree.
    start[Program] parseTree;
    try {
        parseTree = parse(#start[Program], content);
    } catch (ParseError e): {
        println("ERROR DE SINTAXIS: <e.message> en <e.location>");
        return;
    }
    
    // 2. Convertir el ParseTree a un AST (Árbol de Sintaxis Abstracta).
    Program ast = implode(parseTree);
    
    // 3. Evaluar el AST y mostrar el resultado en la consola.
    println("--- Ejecutando programa ALU ---");
    try {
        value result = eval(ast);
        println("--- Ejecución terminada ---");
        println("Resultado final del programa: <result>");
    } catch str s: {
        println("ERROR EN TIEMPO DE EJECUCIÓN: <s>");
    }
}