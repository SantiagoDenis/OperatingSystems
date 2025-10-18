# Clase 9 – Sistemas Operativos  

**Tema: Concurrencia, Race Conditions y Exclusión Mutua**  

## 📌 Introducción  
La **concurrencia** se originó en los sistemas operativos con el objetivo de **mantener el hardware siempre ocupado**.  
El **context switching** fue creado para lograrlo, permitiendo alternar entre procesos cuando uno se bloquea o espera.  

---

## 🧩 Ejemplo inicial  
```asm
1) ldur x1, [x0, #0]
2) addi x1, x1, #2
3) stur x1, [x0, #0]

A) ldur x1, [x2, #0]
B) addi x1, x1, #1
C) stur x1, [x2, #0]
```
Si ambos hilos acceden a la misma dirección (`0xFAFA`), comparten memoria.  
Este modelo se llama **memoria compartida** y los procesos que la usan se conocen como **Light-Weight Processes (LWP)** o **threads**.  

- Cambiar de **proceso** es costoso (implica cambiar el mapa de memoria).  
- Cambiar de **hilo** es rápido (comparten el mismo mapa de memoria).  

👉 Si dos hilos apuntan a la misma dirección de memoria, **ven y modifican el mismo valor**.  
Esto genera el problema de **competencia por recursos (race condition)**.  

---

## 🧠 Race Conditions  
Si una dirección (ej. `0xFAFA = 0`) es accedida simultáneamente por dos hilos, el resultado final puede ser:  
- `1` o `2` (si corren en paralelo).  
- `3` (si se ejecutan secuencialmente).  

El orden de ejecución (interleaving) es **no determinista**.  

- Cada programa mantiene su orden interno.  
- El resultado depende del entrelazado de las instrucciones.  
- Un programa concurrente termina solo cuando **todas las componentes (threads)** terminan.  

La **corrección** en concurrencia significa: *“para toda planificación posible, el resultado debe ser el esperado.”*  

---

## 🧵 Hilos y la syscall `clone()`  
- En sistemas monohilo, `fork()` crea un nuevo proceso.  
- En sistemas multihilo, **pthread_create()** utiliza internamente la syscall **`clone()`**, que permite crear procesos o hilos que comparten recursos.  
- Cada hilo necesita su propio **stack** (para variables locales y llamadas a funciones).  
- El **kernel** administra los hilos; antes podían manejarse solo a nivel de usuario.  

---

## ⚔️ Condiciones de Carrera (Race Conditions)  
Cuando dos o más hilos compiten por un recurso compartido y el resultado depende del orden de ejecución.  

Ejemplo:  

**Programa A**
```
a = x        ||  a = x
a = a + 2    ||  a = a + 1
x = a        ||  x = a
```

**Programa B**
```
x = x + 2    ||  x = x + 1
```

- Si las operaciones de `x = x + 1` o `x = x + 2` son **atómicas**, no hay problema.  
- Si no lo son, pueden mezclarse y producir resultados indeterminados.  

---

## 🔒 Secciones Críticas y Locks  
Para garantizar atomicidad, se utilizan **locks**.  

Ejemplo:  

```
lock        lock
a = x   ||  a = x
a = a+2 ||  a = a+1
x = a   ||  x = a
unlock      unlock
```

Esto asegura que solo un hilo entre a la **Critical Section (CS)** a la vez.  

Valor inicial: `lock = 0` (desbloqueado)  

```c
while (lock == 1);  // esperar si otro hilo posee el lock
lock = 1;           // adquirir lock
CS();               // sección crítica
lock = 0;           // liberar lock
```

Problema: si ambos hilos pasan el `while` al mismo tiempo, entran juntos → **race condition**.  

---

## 🧮 Test and Set (TS)  
Solución a nivel hardware: una instrucción atómica que **lee y escribe** en un solo paso.  

```c
while (TS(lock, 1));  // esperar hasta que lock sea 0
CS();
lock = 0;
```

`TS(lock, 1)` devuelve el valor anterior y escribe 1 en `lock`.  
- Si el valor era 0 → entra a la CS.  
- Si era 1 → sigue esperando.  

### Spinlock y Livelock  
- Cuando un hilo espera activamente en un bucle (`while`), se llama **spinlock** (consume CPU).  
- Si varios hilos se bloquean mutuamente en spinlocks → **livelock**.  
- En esos casos conviene **dormir el proceso (`sleep()`)** en lugar de seguir esperando.  

---

## 🧩 Filosofía RISC-V: LL/SC  
En RISC-V, `Test and Set` va contra la filosofía RISC, por eso se usan:  
- **LL (Load-Linked)** y **SC (Store-Conditional)**.  

```c
done = false;
while (!done) {
    x0 = ll(lock);
    done = sc(lock, 1);
}
```

- `ll` lee la dirección de memoria y marca un bit interno.  
- `sc` intenta escribir solo si el bit sigue marcado (nadie más modificó la dirección).  
- Si otra CPU tocó esa dirección, `sc` falla y se repite el bucle.  

Este mecanismo implementa **exclusión mutua atómica** sin violar la simplicidad del conjunto de instrucciones RISC.  

---

## 📖 Resumen de ideas clave  
- La concurrencia busca maximizar el uso del hardware.  
- Threads comparten memoria, por lo tanto deben sincronizar accesos.  
- Las race conditions generan resultados no deterministas.  
- Locks y secciones críticas garantizan atomicidad.  
- `Test and Set` y `LL/SC` son mecanismos atómicos de sincronización.  
- Spinlocks son útiles en bucles cortos; en los largos conviene dormir el hilo.  
- La corrección en concurrencia exige que **todas las planificaciones produzcan el mismo resultado esperado**.  
