# Lista todos los proveedores en el espacio de nombres
Get-WmiObject -Namespace "root\cimv2\mdm\dmmap"

# Verifica si el proveedor DMWmiBridgeProv1 ya está registrado
$provider = Get-WmiObject -Namespace "root\cimv2\mdm\dmmap" -Class "__Namespace" | Where-Object { $_.Name -eq "DMWmiBridgeProv1" }
if ($provider) {
    Write-Host "El proveedor DMWmiBridgeProv1 ya está registrado."
} else {
    Write-Host "El proveedor DMWmiBridgeProv1 no está registrado."
}
mespace, $providerName