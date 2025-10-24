module Main

import IO;
import Syntax;
import AST;
import Interpreter;
import ParseTree;
import util::Implode;

void main() {
    // CAMBIA ESTA LÍNEA A LA RUTA DE TU PROYECTO
    loc aluFile = |file:///C:/Users/valer/OneDrive/Escritorio/lympro/rascaldls/test.alu|;
    
    if (!exists(aluFile)) {
        println("Error: No se encuentra el archivo <aluFile>");
        return;
    }
    
    str content = readFile(aluFile);
    println("--- Contenido de test.alu ---");
    println(content);
    println("-----------------------------");
    
    start[Program] parseTree;
    try {
        parseTree = parse(#start[Program], content, aluFile);
    } catch (ParseError e): {
        println("ERROR DE SINTAXIS: <e.message> en <e.location>");
        return;
    }
    
    Program ast = implode(parseTree);
    
    println("--- Ejecutando Intérprete de ALU ---");
    try {
        value result = eval(ast);
        println("--- Ejecución Terminada ---");
        println("Valor de retorno de main: <result>");
    } catch str s: {
        println("ERROR EN TIEMPO DE EJECUCIÓN: <s>");
    }
}