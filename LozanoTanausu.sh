#!/bin/bash
op=1

romano(){
num=$1
sim=()

#condicion para tranforma de decimal a romano
while [ $num -ne 0 ]; do
 if ! [[ $num -lt 1 || $num -gt 200 ]]; then
  
  if [ $num -ge 100 ]; then
  
  sim+="C"
  let num=num-100
  elif [ $num -ge 50 ]; then
   sim+="L"
   let num=num-50
  elif [ $num -ge 10 ]; then
   sim+="X"
   let num=num-10
  elif [ $num -eq 9 ]; then
   sim+="IX"
   let num=num-9
  elif [ $num -ge 5 ]; then
   sim+="V"
   let num=num-5
  elif [ $num -eq 4 ]; then
   sim+="IV"
   let num=num-4
  elif [ $num -ge 1 ]; then
   sim+="I"
   let num=$num-1
  fi
 fi
done
  echo "El número $1 es $sim en romano."

}

samba(){
  #COndición para ver si está activo  o instalado samba
  if ! [[ $(sudo find / -type f -name smb.conf 2> /dev/null) ]]; then
     sudo apt install samba
     if  ! [[ $(sudo systemctl status smbd | grep -Ei 'inactive|disabled') ]]; then
        sudo systemctl start smbd
        sudo systemctl enable smbd
     fi
 else
   ruta=$(sudo find / -type d -name $1 2> /dev/null)
 
   #COmporbamos si la carpeta existe y la creamos segun su casuistica
   if ! [[ $(sudo find / -type d -name $1 2> /dev/null) ]]; then
    sudo mkdir -p /$1
   # Creamos los recursos compartidos
    echo "[$1]
    comment =  $1
    browseable =  yes
    path = /$1
    guest ok = yes
    read only = no
    create mask = 0777
    directory mask = 0777
    " >> /etc/samba/smb.conf
    sudo systemctl restart smbd
    else

      echo "[$1]
     comment =  $1
     browseable =  yes
     path = /$1
     guest ok = yes
    read only = no
    create mask = 0777
    directory mask = 0777
" >> /etc/samba/smb.conf
   sudo systemctl restart smbd
    fi
  fi
}

Lista(){
  #condicional para saber si existe o no la lista o un elemneto de su interior
  if [ $(ls . | grep $1) ]; then
    if [ $(cat $1 | grep $2 -w) ]; then
     echo "El elemento ya existe. Escoja otro."
    else
      echo "$2" >> $1
       echo "Tiene $(cat $1 | wc -l) elementos"
    fi
  else 
   echo "No existe el fichero, se creará."
   sudo touch $1
   echo "$2" >> $1
   echo "Tiene $(cat $1 | wc -l) elementos"
  fi
}

automatizar(){
#Comprobación de que existe el directorio /mn/usuarios
  if [ $(sudo ls /mnt/usuarios) ]; then
  
#Iteraciones por el directorio y dentor del fichero
   for usu in $(sudo ls /mnt/usuarios); do
   
     sudo useradd -m -s /bin/bash $usu
     sudo passwd $usu
     for dir in $(cat /mnt/usuarios/$usu); do 
       
       sudo mkdir /home/$usu/$dir
        
     done 

     sudo rm /mnt/usuarios/$usu
   done
  else
   echo "El directorio está vacío. NO se creará nada"
  fi
}

crear(){
  #Creación de la variable
  fich=${1:-fichero_vacio.txt}
  #Creación del fichero y la forma de poner su peso con truncate
  sudo touch ${1:-fichero_vacio.txt}
  sudo truncate -s ${2:-1024}KB $fich
   
}

while [ $op -ne 0 ]; do

echo "
      Ejecute el Script como administrador para evita errores

      1. Crear
      2. Romano
      3. Automatizar
      4. Lista
      5. Samba
      0. Salir

"

 read -p "Escoja una opción: " op

 case $op in

  0)
    echo "Saliendo..."
  ;;
  1)
   #Creación de las variables
    read -p "Dame un nombvre de fichero:  " fic
    read -p "Dame un tamaño para el fichero: " tam
    #Llamado a la función
    crear $fic $tam
  ;;
  2)
    read -p "Introduce un número en decimal: " numrom
    romano $numrom
    
  ;;
   3)
    #Llamado a la función
    automatizar
   ;;
   4)
    read -p "Introduzca el nombre de la lista: " list
    read -p "Introduzca un elemento: " elem
 
    Lista $list $elem
   ;;
   5)
   # si el directorio no existe se creará en /
    read -p "Introduzca el nombre del directorio que quiere compartir: " dirsmb
    samba $dirsmb
   ;;
   *)
    #Caso por defecto
    echo "Lo que ha introducido no es una de las opciones. Volviendo al menú. "
    op=1
   ::
 esac
done
