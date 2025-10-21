module Value

// Definición de valores que puede tener una expresión
data Value
    = integer(int val)
    | boolean(bool val)
    | string(str val)
    ;

// Operaciones aritméticas sobre valores
Value +(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return integer(a + b);
        case (string(str a), string(str b)): return string(a + b);
        case (string(str a), integer(int b)): return string(a + toString(b));
        case (integer(int a), string(str b)): return string(toString(a) + b);
        default: throw "Operación + no soportada entre estos tipos";
    }
}

Value -(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return integer(a - b);
        default: throw "Operación - no soportada entre estos tipos";
    }
}

Value *(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return integer(a * b);
        default: throw "Operación * no soportada entre estos tipos";
    }
}

Value /(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): 
            if (b == 0) throw "División por cero";
            return integer(a / b);
        default: throw "Operación / no soportada entre estos tipos";
    }
}

Value **(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return integer(a ^ b);
        default: throw "Operación ** no soportada entre estos tipos";
    }
}

// Operaciones de comparación
bool <(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return a < b;
        default: throw "Operación < no soportada entre estos tipos";
    }
}

bool >(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return a > b;
        default: throw "Operación > no soportada entre estos tipos";
    }
}

bool <=(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return a <= b;
        default: throw "Operación <= no soportada entre estos tipos";
    }
}

bool >=(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return a >= b;
        default: throw "Operación >= no soportada entre estos tipos";
    }
}

bool ==(Value l, Value r) {
    return visit(l, r) {
        case (integer(int a), integer(int b)): return a == b;
        case (boolean(bool a), boolean(bool b)): return a == b;
        case (string(str a), string(str b)): return a == b;
        default: return false;
    }
}

bool <>(Value l, Value r) {
    return !(l == r);
}

// Función para convertir Value a bool (para condiciones)
bool toBool(Value v) {
    return visit(v) {
        case boolean(bool b): return b;
        case integer(int i): return i != 0;
        case string(str s): return s != "";
        default: return false;
    }
}
