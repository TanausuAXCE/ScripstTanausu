# Variable que contiene los nombres de cada tipo distinto de log.
$Log = Get-EventLog * | Select-Object -ExpandProperty Log
$num = 1

# Función de menú
function Menu  {

    # Bucle para crear la parte visual del menú automáticamente.
    foreach ($L in $Log ){
        Write-Host "$num. $L"

        $num++
    }

    Write-Host "0. Salida"
}

# Función que nos da los logs por pantalla según opción dada
function gensw {

# Revisamos que la opción dada por el usuario esta en un rango determinado.
    if ($op -ge 1 -and $op -le $Log.Length) {

    # Variable que creamos para a su vez revisar si la opción pedida tiene entradas o no.
        $count = Get-EventLog -LogName $Log[$op -1] -ErrorAction SilentlyContinue -Newest 12 

        if ($count.Count -eq 0) {
        
            Write-Host "Esta opción no tiene registros."
            Write-Host " "
        
        } else {
        
            $count
            Write-Host " "
        
        }
    } elseif ($op -eq 0) {
            Write-Host "Hasta la próxima"

        } 
      else {
            Write-Host "Opción no válida. Intente de nuevo."
    }
}


# Bucle menú
do {

    Menu
    $op = Read-Host "Seleccione una opción:"
    gensw
    
} while ($op -ne 0)
