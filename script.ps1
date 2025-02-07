
$domain = (Get-ADDomain).DistinguishedName

# Función para mostrar información del dominio

function Mostrar-InformacionDominio {
    $nombreEquipo = (Get-ComputerInfo).CsCaption
    $nombreDominio = $domain
    $ouCount = (Get-ADOrganizationalUnit -Filter *).Count
    $groupCount = (Get-ADGroup -Filter *).Count
    $userCount = (Get-ADUser -Filter *).Count
    
    Write-Host "Nombre del equipo: $nombreEquipo"
    Write-Host "Nombre del dominio: $nombreDominio"
    Write-Host "Número de Unidades Organizativas: $ouCount"
    Write-Host "Número de Grupos: $groupCount"
    Write-Host "Número de Usuarios: $userCount"
}

# Función para crear una nueva Unidad Organizativa
function Crear-UnidadOrganizativa {
    $nombreOU = Read-Host "Introduce el nombre de la nueva Unidad Organizativa"
    New-ADOrganizationalUnit -Name $nombreOU -ProtectedFromAccidentalDeletion $false -Path $domain
    Write-Host "Unidad Organizativa '$nombreOU' creada con éxito"
}

# Función para ver los miembros de una Unidad Organizativa
function Ver-MiembrosOU {
    $ouName = Read-Host "Introduce el nombre de la Unidad Organizativa"
    $ou = Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'"
    if ($ou) {
        $miembros = Get-ADUser -Filter * -SearchBase $ou.DistinguishedName
        Write-Host "Miembros de la OU '$ouName':"
        $miembros | ForEach-Object { Write-Host $_.SamAccountName }
    } else {
        Write-Host "No se encontró la Unidad Organizativa '$ouName'."
    }
}

# Función para crear un nuevo grupo
function Crear-Grupo {
    $nombreGrupo = Read-Host "Introduce el nombre del nuevo grupo"
    New-ADGroup -Name $nombreGrupo -GroupScope Global -GroupCategory Security
    Write-Host "Grupo '$nombreGrupo' creado con éxito"
}

# Función para crear una nueva cuenta de usuario
function Crear-Usuario {
    $nombreUsuario = Read-Host "Introduce el nombre del nuevo usuario"
    $nombreCompleto = Read-Host "Introduce el nombre completo del usuario"
    $grupo = Read-Host "Introduce el nombre del grupo al que debe pertenecer"
    
    # Verificar si el grupo existe
    $grupoExistente = Get-ADGroup -Filter "Name -eq '$grupo'"
    
    if ($grupoExistente) {
        $password = "(Passw0rd)" | ConvertTo-SecureString -AsPlainText -Force
        New-ADUser -Name $nombreCompleto -SamAccountName $nombreUsuario `
            -AccountPassword $password -PasswordNeverExpires $false `
            -UserPrincipalName "$nombreUsuario@$(Get-ADDomain).Name" `
            -Enabled $true -ChangePasswordAtLogon $true
        
        # Añadir usuario al grupo
        Add-ADGroupMember -Identity $grupoExistente -Members $nombreUsuario
        Write-Host "Usuario '$nombreUsuario' creado con éxito y añadido al grupo '$grupo'."
    } else {
        Write-Host "El grupo '$grupo' no existe."
    }
}

# Función principal para mostrar el menú
function Mostrar-Menu {
    do {
        Write-Host "Menú de opciones:"
        Write-Host "1-. Mostrar información del dominio"
        Write-Host "2-. Crear nueva Unidad Organizativa"
        Write-Host "3-. Ver miembros de una Unidad Organizativa"
        Write-Host "4-. Crear nuevo grupo"
        Write-Host "5-. Crear nueva cuenta de usuario"
        Write-Host "0-. Salir"
        
        $op = Read-Host "Selecciona una opción"

        switch ($op) {
            1 { Mostrar-InformacionDominio }
            2 { Crear-UnidadOrganizativa }
            3 { Ver-MiembrosOU }
            4 { Crear-Grupo }
            5 { Crear-Usuario }
            0 { Write-Host "Saliendo del menú..." }
            default { Write-Host "Opción no válida, por favor selecciona de nuevo." }
        }
    } while ($op -ne 0)
}

# Ejecutar el menú
Mostrar-Menu
