Algoritmo sin_titulo
	// ==============================================
	// SISTEMA BANCARIO "MI PLATA"
	// ==============================================
	
	// ==============================================
	// FUNCIONES DE ALMACENAMIENTO
	// ==============================================
	
	function obtenerUsuarios() {
	const datos = localStorage.getItem("usuariosBanco");
return datos ? JSON.parse(datos) : [];
	}
	
	function guardarUsuarios(usuarios) {
	localStorage.setItem("usuariosBanco", JSON.stringify(usuarios));
	}
	
	// ==============================================
	// FUNCIONES DE VALIDACIÓN
	// ==============================================
	
	function esUsuarioDisponible(nombreUsuario) {
	const usuarios = obtenerUsuarios();
	return !usuarios.some(u => u.usuario === nombreUsuario);
	}
	
	function validarMontoPositivo(monto) {
	return !isNaN(monto) & monto > 0;
	}
	
	// ==============================================
	// MÓDULO DE REGISTRO
	// ==============================================
	
	function registrarUsuario() {
	alert("=== FORMULARIO DE REGISTRO ===");
	
	let usuario = prompt("Ingrese su nombre de usuario:");
	if (!usuario) {
    alert("? El nombre de usuario no puede estar vacío.");
    return;
	}
	
	if (!esUsuarioDisponible(usuario)) {
    alert("? Este nombre de usuario ya está registrado.");
    return;
	}
	
	let clave = prompt("Ingrese su contraseña:");
	if (!clave) {
    alert("? La contraseña no puede estar vacía.");
    return;
	}
	
	let repetirClave = prompt("Repita su contraseña:");
	if (clave <>= repetirClave) {
    alert("? Las contraseñas no coinciden.");
    return;
	}
	
	let saldoInicial = prompt("Ingrese su saldo inicial:");
	saldoInicial = parseFloat(saldoInicial);
	if (!validarMontoPositivo(saldoInicial)) {
    alert("? El saldo inicial debe ser un número positivo.");
    return;
	}
	
	const nuevoUsuario = {
usuario: usuario,
clave: clave,
saldo: saldoInicial,
bloqueado: false,
movimientos: []
	};
	
	nuevoUsuario.movimientos.push({
fecha: new Date().toLocaleString(),
concepto: "Saldo inicial",
valor: saldoInicial,
saldo: saldoInicial
	});
	
	const usuarios = obtenerUsuarios();
	usuarios.push(nuevoUsuario);
	guardarUsuarios(usuarios);
	
	alert("? ¡Registro exitoso! Ya puedes iniciar sesión.");
	}
	
	// ==============================================
	// MÓDULO DE INICIO DE SESIÓN
	// ==============================================
	
	function iniciarSesion() {
	alert("=== INICIO DE SESIÓN ===");
	const usuarios = obtenerUsuarios();
	let intentos = 0;
	const MAX_INTENTOS = 3;
	
	while (intentos < MAX_INTENTOS) {
    const usuarioIngresado = prompt("Ingrese su usuario:");
    const claveIngresada = prompt("Ingrese su contraseña:");
	
    const usuarioEncontrado = usuarios.find(u => u.usuario === usuarioIngresado);
	
    if (!usuarioEncontrado) {
	intentos++;
alert(`?? Usuario no encontrado. Intentos restantes: ${MAX_INTENTOS - intentos}`);
    } else if (usuarioEncontrado.bloqueado) {
	alert("?? Esta cuenta está bloqueada. Comunícate con tu banco.");
	return null;
    } else if (usuarioEncontrado.clave <>= claveIngresada) {
	intentos++;
alert(`?? Contraseña incorrecta. Intentos restantes: ${MAX_INTENTOS - intentos}`);
    } else {
	alert("? ¡Bienvenido, " + usuarioIngresado + "!");
	return usuarioEncontrado;
    }
	}
	
	const usuarioBloqueado = usuarios.find(u => u.usuario === prompt("Ingrese su usuario:"));
	if (usuarioBloqueado) {
    usuarioBloqueado.bloqueado = true;
    guardarUsuarios(usuarios);
	}
	alert("?? Cuenta bloqueada por 24 horas, comunícate con tu banco");
	return null;
	}
	
	// ==============================================
	// RETIRAR DINERO
	// ==============================================
	
	function retirarDinero(usuarioActual, usuarios) {
	alert("=== RETIRO DE DINERO ===");
	const monto = parseFloat(prompt("Ingrese el monto a retirar:"));
	
	if (!validarMontoPositivo(monto)) {
    alert("? Monto inválido. Debe ser un número positivo.");
    return;
	}
	
	if (monto > usuarioActual.saldo) {
    alert("? Saldo insuficiente. No puedes retirar más de lo que tienes.");
    return;
	}
	
	usuarioActual.saldo -= monto;
	usuarioActual.movimientos.push({
fecha: new Date().toLocaleString(),
concepto: "Retiro",
valor: monto,
saldo: usuarioActual.saldo
	});
	
	guardarUsuarios(usuarios);
alert(`? Retiro exitoso.\nNuevo saldo: $${usuarioActual.saldo.toFixed(2)}`);
	}
	
	// ==============================================
	// CONSIGNAR DINERO
	// ==============================================
	
	function consignarDinero(usuarioActual, usuarios) {
	alert("=== CONSIGNACIÓN ===");
	const monto = parseFloat(prompt("Ingrese el monto a consignar:"));
	
	if (!validarMontoPositivo(monto)) {
    alert("? Monto inválido. Debe ser un número positivo.");
    return;
	}
	
	usuarioActual.saldo += monto;
	usuarioActual.movimientos.push({
fecha: new Date().toLocaleString(),
concepto: "Consignación",
valor: monto,
saldo: usuarioActual.saldo
	});
	
	guardarUsuarios(usuarios);
alert(`? Consignación exitosa.\nNuevo saldo: $${usuarioActual.saldo.toFixed(2)}`);
	}
	
	// ==============================================
	// CONSULTAR SALDO
	// ==============================================
	
	function consultarSaldo(usuarioActual) {
	alert("=== CONSULTA DE SALDO ===");
alert(`?? Tu saldo actual es: $${usuarioActual.saldo.toFixed(2)}`);
	}
	
	// ==============================================
	// CONSULTAR MOVIMIENTOS
	// ==============================================
	
	function consultarMovimientos(usuarioActual) {
	alert("=== HISTORIAL DE MOVIMIENTOS ===");
	if (usuarioActual.movimientos.length === 0) {
    alert("?? No hay movimientos registrados.");
    return;
	}
	
	let tabla = "Fecha y Hora\t\t| Concepto\t| Valor\t| Saldo\n";
	tabla += "----------------------------------------";
	usuarioActual.movimientos.forEach(m => {
    tabla += `\n${m.fecha} | ${m.concepto}\t| $${m.valor.toFixed(2)}\t| $${m.saldo.toFixed(2)}`;
	});
	
	alert(tabla);
	}
	
	// ==============================================
	// MENÚ DE TRANSACCIONES
	// ==============================================
	
	function mostrarMenuTransacciones(usuarioActual, usuarios) {
	let opcion;
	do {
    opcion = prompt(
	"=== MENÚ DE TRANSACCIONES ===\n" +
	"1. Retirar Dinero\n" +
	"2. Consultar Saldo\n" +
	"3. Consignar Dinero\n" +
	"4. Consultar Movimientos\n" +
	"5. Salir\n\n" +
	"Elige una opción:"
    );
	
    switch (opcion) {
case "1": retirarDinero(usuarioActual, usuarios); break;
case "2": consultarSaldo(usuarioActual); break;
case "3": consignarDinero(usuarioActual, usuarios); break;
case "4": consultarMovimientos(usuarioActual); break;
case "5": alert("?? Sesión cerrada. ¡Hasta luego!"); return;
default: alert("? Opción no válida. Intenta nuevamente.");
    }
	} while (opcion <>= "5");
	}
	
	// ==============================================
	// MENÚ PRINCIPAL
	// ==============================================
	
	function menuPrincipal() {
	let opcion;
	do {
    opcion = prompt(
	"=== SISTEMA BANCARIO 'MI PLATA' ===\n" +
	"1. Iniciar Sesión\n" +
	"2. Registrarse\n" +
	"3. Salir\n\n" +
	"Elige una opción:"
    );
	
    switch (opcion) {
case "1":
	const usuario = iniciarSesion();
	if (usuario) {
	const usuarios = obtenerUsuarios();
	mostrarMenuTransacciones(usuario, usuarios);
	}
	break;
case "2": registrarUsuario(); break;
case "3": alert("?? ¡Gracias por usar nuestros servicios!"); break;
default: alert("? Opción no válida. Intenta nuevamente.");
    }
	} while (opcion <>= "3");
	}
	
	// ==============================================
	// INICIAR EL SISTEMA
	// ==============================================
menuPrincipal();
FinAlgoritmo


// ==============================
// SISTEMA BANCARIO "MI PLATA"
// Autor: Jorge Albeiro Muriel Vélez
// ==============================

// ==============================================
// FUNCIONES DE ALMACENAMIENTO EN LOCALSTORAGE
// ==============================================

function obtenerUsuarios() {
const datos = localStorage.getItem("usuariosBanco");
return datos ? JSON.parse(datos) : [];
	}
	
	function guardarUsuarios(usuarios) {
	localStorage.setItem("usuariosBanco", JSON.stringify(usuarios));
	}
	
	// ==============================================
	// FUNCIONES DE VALIDACIÓN
	// ==============================================
	
	function esUsuarioDisponible(nombreUsuario) {
	const usuarios = obtenerUsuarios();
	return !usuarios.some(u => u.usuario === nombreUsuario);
	}
	
	function validarMontoPositivo(monto) {
	return !isNaN(monto) & monto > 0;
	}
	
	// ==============================================
	// MÓDULO DE REGISTRO DE USUARIOS
	// ==============================================
	
	function registrarUsuario() {
	alert("=== FORMULARIO DE REGISTRO ===");
	
	let usuario = prompt("Ingrese su nombre de usuario:");
	if (!usuario) {
    alert("? El nombre de usuario no puede estar vacío.");
    return;
	}
	
	if (!esUsuarioDisponible(usuario)) {
    alert("? Este nombre de usuario ya está registrado.");
    return;
	}
	
	let clave = prompt("Ingrese su contraseña:");
	if (!clave) {
    alert("? La contraseña no puede estar vacía.");
    return;
	}
	
	let repetirClave = prompt("Repita su contraseña:");
	if (clave <>= repetirClave) {
    alert("? Las contraseñas no coinciden.");
    return;
	}
	
	let saldoInicial = prompt("Ingrese su saldo inicial:");
	saldoInicial = parseFloat(saldoInicial);
	if (!validarMontoPositivo(saldoInicial)) {
    alert("? El saldo inicial debe ser un número positivo.");
    return;
	}
	
	const nuevoUsuario = {
usuario: usuario,
clave: clave,
saldo: saldoInicial,
bloqueado: false,
movimientos: []
	};
	
	nuevoUsuario.movimientos.push({
fecha: new Date().toLocaleString(),
concepto: "Saldo inicial",
valor: saldoInicial,
saldo: saldoInicial
	});
	
	const usuarios = obtenerUsuarios();
	usuarios.push(nuevoUsuario);
	guardarUsuarios(usuarios);
	
	alert("? ¡Registro exitoso! Ya puedes iniciar sesión.");
	}
	
	// ==============================================
	// MÓDULO DE INICIO DE SESIÓN
	// ==============================================
	
	function iniciarSesion() {
	alert("=== INICIO DE SESIÓN ===");
	const usuarios = obtenerUsuarios();
	let intentos = 0;
	const MAX_INTENTOS = 3;
	
	while (intentos < MAX_INTENTOS) {
    const usuarioIngresado = prompt("Ingrese su usuario:");
    const claveIngresada = prompt("Ingrese su contraseña:");
	
    const usuarioEncontrado = usuarios.find(u => u.usuario === usuarioIngresado);
	
    if (!usuarioEncontrado) {
	intentos++;
alert(`?? Usuario no encontrado. Intentos restantes: ${MAX_INTENTOS - intentos}`);
    } else if (usuarioEncontrado.bloqueado) {
	alert("?? Esta cuenta está bloqueada. Comunícate con tu banco.");
	return null;
    } else if (usuarioEncontrado.clave <>= claveIngresada) {
	intentos++;
alert(`?? Contraseña incorrecta. Intentos restantes: ${MAX_INTENTOS - intentos}`);
    } else {
	alert("? ¡Bienvenido, " + usuarioIngresado + "!");
	return usuarioEncontrado;
    }
	}
	
	// Bloquear cuenta tras 3 fallos
	const usuarioBloqueado = usuarios.find(u => u.usuario === prompt("Ingrese su usuario para bloquear la cuenta:"));
	if (usuarioBloqueado) {
    usuarioBloqueado.bloqueado = true;
    guardarUsuarios(usuarios);
	}
	alert("?? Cuenta bloqueada por 24 horas, comunícate con tu banco");
	return null;
	}
	
	// ==============================================
	// MÓDULO DE TRANSACCIONES
	// ==============================================
	
	function retirarDinero(usuarioActual, usuarios) {
	alert("=== RETIRO DE DINERO ===");
	const monto = parseFloat(prompt("Ingrese el monto a retirar:"));
	
	if (!validarMontoPositivo(monto)) {
    alert("? Monto inválido. Debe ser un número positivo.");
    return;
	}
	
	if (monto > usuarioActual.saldo) {
    alert("? Saldo insuficiente. No puedes retirar más de lo que tienes.");
    return;
	}
	
	usuarioActual.saldo -= monto;
	usuarioActual.movimientos.push({
fecha: new Date().toLocaleString(),
concepto: "Retiro",
valor: monto,
saldo: usuarioActual.saldo
	});
	
	guardarUsuarios(usuarios);
alert(`? Retiro exitoso.\nNuevo saldo: $${usuarioActual.saldo.toFixed(2)}`);
	}
	
	function consignarDinero(usuarioActual, usuarios) {
	alert("=== CONSIGNACIÓN ===");
	const monto = parseFloat(prompt("Ingrese el monto a consignar:"));
	
	if (!validarMontoPositivo(monto)) {
    alert("? Monto inválido. Debe ser un número positivo.");
    return;
	}
	
	usuarioActual.saldo += monto;
	usuarioActual.movimientos.push({
fecha: new Date().toLocaleString(),
concepto: "Consignación",
valor: monto,
saldo: usuarioActual.saldo
	});
	
	guardarUsuarios(usuarios);
alert(`? Consignación exitosa.\nNuevo saldo: $${usuarioActual.saldo.toFixed(2)}`);
	}
	
	function consultarSaldo(usuarioActual) {
	alert("=== CONSULTA DE SALDO ===");
alert(`?? Tu saldo actual es: $${usuarioActual.saldo.toFixed(2)}`);
	}
	
	function consultarMovimientos(usuarioActual) {
	alert("=== HISTORIAL DE MOVIMIENTOS ===");
	if (usuarioActual.movimientos.length === 0) {
    alert("?? No hay movimientos registrados.");
    return;
	}
	
	let tabla = "Fecha y Hora\t\t| Concepto\t| Valor\t| Saldo\n";
	tabla += "----------------------------------------";
	usuarioActual.movimientos.forEach(m => {
    tabla += `\n${m.fecha} | ${m.concepto}\t| $${m.valor.toFixed(2)}\t| $${m.saldo.toFixed(2)}`;
	});
	
	alert(tabla);
	}
	
	// ==============================================
	// MENÚ PRINCIPAL DE TRANSACCIONES
	// ==============================================
	
	function mostrarMenuTransacciones(usuarioActual, usuarios) {
	let opcion;
	do {
    opcion = prompt(
	"=== MENÚ DE TRANSACCIONES ===\n" +
	"1. Retirar Dinero\n" +
	"2. Consultar Saldo\n" +
	"3. Consignar Dinero\n" +
	"4. Consultar Movimientos\n" +
	"5. Salir\n\n" +
	"Elige una opción:"
    );
	
    switch (opcion) {
case "1":
	retirarDinero(usuarioActual, usuarios);
	break;
case "2":
	consultarSaldo(usuarioActual);
	break;
case "3":
	consignarDinero(usuarioActual, usuarios);
	break;
case "4":
	consultarMovimientos(usuarioActual);
	break;
case "5":
	alert("?? Sesión cerrada. ¡Hasta luego!");
	return;
default:
	alert("? Opción no válida. Intenta nuevamente.");
    }
	} while (opcion <>= "5");
	}
	
	// ==============================================
	// MENÚ PRINCIPAL DEL SISTEMA
	// ==============================================
	
	function menuPrincipal() {
	let opcion;
	do {
    opcion = prompt(
	"=== SISTEMA BANCARIO 'MI PLATA' ===\n" +
	"1. Iniciar Sesión\n" +
	"2. Registrarse\n" +
	"3. Salir\n\n" +
	"Elige una opción:"
    );
	
    switch (opcion) {
case "1":
	const usuario = iniciarSesion();
	if (usuario) {
	const usuarios = obtenerUsuarios();
	mostrarMenuTransacciones(usuario, usuarios);
	}
	break;
case "2":
	registrarUsuario();
	break;
case "3":
	alert("?? ¡Gracias por usar nuestros servicios!");
	break;
default:
	alert("? Opción no válida. Intenta nuevamente.");
    }
	} while (opcion <>= "3");
	}
	
	// ==============================================
	// EJECUCIÓN DEL PROGRAMA
	// ==============================================
menuPrincipal();
