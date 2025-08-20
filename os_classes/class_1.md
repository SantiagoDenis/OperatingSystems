
# Clase 1 – Sistemas Operativos **Capítulos 2 y 4 – OSTEP (Operating Systems: Three Easy Pieces)**

## 📌 Introducción  

- Un **sistema operativo (OS)** es un software que administra el hardware y provee abstracciones para facilitar el desarrollo y la ejecución de programas.  
- Su función principal es **virtualizar recursos** (CPU, memoria, almacenamiento) para que los programas se ejecuten como si tuvieran la máquina completa a disposición.  
- El OS también provee **mecanismos de control y protección**, garantizando que los procesos no interfieran entre sí y que el hardware se use eficientemente.  
- Resolver problemas en OS muchas veces es un problema **económico**: cómo compartir recursos escasos de manera justa y eficiente.

---

## 🖥️ Concepto de Proceso  

- El **proceso** es una de las abstracciones centrales de un OS.  
- Apareció en los años ’60 y se mantiene hasta hoy prácticamente sin cambios.  
- Puede pensarse como un **tipo abstracto de dato (TAD)** que contiene:  
  - Instrucciones (código ejecutable).  
  - Estado de la CPU (program counter, registros).  
  - Memoria asociada.  
  - Recursos asignados (archivos abiertos, dispositivos, etc.).  

### 🔑 API fundamental en UNIX (todas son *syscalls*)

- `fork()` → crea un nuevo proceso duplicando al proceso actual.  
- `exec()` → reemplaza la memoria e instrucciones del proceso por las de otro programa.  
- `exit()` → termina un proceso y libera sus recursos.  
- `wait()` → permite que un proceso padre espere a que sus hijos terminen (sincronización).  

👉 Con solo estas llamadas se puede construir una **shell**.

---

## 🌳 Jerarquía de Procesos  

- Al iniciar la máquina, el kernel crea el proceso **`init`** (PID 1).  
- Todos los demás procesos descienden de `init` → se forma un **árbol de procesos**.  
- Se puede visualizar con:  
  - `pstree` en consola.  
  - `htop` (con tecla `t` para vista en árbol).  

- La **process table** es una estructura (arreglo) mantenida por el kernel que guarda información sobre todos los procesos.  

---

## ⚙️ Ejecución de Procesos y `fork()`  

Ejemplo básico:
`
int r = fork();
if (r > 0) {
    // Código que ejecuta el padre
} else if (r == 0) {
    // Código que ejecuta el hijo
}
`

- El `fork()` **duplica el flujo de ejecución**:  

  - Al padre le devuelve el PID del hijo.  
  - Al hijo le devuelve 0.  

Ejemplo con múltiples forks:
`
fork();
fork();
printf("a\n");
`
Esto generará **4 procesos**, cada uno imprimiendo `"a"` → salida: 4 veces "a".

---

## ⚡ Manejo y Finalización de Procesos  

- `exit()` → termina el proceso y devuelve **todos sus recursos** al OS.  
- Procesos pueden ser eliminados por señales externas:  
  - `kill` o `xkill` (comando para usuarios).  
  - **OOM Killer** (Out-Of-Memory), un hilo del kernel que mata procesos que consumen demasiada memoria.  
- Si se elimina un **proceso padre**, generalmente también se eliminan sus hijos (*cascada*).  

---

## 📚 Relación con el Curso  

- Para el **primer parcial** solo entra **virtualización** (CPU y memoria).  
- Veremos también una pequeña introducción a **concurrencia**.  
- En los laboratorios, la práctica consistirá en implementar una **shell simple** usando estas syscalls (`fork`, `exec`, `wait`, `exit`).  

---

## 🧰 Herramientas útiles  

- **`htop`** → monitor de procesos interactivo.  
- **`pstree`** → muestra la jerarquía de procesos.  
- **`kill` / `xkill`** → finalizar procesos.  

---

## 📖 Resumen de ideas clave  

- El proceso es la unidad fundamental de ejecución.  
- Los procesos forman un árbol jerárquico iniciado por `init`.  
- El OS provee mecanismos simples (`fork`, `exec`, `exit`, `wait`) que permiten manejar toda la complejidad.  
- El kernel administra hardware pero no "entiende" de lenguajes: ejecuta **instrucciones binarias**.  
- El laboratorio pondrá en práctica estos conceptos implementando una shell.  
