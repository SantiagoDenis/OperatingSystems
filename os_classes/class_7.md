# Clase 7 – Sistemas Operativos  

**Tema: Paginación (Paging) y Tablas de Páginas**  

## 📌 Introducción  

- La **segmentación** usa registros (base, límite, permisos R/W/X) para virtualizar memoria.  
- Problema: la segmentación introduce **fragmentación externa**.  
- Solución: dividir la memoria en bloques fijos llamados **páginas** → elimina la fragmentación externa.  
- Paging puede verse como una “exageración” de segmentación.  

---

## 📖 Definición de Paging  

- Paging = función que mapea **marcos virtuales** (virtual frames) en **marcos físicos** (physical frames).  
- Tamaño típico de página: **4 KB** (2^12 = 4096 bytes).  
- La dirección virtual se divide en:  
  - **Offset** (12 bits) → va directo a memoria física.  
  - **Virtual frame** (resto de bits) → se traduce mediante la **page table**.  

---

## ⚡ Propiedades de la Función de Mapeo  

- Puede ser **inyectiva o no**: dos direcciones virtuales pueden mapear al mismo marco físico.  
- Puede ser **total o parcial**: se pueden dejar huecos sin mapear para proteger memoria (ej: separar stack y heap).  
- No es **sobreyectiva**: no todos los marcos físicos son necesariamente usados.  

Ejemplo: `fork()` con **Copy-on-Write (COW)**  

- Inicialmente, padre e hijo comparten páginas de solo lectura.  
- Si uno escribe, se copia la página → eficiencia y aislamiento.  
- Optimización: bibliotecas compartidas (ej: libc) se cargan una sola vez en RAM.  

---

## 🖥️ Page Faults y Page Out  

- **Page Fault:** intento de acceder a una página no cargada → el OS la trae desde disco.  
- **Page Out:** mover páginas inactivas de RAM al disco para liberar memoria.  
- Estrategias permiten que el OS reaccione a cambios dinámicos (ej: servidores web con picos de tráfico).  

---

## 📊 Ejemplo de Traducción con Page Table  

Supongamos páginas de 4K

- Dirección virtual: 15 bits.  
  - 12 bits → offset.  
  - 3 bits → índice en la page table (8 entradas).  

Ejemplo de Page Table:  

```asm
0: 001
1: 000
2: 011
3: 010
4: 101
5: 100
6: 111
7: 110
```  

Traducción

- Dirección virtual: `00011111111111`  
- Se convierte en dirección física: `00111111111111`  

👉 Permite cualquier **permutación** de marcos virtuales a físicos.  

---

## 📂 Page Table Entry (PTE)  

Cada entrada de la page table contiene:  

- **R/W/X** → permisos.  
- **P (Present bit):** indica si la página está mapeada.  
- **Frame físico** → al que apunta el marco virtual.  

El **MMU (Memory Management Unit)** realiza esta traducción en hardware.  

---

## ⚡ Usos Avanzados  

- **Ring Buffers:** mapear varias páginas virtuales al mismo marco físico para optimizar rendimiento.  
- **Self-Referencing Page Table:** la page table debe estar mapeada en memoria virtual, permitiendo al sistema acceder a su propia estructura.  

---

## 🏗️ Limitaciones y Tablas Multinivel  

Problema: en arquitecturas de 32 bits →  

- Dirección virtual: 32 bits = 20 bits de frame + 12 bits offset.  
- Page Table única = 2^20 entradas × 4 bytes ≈ 4 MB por proceso.  
- En sistemas antiguos (1–2 MB de RAM), la page table sola consumía casi toda la memoria.  

**Solución:** Tablas multinivel (ej: Intel 80386).  

- Dividir los 20 bits en 10 + 10.  
- Primeros 10 bits → índice en el **Page Directory (PD)**.  
- Siguientes 10 bits → índice en la **Page Table**.  
- 12 bits → offset.  

Esto genera una estructura jerárquica en forma de árbol → permite mapear solo las regiones necesarias, reduciendo memoria desperdiciada.  

---

## 📖 Resumen de ideas clave  

- Paging evita la fragmentación externa de segmentación.  
- Traducción = virtual frame → physical frame + offset.  
- Propiedades: funciones totales/parciales, inyectivas/no inyectivas.  
- Optimización: Copy-on-Write, bibliotecas compartidas, page out.  
- PTE = permisos + bit de presencia + frame físico.  
- Problema de espacio resuelto con **tablas multinivel**.  
