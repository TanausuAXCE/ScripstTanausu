$seractivos = Get-Service | Where-Object { $_.Status -eq 'Running' }
$serparados = Get-Service | Where-Object { $_.Status -eq 'Stopped' }

$totact = $seractivos.Count
$totpar = $serparados.Count
$totser = $totact + $totpar

$table = @{
    'Activo' = $totact
    'Parados' = $totpar
    'Total' = $totser
}

$table | Format-Table -AutoSize