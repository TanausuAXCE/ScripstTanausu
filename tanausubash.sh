#!/bin/bash

op=1

crear_2() {


 if [ "$#" -ne 2 ]; then

    sudo touch fichero_vacio.txt
    sudo truncate -s 1024KB fichero_vacio.txt
  elif [ -z $1 ]; then
  
  sudo touch fichero_vacio.txt
  sudo truncate -s $2KB fichero_vacio.txt

  elif [ -z $2 ]; then

     sudo touch $1
     sudo truncate -s 1024KB $1


  elif ! [[ $2 =~ ^[0-9] ]]; then

  echo "No es correcto especificar algo que no sea un número como parámetro."
  
  else

  sudo touch $1
  sudo truncate -s $2KB $1  


fi

}

crear() {


 if [ "$#" -ne 2 ]; then

    sudo touch fichero_vacio.txt
    sudo truncate -s 1024KB fichero_vacio.txt
  elif [ -z $1 ]; then
  
  sudo touch fichero_vacio.txt
  sudo truncate -s $2KB fichero_vacio.txt

  elif [ -z $2 ]; then

     sudo touch $1
     sudo truncate -s 1024KB $1


  elif ! [[ $2 =~ ^[0-9] ]]; then

  echo "No es correcto especificar algo que no sea un número como parámetro."
  
  else

  sudo touch $1
  sudo truncate -s $2KB $1  


fi

}


automatizar() {

 if [ $(ls /mnt/usuarios) ]; then

    for i in $(ls /mnt/usuarios); do
  
      sudo useradd -m -s /bin/bash $i

      for z in $(cat $i); do

        sudo mkdir /home/$i/$z

      done

      sudo passwd $i

      sudo rm /mnt/usuarios/$i

    done

 else

    echo "El directorio esta vacío"

 fi

}

romanos() {
    local numero="$1"
    local romano=""
 if [ $numero -gt 200 || $numero -lt 1 ]; then

   echo "Introduce un número entre 1 y 200"
 else
    # Arrays de valores y símbolos romanos
    valores=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
    simbolos=("M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I")

    for (( i=0; i<${#valores[@]}; i++ )); do
        while (( numero >= valores[i] )); do
            romano+="${simbolos[i]}"


            (( numero -= valores[i] ))
        done
    done

    echo "$romano"
 fi
}

permisosoctal() {
 

 ruta=$(find / -name $1 2> /dev/null)

 echo "Los permisos del fichero en octal son: " $(stat --format=%a $ruta)



}

privilegios() {
  us=$(whoami)
  grupos=$(groups $us)
  
  if [[ $us == 'root' || $(groups $us | grep -o 'sudo|root') ]]; then

   echo "El usuario tiene privilegios de administrador"
  
 else
 
  echo "El usuario no tiene permisos de adminitrador"

 fi


}

contar() {


  ruta=$(sudo find / -type d -name $1 2> /dev/null)

  echo "Número de ficheros de $d: " $(ls -l $ruta | grep -o '^-' | wc -l)  

}

buscar() {
   read -p "Introduzca un nombre de fichero: " f

   ruta=$((sudo find / -type f -name $f)2>/dev/null)

   if [[ -n $ruta ]] then 

      echo "$ruta"

      echo "el fichero $f contiene las siguientes vocales: " $(grep -o -i '[aeiou]' $f | wc -l)


   else

      echo "El fichero especificado no existe"

   fi


}

fichero() {

 ruta=$((sudo find / -type f -name $1)2>/dev/null | grep $1 -w)


 echo "Tipo de fichero: " $(stat $ruta --format=%F)

 echo "Tamaño en bytes: " $(stat $ruta --format=%s)

 echo "Inodo: " $(stat $ruta --format=%i)

 echo "Punto de montaje: " $(stat $ruta --format=%m)

}

edad() {

 if [ $1 -lt 3 ]; then

   echo "Niñez"

 elif [[ $1 -le 10 && $1 -ge 3 ]]; then

   echo "Infancia"

 elif [[ $1 -lt 18 && $1 -gt 10 ]]; then

   echo "Adolescencia"

 elif [[ $1 -lt 40 && $1 -ge 18 ]]; then 

   echo "Juventud"

 elif [[ $1 -le 65 && $1 -ge 40 ]]; then

   echo "Madurez"

 else 

   echo "Vejez"

fi

}

adivina() {
let 'cont = 1'

ramn=$((1 + $RANDOM % 100))

read -p "Introduzca un número: " num


while [ $num != $ramn ]; do


if [ $num -gt $ramn ]; then

echo "El numero introducido es mayor que el número generado"
let 'cont = cont + 1'
read -p "Introduzca un número: " num

else

echo "El numero introducido es menor que el número generado"
let 'cont = cont + 1'
read -p "Introduzca un número: " num
 
fi

done

echo "¡Exacto, el número es $ramn!, lo has conseguido en $cont intentos."

}


red() {

 read -p "Quiere una configuración e(s)tática o (D)HCP: " elec

 if [ $elec == s ]; then 

    read  -p "ip y máscara " ip 

    read -p "gateway " gtw

    read -p "int " int

   read -p "dns1 " dns1

   read -p "dns2 " dns2

 if [ $(echo $ip | grep /) ]; then

sudo cat << EOF > tmp.txt
network:
     renderer: networkd
     ethernets:
         enp0s3:
             dhcp4: false
             addresses: 
                - $ip
             nameservers: 
                addresses: [$dns1,$dns2]
             routes:
               - to: 0.0.0.0/0
                 via: $gtw      
EOF
sudo cp tmp.txt /etc/netplan/50-cloud-init.yaml
sudo netplan apply

else

 echo "Introduzca la máscara junto a la ip ej = 192.168.1.13/24"
fi
elif [ $elec == D ]; then

    read -p "int " int


cat << EOF > tmp.txt
network:
    renderer: networkd
    ethernets:
        $int:
            dhcp4: true 
EOF

sudo cp tmp.txt /etc/netplan/50-cloud-init.yaml

sudo netplan apply
else

 echo "La respuesta especificada no es correcta. Recuerde, s/D"

fi
}

bisiesto() {
 let h=$year%400
 let i=$year%100
 if [[ $year%4 -eq 0 && $year%100 -ne 0 ]]; then

  echo "El año $year es bisiesto" 
 
 elif [[ $year%400 -eq 0 && $year%100 -eq 0 ]]; then

   echo "El año $year es bisiesto" 

 else

  echo "el año $year no es bisiesto"
 fi
}

factorial()
{
    product=$1
           
    # Defining a function to calculate factorial using recursion
    if((product <= 2)); then
        "echo $product"
    else
        f=$((product -1))
        
    # Recursive call

        f=$(factorial $f)
        f=$((f*product))
        echo $f
    fi
}





while [ $op -ne 0 ]; 
 do
# Menu que se muestra por pantalla
   echo -e "\nOpción 1: factortal"
   echo "Opción 2: bisiesto"
   echo "Opción 3: configurarred"
   echo "Opción 4: adivina"
   echo "Opción 5: edad"
   echo "Opción 6: fichero"
   echo "Opción 7: buscar"
   echo "Opción 8: contar"
   echo "Opción 9: privilegios"
   echo "Opción 10: permisosoctal"
   echo "Opción 11: romanos"
   echo "Opción 12: automatizar"
   echo "Opción 13: crear"
   echo "Opción 0: Salir"
   read -p "Elegir la opcion deseada " op
   echo ""
   case $op in

    0)

    echo "Saliendo del menú..."

    ;;

    1)
     echo "Introduce un número: "   
     read num


     if((num == 0)); then   
      echo 1
     else

      factorial $num
    fi


    ;;

    2)
     read -p "Introduce un año: " year
     bisiesto $year
    ;;

    3)
    echo " "
  red

    ;;

 4)
  adivina
 ;;

 5)
   read -p "Introduce tu edad: " edad


   edad $edad
 ;;

 6)
 read -p "Introduzca un nombre de fichero: " f 

 fichero $f
 ;;

 7)
 buscar
 ;;

 8)
 contar
 ;;

 9)
   read -p "Introduzca un nombre de directorio: " d


   privilegios $d
 ;;

 10)
  read -p "Introduzca un nombre de fichero o directorio: " fchd

 permisosoctal $fchd

 ;;

 11)
read -p "Introduce un número: " numero

 romanos $numero
 ;;

 12)
 automatizar
 ;;

 13)
 read -p "Introduce un nombre de fichero: " fic
 read -p "Introduce un tamaño para el fichero: " tam
 crear $fic $tam
 ;;

 14)

 ;;

 15)

 ;;

 16)

 ;;

 17)

 ;;

 18)

 ;;

 19)

 ;;

 20)

 ;;

 *)
 echo "El dato que le ha pasado al menú es incorrecto."
 ;;
  esac
 done
