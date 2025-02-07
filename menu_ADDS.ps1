# Requiere el módulo de Active Directory
Import-Module ActiveDirectory

function Show-DomainInfo {
    $domain = Get-ADDomain
    $OUs = Get-ADOrganizationalUnit -Filter *
    $groups = Get-ADGroup -Filter *
    $users = Get-ADUser -Filter *
    
    Write-Host "`n=== INFORMACIÓN DEL DOMINIO ==="
    Write-Host "Nombre del equipo: $($env:COMPUTERNAME)"
    Write-Host "Nombre del dominio: $($domain.DNSRoot)"
    Write-Host "Número de Unidades Organizativas: $($OUs.Count)"
    Write-Host "Número de Grupos: $($groups.Count)"
    Write-Host "Número de Usuarios: $($users.Count)"
}

function New-OU {
    $ouname = Read-Host "`nIntroduce el nombre de la nueva OU"
    $oupath = Read-Host "Introduce la ruta padre (ej: DC=dominio,DC=local)"
    
    try {
        New-ADOrganizationalUnit -Name $ouname -Path $oupath
        Write-Host "OU $ouname creada correctamente!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al crear la OU: $_" -ForegroundColor Red
    }
}

function Show-OUMembers {
    $ouname = Read-Host "`nIntroduce el nombre de la OU a consultar"
    $ou = Get-ADOrganizationalUnit -Filter "Name -eq '$ouname'"
    
    if ($ou) {
        $members = Get-ADObject -SearchBase $ou.DistinguishedName -Filter *
        Write-Host "`nMiembros de la OU $ouname :"
        $members | Format-Table Name, ObjectClass
    }
    else {
        Write-Host "OU no encontrada" -ForegroundColor Red
    }
}

function New-Group {
    $groupname = Read-Host "`nIntroduce el nombre del nuevo grupo"
    $oupath = Read-Host "Introduce la ruta completa (ej: OU=MiOU,DC=dominio,DC=local)"
    
    try {
        New-ADGroup -Name $groupname -GroupScope Global -Path $oupath
        Write-Host "Grupo $groupname creado correctamente!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al crear el grupo: $_" -ForegroundColor Red
    }
}

function New-User {
    $username = Read-Host "`nIntroduce el nombre de usuario"
    $firstname = Read-Host "Introduce el nombre"
    $lastname = Read-Host "Introduce el apellido"
    $groupname = Read-Host "Introduce el grupo al que pertenecerá"
    $oupath = Read-Host "Introduce la ruta completa (ej: OU=MiOU,DC=dominio,DC=local)"
    
    $password = ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force
    
    try {
        New-ADUser -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -SamAccountName $username `
            -UserPrincipalName "$username@$((Get-ADDomain).DNSRoot)" `
            -AccountPassword $password `
            -Enabled $true `
            -PasswordNeverExpires $false `
            -ChangePasswordAtLogon $true `
            -Path $oupath
        
        Add-ADGroupMember -Identity $groupname -Members $username
        Write-Host "Usuario $username creado y añadido al grupo $groupname!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al crear el usuario: $_" -ForegroundColor Red
    }
}

# Menú principal
while ($true) {
    Write-Host "`n=== MENÚ PRINCIPAL ==="
    Write-Host "1. Mostrar información del dominio"
    Write-Host "2. Crear nueva Unidad Organizativa"
    Write-Host "3. Ver miembros de una Unidad Organizativa"
    Write-Host "4. Crear nuevo grupo"
    Write-Host "5. Crear nueva cuenta de usuario"
    Write-Host "6. Salir`n"
    
    $option = Read-Host "Selecciona una opción"
    
    switch ($option) {
        1 { Show-DomainInfo }
        2 { New-OU }
        3 { Show-OUMembers }
        4 { New-Group }
        5 { New-User }
        6 { exit }
        default { Write-Host "Opción no válida" -ForegroundColor Red }
    }
}