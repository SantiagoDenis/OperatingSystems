# Clase 6 – Sistemas Operativos | Trazas de memoria y segmentación  

## 🖥️ Programa en RISC-V

```asm
c:     lla a4,0x1000
10:    lla a3,0x2000
14:    mv a0,a3 
16:    lla a1,0x3000
1a:    ld a5, 0(a4)
1c:    slli a5,a5,0x3
1e:    add a5,a5,a1
20:    ld a2,0(a3)
22:    sd a2,0(a5)
24:    add a4,a4,8
26:    add a3,a3,8
28:    bne a4,a0,1a
2c:    ret
```

### 🔎 Explicación

- `lla` → carga direcciones inmediatas en registros.  
- `ld` → lee desde memoria (8 bytes, por lo tanto el programa trabaja con *long/punteros*).  
- `sd` → guarda en memoria.  
- `slli` → *shift left logical* inmediato (multiplica por potencias de 2).  
- `bne` → *branch if not equal*.  

👉 Este programa **recorre dos arrays** (`[0x1000...]` y `[0x2000...]`) y va guardando en el array `[0x3000...]`, usando el primer array como índice.  
En términos de alto nivel:  

```c
C[ indice[i] ] = B[i];
```

Es decir, realiza una **permutación** de un arreglo.  

---

## 📂 Memoria Inicial

```asm
1000: 0x5     2000: 0x2     3000: 0xAA
1008: 0x6     2008: 0x3     3008: 0xFF
1010: 0x3     2010: 0x5     3010: 0xAF
1018: 0x4     2020: 0x6     3018: 0xFF
                             3020: 0xAA
```

---

## 📝 Traza de Memoria

Durante la ejecución, el **program counter (PC)** va recorriendo instrucciones y accediendo a memoria de datos.  
Ejemplo de accesos:

```asm
0xc, 0x10, 0x14, 0x16, 0x1a, 0x1000, 0x1c, 0x1e, 0x20, 0x2000, 0x22, 0x3028, ...
```

- Se repite 512 veces (porque avanza de a 8 bytes hasta que `a4 == 0x2000`).  
- La última instrucción accedida es `0x2c` (`ret`).  

---

## 📌 Problemas que debe resolver un Sistema Operativo

Este programa motiva varios problemas clásicos de diseño de OS:

### 1. Relocalización (Reallocation)  

- Un programa debe poder ejecutarse en **cualquier lugar de memoria**.  
- Si el código tiene direcciones absolutas (ej: siempre usa `0x1000`), no puede relocalizarse.  
- Solución: usar **direcciones relativas al PC** + mecanismos del OS.  

### 2. Protección  

- Un proceso no debe acceder a la memoria de otro.  
- Se logra con **espacios de direcciones virtuales**, aislando cada programa.  

### 3. Eficiencia  

- El acceso a memoria debe ser rápido → hardware agrega comparadores y sumadores para validar accesos.  

---

## 🗂️ Segmentación con Base, Límite y Permisos (rwx)

Mecanismo clásico para lograr **virtualización de memoria**:

- **Base register** → suma un valor fijo a toda dirección virtual.  
- **Limit register** → define el tamaño máximo accesible.  
- **RWX bits** → controlan permisos de lectura, escritura y ejecución.  

👉 Cada acceso de memoria pasa por:  

1. **AND** con RWX (verificación de permisos).  
2. **Comparación** con Limit.  
3. **Suma** con Base.  

Ejemplo:  

- Para el programa anterior, límite ≈ `0x4000`.  
- Se requiere RWX = `111` (leer, escribir y ejecutar).  

---

## ⚠️ Fragmentación Externa

- Aun con segmentación, la memoria física puede quedar partida en huecos dispersos.  
- Esto dificulta asignar grandes bloques contiguos.  

---

## 🔎 Identificación de Segmentos

¿Cómo sé a qué segmento (código, stack, heap) pertenece una dirección virtual?

- **Explícito**: registros de control dedicados (ej: Intel).  
- **Implícito**: bits de la instrucción indican el segmento.  
  - Ejemplo:  
    - `00` → código.  
    - `10` → stack.  
    - `11` → heap.  

---

## 📖 Resumen de ideas clave

- El programa en RISC-V implementa una **permutación de un array** usando índices.  
- Esto motiva tres problemas de OS:  
  1. **Relocalización**.  
  2. **Protección**.  
  3. **Eficiencia**.  
- La **segmentación (base, limit, rwx)** permite resolverlos parcialmente.  
- El OS debe también lidiar con **fragmentación externa**.  
- Todo esto introduce la idea de **memoria virtual**: direcciones de juguete para los programas, traducidas por el hardware/OS a direcciones reales.  
