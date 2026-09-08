
// ================================
// CARGAR DATOS DE LOCALSTORAGE
// ================================

// 1. guardar usuaro en local store¡age
let usuariosGuardados = localStorage.getItem("usuarios");


let usuarios = usuariosGuardados ? JSON.parse(usuariosGuardados) : [];


function guardarEnLocalStorage() {
    localStorage.setItem("usuarios", JSON.stringify(usuarios));
}

// ================================
// REGISTRAR USUARIO
// ================================

function registrarUsuario() {
    alert("===== REGISTRO DE USUARIO =====");

    let usuario = prompt("Ingrese su usuario:");
    if (!usuario) return; // Si cancela o deja vacío

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

    // Estructura del movimiento inicial
    let movimientoInicial = {
        tipo: "Apertura de cuenta",
        monto: saldo,
        fecha: new Date().toLocaleString()
    };

    let nuevoUsuario = {
        usuario: usuario,
        clave: clave,
        saldo: saldo,
        bloqueado: false,
        movimientos: [movimientoInicial] // Guardamos el primer movimiento
    };

    usuarios.push(nuevoUsuario);

    // Guardamos en el navegador
    guardarEnLocalStorage();

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

    // Registrar el movimiento
    usuario.movimientos.push({
        tipo: "Consignación",
        monto: monto,
        fecha: new Date().toLocaleString()
    });

    // Guardar los cambios actualizados en el localStorage
    guardarEnLocalStorage();

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

    // Registrar el movimiento
    usuario.movimientos.push({
        tipo: "Retiro",
        monto: monto,
        fecha: new Date().toLocaleString()
    });

    // Guardar los cambios actualizados en el localStorage
    guardarEnLocalStorage();

    alert("Retiro realizado correctamente.\nNuevo saldo: $" + usuario.saldo);
}

// ================================
// CONSULTAR MOVIMIENTOS
// ================================

function verMovimientos(usuario) {
    alert("===== HISTORIAL DE MOVIMIENTOS =====");

    if (usuario.movimientos.length === 0) {
        alert("No hay movimientos registrados.");
        return;
    }

    let historialTexto = "Movimientos de " + usuario.usuario + ":\n\n";

    // Recorremos el arreglo de movimientos para armar la lista
    usuario.movimientos.forEach(function (mov, indice) {
        historialTexto += (indice + 1) + ". " + mov.tipo + ": $" + mov.monto + " (" + mov.fecha + ")\n";
    });

    alert(historialTexto);
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
            "4. Ver historial de movimientos\n" +
            "5. Cerrar sesión\n\n" +
            "Seleccione una opción:"
        );

        if (opcion === "1") {
            consultarSaldo(usuario);
        } else if (opcion === "2") {
            consignar(usuario);
        } else if (opcion === "3") {
            retirar(usuario);
        } else if (opcion === "4") {
            verMovimientos(usuario);
        } else if (opcion === "5") {
            alert("Sesión cerrada.");
        } else if (opcion !== null) {
            alert("Opción no válida.");
        }

    } while (opcion !== "5" && opcion !== null);
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

// Inicia el programa automáticamente al cargar
menuPrincipal();