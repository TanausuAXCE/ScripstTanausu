#!/bin/bash

op=1

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
read -p "Introduce un número: " numero
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
 echo "$romano"

            (( numero -= valores[i] ))
        done
    done

    echo "$romano"
fi
}

permisosoctal() {
 
 read -p "Introduzca un nombre de fichero o directorio: " fchd

 ruta=$(find / -name $fchd 2> /dev/null)

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

  read -p "Introduzca un nombre de directorio: " d

  ruta=$(sudo find / -type d -name $d 2> /dev/null)

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

read -p "Introduzca un nombre de fichero: " f

ruta=$((sudo find / -type f -name $f)2>/dev/null | grep $f -w)



echo "********"
echo "* TIPO *"
echo "********"

echo "$(stat $ruta --format=%F)"

echo "*******************"
echo "* TAMAÑO EN BYTES *"
echo "*******************"

echo "$(stat $ruta --format=%s)"

echo "*********"
echo "* INODO *"
echo "*********"

echo "$(stat $ruta --format=%i)"

echo "********************"
echo "* Punto de montaje *"
echo "********************"

echo "$(stat $ruta --format=%m)"

}

edad() {

 read -p "Introduce tu edad: " edad

 if [ $edad -lt 3 ]; then

   echo "Niñez"

 elif [[ $edad -le 10 && $edad -ge 3 ]]; then

   echo "Infancia"

 elif [[ $edad -lt 18 && $edad -gt 10 ]]; then

   echo "Adolescencia"

 elif [[ $edad -lt 40 && $edad -ge 18 ]]; then 

   echo "Juventud"

 elif [[ $edad -le 65 && $edad -ge 40 ]]; then

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
 if [ $h -eq 0 ]; then

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
   echo "Opción 0: Salir"
   read -p "Elegir la opcion deseada " op
   echo ""
   case $op in

    0)

    echo "Saliendo del menú..."

    ;;

    1)
     echo "Enter the number:"   
     read num


     if((num == 0)); then   
      echo 1
     else

      factorial $num
    fi


    ;;

    2)
     read year
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
  edad
 ;;

 6)
 fichero
 ;;

 7)
 buscar
 ;;

 8)
 contar
 ;;

 9)
 privilegios
 ;;

 10)
 permisosoctal

 ;;

 11)
 romanos
 ;;

 12)
 automatizar
 ;;

 13)

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
