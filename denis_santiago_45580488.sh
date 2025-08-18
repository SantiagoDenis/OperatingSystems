#!/bin/bash

# EJERCICIO 1: Modelo del procesador
grep "model name" /proc/cpuinfo | head -1
# EJERCICIO 2: Número de unidades de ejecución (cores)
grep -m1 "cpu cores" /proc/cpuinfo | awk -F': ' '{print $2}'
# EJERCICIO 3: Lista de nombres de usuarios para red social de superhéroes
curl https://raw.githubusercontent.com/dariomalchiodi/superhero-datascience/master/content/data/heroes.csv | cut -d';' -f2 | sed 's/ /_/g' | tr 'A-Z' 'a-z' | sed '/^$/d' | sed '1d' > superheroes_usuarios.txt
# EJERCICIO 4A: Día de máxima temperatura en Córdoba
sort -n -r -k5 datos/weather_cordoba.in | awk '{print $1, $2, $3}' | head -n 1 
# EJERCICIO 4B: Día de mínima temperatura en Córdoba
sort -n -k6 datos/weather_cordoba.in | awk '{print $1, $2, $3}' | head -n 1
# EJERCICIO 5: Ordenar jugadores de tenis por ranking
sort -n -k3 datos/atpplayers.in
# EJERCICIO 6: Ordenar tabla de Superliga por puntos y diferencia de goles
awk '{$9 = $7-$8; print}' datos/superliga.in | sort -nr -k2,2 -k9,9 | awk '{print $1,$2,$3,$4,$5,$6,$7,$8}'
# EJERCICIO 7: MAC address de la placa WiFi del equipo
ip link show | grep -i -e "ether"
# EJERCICIO 8: Renombrar archivos de subtítulos
for file in serie_prueba/*_es.srt; do mv "$file" $(echo "$file" | sed 's/_es//'); done
# EJERCICIO 9A: Recortar video con ffmpeg
echo no lo hice
# EJERCICIO 9B: Mezclar audio con ffmpeg
echo no lo hice