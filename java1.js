let usuarios = [];

// ================================
// REGISTRAR USUARIO
// ================================

function registrarUsuario() {
    alert("===== REGISTRO DE USUARIO =====");

    let usuario = prompt("Ingrese su usuario:");
    if (!usuario) return; // Si cancela

    // Verificar si el usuario ya existe
    let usuarioEncontrado = usuarios.find(function (u) {
        return u.usuario === usuario;
    });

    if (usuarioEncontrado) {
        alert("El usuario ya existe.");
        return;
    }

    let clave = prompt("Ingrese su contraseña:");
    let claveIngresada = prompt("Repita su contraseña:");

    if (clave !== claveIngresada) {
        alert("Las contraseñas no coinciden.");
        return;
    }

    let saldo = parseFloat(prompt("Ingrese el saldo inicial:"));

    if (isNaN(saldo) || saldo < 0) {
        alert("El saldo no es válido.");
        return;
    }

    let nuevoUsuario = {
        usuario: usuario,
        clave: clave,
        saldo: saldo,
        bloqueado: false,
        movimientos: []
    };

    usuarios.push(nuevoUsuario);
    alert("Usuario registrado correctamente.");
}

// ================================
// INICIAR SESIÓN
// ================================

function iniciarSesion() {
    alert("===== INICIO DE SESIÓN =====");

    let usuarioIngresado = prompt("Ingrese su usuario:");
    let claveIngresada = prompt("Ingrese su contraseña:");

    let usuarioEncontrado = usuarios.find(function (u) {
        return u.usuario === usuarioIngresado;
    });

    if (!usuarioEncontrado) {
        alert("Usuario no encontrado.");
        return null;
    }

    if (usuarioEncontrado.bloqueado === true) {
        alert("La cuenta está bloqueada.");
        return null;
    }

    if (usuarioEncontrado.clave !== claveIngresada) {
        alert("Contraseña incorrecta.");
        return null;
    }

    alert("Inicio de sesión correcto.\nBienvenido " + usuarioEncontrado.usuario);
    return usuarioEncontrado;
}

// ================================
// CONSULTAR SALDO
// ================================

function consultarSaldo(usuario) {
    alert("===== CONSULTAR SALDO =====\nSu saldo actual es: $" + usuario.saldo);
}

// ================================
// CONSIGNAR DINERO
// ================================

function consignar(usuario) {
    alert("===== CONSIGNAR DINERO =====");

    let monto = parseFloat(prompt("Ingrese el monto a consignar:"));

    if (isNaN(monto) || monto <= 0) {
        alert("El monto no es válido.");
        return;
    }

    usuario.saldo = usuario.saldo + monto;
    alert("Consignación realizada correctamente.\nNuevo saldo: $" + usuario.saldo);
}

// ================================
// RETIRAR DINERO
// ================================

function retirar(usuario) {
    alert("===== RETIRAR DINERO =====");

    let monto = parseFloat(prompt("Ingrese el monto a retirar:"));

    if (isNaN(monto) || monto <= 0) {
        alert("El monto no es válido.");
        return;
    }

    if (monto > usuario.saldo) {
        alert("No tiene suficiente saldo.");
        return;
    }

    usuario.saldo = usuario.saldo - monto;
    alert("Retiro realizado correctamente.\nNuevo saldo: $" + usuario.saldo);
}

// ================================
// MENÚ DEL USUARIO
// ================================

function menuUsuario(usuario) {
    let opcion;

    do {
        opcion = prompt(
            "===== MENÚ DEL USUARIO =====\n" +
            "1. Consultar saldo\n" +
            "2. Consignar dinero\n" +
            "3. Retirar dinero\n" +
            "4. Cerrar sesión\n\n" +
            "Seleccione una opción:"
        );

        if (opcion === "1") {
            consultarSaldo(usuario);
        } else if (opcion === "2") {
            consignar(usuario);
        } else if (opcion === "3") {
            retirar(usuario);
        } else if (opcion === "4") {
            alert("Sesión cerrada.");
        } else if (opcion !== null) {
            alert("Opción no válida.");
        }

    } while (opcion !== "4" && opcion !== null);
}

// ================================
// MENÚ PRINCIPAL
// ================================

function menuPrincipal() {
    let opcion;

    do {
        opcion = prompt(
            "==============================\n" +
            "       SISTEMA BANCARIO\n" +
            "==============================\n" +
            "1. Registrar usuario\n" +
            "2. Iniciar sesión\n" +
            "3. Salir\n\n" +
            "Seleccione una opción:"
        );

        if (opcion === "1") {
            registrarUsuario();
        } else if (opcion === "2") {
            let usuario = iniciarSesion();
            if (usuario !== null) {
                menuUsuario(usuario);
            }
        } else if (opcion === "3") {
            alert("Gracias por utilizar el sistema.");
        } else if (opcion !== null) {
            alert("Opción no válida.");
        }

    } while (opcion !== "3" && opcion !== null);
}

// Iniciar el programa automáticamente al cargar
menuPrincipal();