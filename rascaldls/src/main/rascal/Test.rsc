module Test

import AST;
import Interpreter;
import Syntax;

// Función de prueba para verificar que el intérprete funciona
int testInterpreter() {
    // Crear un programa de prueba simple
    Program testProgram = program([
        functionDef("main", [], [
            assignment("x", literal(num(5))),
            assignment("y", literal(num(3))),
            expressionStatement(add(variable("x"), variable("y")))
        ])
    ]);
    
    // Ejecutar el programa
    Value result = eval(testProgram);
    
    // Verificar que el resultado es correcto
    if (result is integer(int val) && val == 8) {
        println("✓ Test básico pasado: 5 + 3 = 8");
        return 0;
    } else {
        println("✗ Test básico falló");
        return 1;
    }
}

// Función para probar operadores de comparación
int testComparison() {
    Program testProgram = program([
        functionDef("main", [], [
            expressionStatement(lt(literal(num(3)), literal(num(5))))
        ])
    ]);
    
    Value result = eval(testProgram);
    
    if (result is boolean(bool val) && val) {
        println("✓ Test de comparación pasado: 3 < 5 = true");
        return 0;
    } else {
        println("✗ Test de comparación falló");
        return 1;
    }
}

int main() {
    println("Ejecutando tests del intérprete...");
    
    int test1 = testInterpreter();
    int test2 = testComparison();
    
    if (test1 == 0 && test2 == 0) {
        println("✓ Todos los tests pasaron correctamente!");
        return 0;
    } else {
        println("✗ Algunos tests fallaron");
        return 1;
    }
}
