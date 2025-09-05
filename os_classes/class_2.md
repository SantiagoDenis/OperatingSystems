# Clase 2 – Sistemas Operativos  

**Capítulos 2 y 4 – OSTEP**  

## 📌 Ejecución Directa Limitada (LDE)  

- Decisión de diseño implementada hace ~70 años.  
- Permite ejecutar programas de usuario directamente en la CPU, pero con restricciones.  
- Ejemplo:

  ```bash
  cat /dev/random > ls
  chmod +x ls
  ./ls
  ```  

  → El sistema debe protegerse contra la ejecución de binarios arbitrarios.  
- LDE evita que programas maliciosos dañen el sistema.  

---

## 📂 ELF y Relocalización  

- Los binarios en UNIX/Linux se empaquetan en formato **ELF**.  
- Este formato permite distinguir ejecutables válidos de datos basura.  
- Problema: si un programa solo usa direcciones absolutas, no es relocalizable.  

---

## 🖥️ Context Switching y PCB  

- Idea introducida en los ’60 con los **TSS (Task State Segment)**.  
- Un proceso puede pausarse con señales (`kill -stop PID`).  
- Cada proceso tiene un **PCB (Process Control Block)** que guarda registros y estado.  
- La **trap table** indica dónde salta el kernel ante interrupciones.  

---

## ⚡ User Mode vs Kernel Mode  

- En **user mode**, los procesos tienen permisos restringidos.  
- Intentar instrucciones privilegiadas genera **segmentation fault**.  
- El kernel está presente en todos los procesos y se accede mediante **syscalls**.  

---

## 📌 Syscalls y Traps  

- Syscalls = llamadas controladas del usuario al kernel.  
- Siempre se implementan con un **trap** (interrupción controlada).  
- Ejemplo: división por cero genera una interrupción implícita.  
- Interrupciones también pueden venir de hardware (teclado, temporizador).  

### Kernel Stack vs User Stack  

- El **user stack** almacena llamadas de funciones del programa.  
- El **kernel stack** almacena el contexto al ocurrir un trap (seguro y aislado).  
- El cambio de contexto ocurre sobre el **kernel stack**, no sobre el user stack.  

---

## 📂 Memoria del Proceso  

- **Heap:** administrado por librerías de usuario (`malloc`, `free`).  
- **User stack:** parámetros y direcciones de retorno.  
- Ambos conviven en RAM, “espalda contra espalda”.  

---

## 💤 Idle Process  

- Si no hay procesos para ejecutar, el sistema corre un **idle process** (proceso vacío).  

---

## 📖 Resumen de ideas clave  

- LDE permite ejecutar programas en CPU con seguridad.  
- ELF asegura formato ejecutable válido.  
- Context switching se basa en PCBs y kernel stack.  
- User/kernel mode protegen al sistema.  
- Syscalls usan traps como mecanismo seguro.  
- El idle process garantiza que siempre haya algo en ejecución.  
