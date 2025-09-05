# Clase 4 – Sistemas Operativos  

**Capítulos 7 y 8 – OSTEP (Scheduling)**  

## 📌 Introducción  

- Scheduling = política de administración de recursos escasos.  
- Supuestos iniciales:  
  - 1 core.  
  - Todos los procesos CPU-bound.  
  - Todos llegan en T = 0.  

- Conceptos:  
  - **Starvation:** un proceso nunca llega a ejecutarse aunque esté planificado.  
  - **Apropiativo:** el OS puede interrumpir un proceso en ejecución.  
  - **Batch vs Interactivo:** clasificación de cargas de trabajo.  

- Por el *Halting Problem* no podemos saber a priori si un proceso terminará.  

---

## 📂 Políticas de Scheduling  

| Scheduler | Apropiativo | Starvation | Tipo de carga | Necesita conocer T |
|-----------|-------------|------------|---------------|---------------------|
| FIFO      | No          | No         | Lote          | No                  |
| SJF       | No          | Sí         | Lote          | Sí                  |
| STCF      | Sí          | No         | Lote (con precaución) | Sí          |
| RR        | Sí          | No         | Interactivo   | No                  |
| MLFQ      | Sí          | No         | Interactivo   | ???                 |  

---

## ⚡ Multilevel Feedback Queue (MLFQ)  

- Idea: estimar el **quantum** que necesita cada proceso.  
- Procesos I/O-bound → prioridad alta.  
- Procesos CPU-bound → prioridad baja.  
- Funcionamiento:  
  - Se asigna un quantum inicial corto.  
  - Si consume todo el quantum, el proceso baja de prioridad.  
  - Quantums crecen en potencias de 2: Q=1, 2, 4, 8…  
  - Cada cierto tiempo, todos los procesos se reinician en la cola superior.  

👉 Resultado: procesos interactivos tienen buena respuesta, CPU-bound no bloquean al sistema.  

---

## ⚠️ Observaciones  

- Todas las políticas pueden “buggearse” en escenarios específicos.  
- No existe un algoritmo perfecto → se elige en función de la carga de trabajo.  

---

## 📖 Resumen de ideas clave  

- Scheduling administra la CPU entre múltiples procesos.  
- Diferencia entre políticas por: apropiación, starvation y tipo de carga.  
- FIFO, SJF, STCF, RR y MLFQ tienen ventajas y desventajas.  
- MLFQ ajusta dinámicamente la prioridad según el comportamiento del proceso.  
