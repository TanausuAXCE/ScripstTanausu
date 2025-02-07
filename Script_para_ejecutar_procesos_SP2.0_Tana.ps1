param(
    [string]$process
)

<#FHacemos que los cmdlets mo devuolevan el memsaje de error ya que ya indicaremos cuando esto pase#>
$ErrorActionPreference="SilentlyContinue"
<#Intetamos ejecutar el proceso para comprobar su salidas#>
Start-Process $process
<#Revisamos la salida#>
while ($? -eq 0)
 {
    write-host "Este proceso no existe escoja otro"
    $process=Read-host
    Start-Process $process
 }