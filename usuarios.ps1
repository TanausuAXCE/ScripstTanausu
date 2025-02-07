Una opción es hacerlo con el "do-while"
do 
{
	clear-host
	Write-Host "1.Listar usuarios"
	Write-Host "2.Crear usuarios(pide usuario y contraseña)"
	Write-Host "3.Elimina usuarios(pide usuario)"
	Write-Host "4.Modifica usuarios(pide usuario y nuevo nombre)"
	Write-Host "5.Salir"
	$x=Read-Host "Seleccione opción"

if ($x -eq 1)
{
    cls
    Get-LocalUser|ft
}
if ($x -eq 2)
{
    cls
    $nombrecr=Read-Host "Dime un nombre para el nuevo usuario"
    $contra=Read-Host "Dime una contraseña para el nuevo usuario" -AsSecureString
    New-LocalUser $nombrecr -Password $contra
}
if ($x -eq 3)
{
    cls
    $nombrerm=Read-Host "Dime un nombre de usuario para eliminar"
    Remove-LocalUser $nombrerm -Confirm
}
if ($x -eq 4)
{
    cls
    $nombreviejo=Read-Host "Dime un nombre de usuario existente"
    $newname=Read-Host "Dime un nuevo nombre"
    Rename-LocalUser $nombreviejo -NewName "$newname"
}
if ($x -ne 5){
read-host "Pulse para continuar"
}
} while($x -ne 5)