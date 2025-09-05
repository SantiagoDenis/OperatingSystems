# Clase 5 – Sistemas Operativos  

**Capítulos 13 y 14 – OSTEP (Memoria y Seguridad)**  

## 📌 Introducción  

- Antes de la DRAM (Robert Dennard, IBM) existía la *core memory* (ej: Apollo Guidance Computer).  
- Problema histórico: **fragmentación externa** en esquemas de memoria antiguos.  
- La **ABI (Application Binary Interface)** define convenciones como la inicialización de arreglos en memoria (ej: `int a[1<<30]` se inicializa en 0 sin reservar realmente todo el espacio).  
- El Address Space se divide en segmentos: **code, heap, stack**.  

---

## 🧮 Crecimiento del Heap  

- Cuando el heap necesita más espacio, el programa utiliza la syscall `brk` para mover el *break point* y agrandar el Address Space.  
- Ejemplo: malloc → internamente puede usar `brk` o `mmap`.  

---

## 🖥️ Syscalls y Recursos  

- `yield()` → cede voluntariamente la CPU.  
- `ulimit` → controla la cantidad máxima de procesos que puede crear un proceso mediante fork.  

---

## ⚔️ Seguridad y Ataques de Memoria  

### ROP (Return Oriented Programming)  

- Técnica de ataque:  
  - Inyectar datos maliciosos en el stack.  
  - Sobrescribir direcciones de retorno con *snippets* de código ya existente en memoria, terminados en `ret`.  
  - Al encadenar estos snippets, se ejecuta un programa arbitrario.  

- **Defensa:** ASLR (*Address Space Layout Randomization*).  
  - Carga los programas en direcciones aleatorias.  
  - Dificulta predecir direcciones para ejecutar ROP.  
  - Está activo en kernels modernos.  

### Heap Overflow  

- Otro ataque posible: sobrescribir estructuras de control en el heap para alterar la ejecución.  

---

## 📂 Justificación del Orden del Address Space  

El espacio de direcciones se organiza como:  

```c
Código (arriba)
Heap (crece hacia arriba)

--- espacio ---

Stack (crece hacia abajo)
```  

- Hay 4! formas de organizar los segmentos, pero esta es la más eficiente:  
  - **Código fijo**: no cambia en tiempo de ejecución.  
  - **Heap** crece dinámicamente hacia arriba.  
  - **Stack** crece dinámicamente hacia abajo.  
  - Se evita que colisionen fácilmente.  

---

## 🛠️ API de Memoria  

- `malloc(size)` → reserva memoria dinámica.  
- `free(ptr)` → libera memoria.  
- `calloc` y `realloc` son variantes derivadas de `malloc`.  

---

## 📖 Resumen de ideas clave  

- Evolución de la memoria: de *core memory* a DRAM.  
- Problemas: fragmentación externa y necesidad de relocalización.  
- Syscalls clave: `yield()`, `brk`.  
- Seguridad: ataques ROP y heap overflow → defensa con ASLR.  
- Address space organizado en segmentos para evitar colisiones.  
- API de memoria: malloc/free.  
