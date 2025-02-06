
$fecini = Read-Host "Introduce la fecha de inicio (año mes dia o día mes año, separa por '-' o '/') "
$fecfin = Read-Host "Introduce la fecha de fin (año mes dia o día mes año, separa por '-' o '/') "

Get-EventLog -LogName Security -After $fecini -Before $fecfin | Where-Object {$_.EventID -eq 4624 -and $_.UserName -ne "System"} | Select-Object -First 10