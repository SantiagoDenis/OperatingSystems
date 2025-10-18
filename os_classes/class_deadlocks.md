# Clase Deadlocks 

**Tema: Deadlocks y Productor–Consumidor**  

## 📌 Introducción  
Un **deadlock** (bloqueo mutuo o interbloqueo) es una situación en la que dos o más procesos quedan esperando indefinidamente recursos que otros poseen.  
Ejemplo clásico: un **mutex** que protege una zona crítica y nunca se libera.  

---

## ⚠️ Condiciones necesarias para un Deadlock  
Para que se produzca un deadlock deben cumplirse simultáneamente **cuatro condiciones**:  

1. **Exclusión mutua:** un recurso no puede ser compartido; solo un proceso puede usarlo a la vez.  
2. **Retención y espera:** un proceso mantiene al menos un recurso mientras espera por otro.  
3. **No expropiación (No preemption):** los recursos no pueden ser forzadamente retirados de un proceso; deben liberarse voluntariamente.  
4. **Espera circular:** existe una cadena de procesos donde cada uno espera un recurso que posee otro, formando un ciclo.  

👉 Si negamos **cualquiera** de estas condiciones, el deadlock no puede ocurrir.  

---

## 🧠 Prevención de Deadlocks  
Una estrategia común es negar la **espera circular**, garantizando un **orden fijo** en la adquisición de recursos.  
Esto se logra pidiendo semáforos siempre en el mismo orden.  

Ejemplo con dos hilos:  

| Hilo 1 | Hilo 2 |
|--------|--------|
| down(S0) | down(S1) |
| down(S1) | down(S0) |
| up(S0)   | up(S1)   |
| up(S1)   | up(S0)   |

- Si la ejecución es no determinista, puede ocurrir un deadlock si ambos hilos intentan tomar los semáforos en distinto orden.  
- Cualquier ejecución que pueda caer en deadlock indica que el programa **está mal diseñado**.  

---

## 🏭 Problema Productor–Consumidor  
Ejemplo clásico de sincronización con **semáforos**.  

### Productor
```c
while (1) {
    down(free);
    produce();
    up(full);
}
```

### Consumidor
```c
while (1) {
    down(full);
    consume();
    up(free);
}
```

### Inicialización de semáforos  
```
free = N;   // cantidad de espacios libres en el buffer
full = 0;   // cantidad de productos disponibles
```

El buffer se implementa como una **cola FIFO** de tamaño N (usando `enqueue` y `dequeue`).  

---

## ⚙️ Funcionamiento del Sistema  
- El **productor** puede ejecutar hasta N vueltas consecutivas antes de bloquearse (cuando el buffer está lleno).  
- El **consumidor** puede ejecutar mientras haya productos (`full > 0`).  
- Si el consumidor intenta consumir cuando `full = 0`, se bloquea hasta que el productor agregue un nuevo ítem.  

Esto crea un **colchón** (buffer) que permite absorber variaciones en la velocidad de producción y consumo.  

---

## ⚖️ Tradeoff: Espacio vs Concurrencia  
- Un buffer más grande ⇒ mayor **concurrencia** (menos bloqueos).  
- Pero también ⇒ mayor **uso de memoria**.  
- Por lo tanto, existe un **tradeoff entre espacio y paralelismo**.  

El tamaño del buffer determina el grado de libertad entre productores y consumidores:  
- **Buffer pequeño:** sincronización estricta.  
- **Buffer grande:** mayor paralelismo, pero más consumo de RAM.  

---

## 📖 Resumen de ideas clave  
- Deadlock = espera circular entre procesos que nunca se resuelve.  
- Se previene negando al menos una de las cuatro condiciones.  
- Ordenar la adquisición de semáforos evita espera circular.  
- El problema productor–consumidor modela concurrencia y sincronización.  
- El tamaño del buffer define el equilibrio entre espacio y concurrencia.  
