# Función para mostrar programas que se ejecutan al inicio de sesión
function iniprogs {
    Write-Host "Programas que se ejecutan al inicio de sesión:"
    Get-CimInstance -ClassName Win32_StartupCommand | Format-Table -AutoSize
}

# Función para guardar un listado de procesos en un archivo CSV e imprimirlo
function CSV {
    $lista = Get-Process | ForEach-Object { $_.ProcessName }
    $csvFile = "$env:TEMP\proc.csv"
    
    # Guardar los nombres de los procesos en una cadena separada por comas
    $lista -join "," | Out-File -FilePath $csvFile -Encoding UTF8
    Write-Host "Contenido del archivo CSV:"
    Get-Content $csvFile
}

# Función para listar y detener procesos con alto consumo de CPU
function CPUAlta {
    $maxcon = Get-Process | Sort-Object CPU -Descending | Where-Object { $_.CPU -gt 0 }
    Write-Host "Procesos con mayor consumo de CPU:" -ForegroundColor Yellow
    $altcpu | Format-Table -AutoSize

        $maxcon = $altcpu | Select-Object -First 1
        Write-Host "Deteniendo proceso con mayor consumo de CPU: $($maxcon.Name) (ID: $($maxcon.Id))" -ForegroundColor Red
        Stop-Process $maxcon.Id -Force

}

# Función para mostrar y detener procesos con más de 100 MB de memoria
function MemAlta {
    $memcon = Get-Process | Where-Object { $_.WS -gt 100MB }
    Write-Host "Procesos que utilizan más de 100 MB de memoria:" -ForegroundColor Yellow
    $memcin | Select-Object Name, Id, WS | Format-Table -AutoSize

        foreach ($proc in $memcon) {
            Write-Host "Deteniendo proceso: $($proc.Name) (ID: $($proc.Id))" -ForegroundColor Red
            Stop-Process $proc.Id -Force
        }
}

# Función para mostrar el menú
function Menu {
    Write-Host "Seleccione una opción:"
    Write-Host "1. Mostrar programas que se ejecutan al inicio de sesión"
    Write-Host "2. Guardar un listado de procesos en CSV e imprimir"
    Write-Host "3. Listar y detener procesos con alto consumo de CPU"
    Write-Host "4. Mostrar y detener procesos con más de 100 MB de memoria"
    Write-Host "5. Salir"
}

# Loop principal
do {
    Menu
    $op = Read-Host "Ingrese su opción (1-5)"

    switch ($op) {
        1 { iniprogs }
        2 { CSV }
        3 { CPUAlta }
        4 { MemAlta }
        5 { Write-Host "Saliendo..."; }
        default { Write-Host "Opción inválida. Intente de nuevo." }
    }

    Write-Host "`nPresione Enter para continuar..."
    
  

} while ($op -ne 5)

