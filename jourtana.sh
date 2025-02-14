#!/bin/bash

# Comprobar si se pasan exactamente 3 parámetros
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <año> <mes> <día>"
    exit 1
fi

# Asignar parámetros a variables
y=$1
m=$2
d=$3

# Validar que el primer parámetro (año) sea un número de 4 dígitos
if ! [[ "$y" =~ ^[0-9]{4}$ ]]; then
    echo "Error: El primer parámetro debe ser un año válido de 4 dígitos (YYYY)."
    exit 1
fi

# Validar que el segundo parámetro (mes) sea un número entre 1 y 12
if ! [[ "$m" =~ ^[0-9]{1,2}$ ]] || [ "$m" -lt 1 ] || [ "$m" -gt 12 ]; then
    echo "Error: El segundo parámetro debe ser un mes válido (número entre 1 y 12)."
    exit 1
fi

# Validar que el tercer parámetro (día) sea un número entre 1 y 31
if ! [[ "$d" =~ ^[0-9]{1,2}$ ]] || [ "$d" -lt 1 ] || [ "$d" -gt 31 ]; then
    echo "Error: El tercer parámetro debe ser un día válido (número entre 1 y 31)."
    exit 1
fi

# Crear una fecha válida para comparar
fecent="$y-$m-$d"
fecact=$(date +"%Y-%m-%d")

# Validar la fecha proporcionada
if ! date -d "$fecent" &> /dev/null; then
    echo "Error: Fecha no válida. Verifique que el formato y valores sean correctos."
    exit 1
fi

# Comprobar si la fecha es posterior a la fecha actual
if [[ "$fecent" > "$fecact" ]]; then
    echo "Error: La fecha proporcionada es posterior a la fecha actual."
    exit 1
fi

# Mostrar la búsqueda de logs
echo "Buscando registros desde $fecent hasta hoy ($fecact)..."

# Filtrar logs desde la fecha indicada hasta hoy y contar por niveles de severidad
for level in emerg alert crit err warning notice info debug; do
    count=$(journalctl --since="$fecent" --priority="$level" | wc -l)
    echo "Número de registros de nivel '$level': $count"
done
