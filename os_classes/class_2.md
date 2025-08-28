# Clase 2 – Sistemas Operativos  
**Capítulos 2 y 4 – OSTEP (Operating Systems: Three Easy Pieces)**

## 📌 Ejecución Directa Limitada (LDE)  
- Decisión de diseño de hace ~70 años para permitir que programas de usuario se ejecuten **directamente en la CPU**, pero con restricciones de seguridad.  
- Sin LDE, cualquier binario aleatorio podría ejecutarse y dañar la máquina.  
- Ejemplo:  
  ```bash
  cat /dev/random > ls
  chmod +x ls
  ./ls
  ```  
  Este "programa" podría ejecutarse, pero gracias a la LDE, el hardware/OS restringe lo que puede hacer.  
- LDE asegura que los programas no puedan **acceder directamente al hardware** ni romper el sistema.  

---

## 📂 Formato ELF  
- Todo programa ejecutable en UNIX/Linux está empaquetado en formato **ELF (Executable and Linkable Format)**.  
- El OS usa este formato para saber cómo cargar y ejecutar el binario.  
- Sin ELF, no habría distinción entre un archivo válido y basura.  

---

## 🖥️ User Mode vs Kernel Mode  
- **User mode**: modo restringido, en el que corren los procesos de usuario. No puede ejecutar instrucciones privilegiadas (ej: `STUR` en ciertas direcciones).  
- **Kernel mode**: modo privilegiado, donde corre el sistema operativo.  
- Intentar acceder al **kernel space** desde user mode → **segmentation fault**.  
- El kernel está presente en todos los procesos, pero solo es accesible mediante **syscalls**.  

👉 **Syscalls** = mecanismo seguro para que el user mode invoque funciones del kernel.  
👉 Siempre implican un **trap**.  

---

## ⚡ Traps e Interrupciones  
- **Trap** = interrupción → salto forzado al kernel (nombre viene de *trapdoor*).  
- Cuando ocurre:  
  1. Se guarda el **program counter (PC)** en el **kernel stack** (no en el user stack, porque es inseguro).  
  2. Se guarda el estado de registros (**snapshot**).  
  3. El kernel atiende la interrupción.  
  4. Con `return-from-trap`, se restaura el contexto y se vuelve a user space.  

Tipos de interrupciones:  
- **Explícitas**: syscalls, traps generadas por instrucciones.  
- **Implícitas**: errores como división por cero.  
- **Hardware**: teclado, temporizadores, dispositivos de E/S.  

Ejemplo: presionar una tecla genera una interrupción, y soltarla genera otra.  

---

## 🔄 Context Switching  
- Surge en los ’60 con el concepto de **TSS (Task State Segment)**.  
- El OS puede **pausar un proceso** en cualquier momento (ej: `kill -stop PID`).  
- Cada proceso tiene un **PCB (Process Control Block)** que guarda:  
  - Registros.  
  - PC.  
  - Estado de memoria.  
- El cambio de contexto ocurre en el **kernel stack**, no en el user stack.  

### Dinámica:  
1. El kernel recibe una interrupción.  
2. Decide (scheduler) si continuar con el mismo proceso o cambiar de contexto.  
3. Guarda el estado actual en el **PCB**.  
4. Restaura el estado de otro proceso desde su PCB.  
5. Actualiza el PC y los registros.  

👉 Así, el nuevo proceso continúa **como si nunca hubiera sido interrumpido**.  

---

## 🗂️ Memoria del Proceso  
- **User stack**:  
  - Se usa para llamadas a funciones (push de parámetros y direcciones de retorno).  
  - Crece hacia abajo en memoria.  
- **Heap**:  
  - Usado para asignación dinámica (malloc/free).  
  - Crece hacia arriba en memoria.  
  - Administrado por librerías de usuario, no por el kernel.  

El **stack** y el **heap** se encuentran “espalda contra espalda” en la RAM.  

---

## 💤 Idle Process  
- Cuando no hay ningún proceso para ejecutar, el OS corre un **idle process**.  
- Es un proceso que “no hace nada”, pero mantiene la CPU ocupada de forma controlada.  

---

## 📖 Resumen de ideas clave  
- **Ejecución Directa Limitada (LDE)** → permite ejecutar programas de usuario en CPU de forma segura.  
- **User/Kernel mode** → separación crítica para protección.  
- **Traps e interrupciones** → mecanismo de comunicación entre user space y kernel.  
- **Context switching** → cambio de proceso ocurre en el kernel, usando PCBs y kernel stack.  
- **Memoria de proceso** → stack y heap en RAM, con roles diferentes.  
- **Idle process** asegura que siempre haya algo en ejecución.  

---

📌 Estos conceptos son la base para entender cómo el OS administra la CPU y la memoria, y cómo implementa la virtualización de recursos.  
