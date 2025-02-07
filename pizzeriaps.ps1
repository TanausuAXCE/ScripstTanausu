

$op = Read-Host "Elige un tipo de pizza (1.Vegetariana/2.No vegetariana): "

if ($op -eq 1){

    $ingveg = Read-Host "Los ingredientes para la pizza vegetariana son 1(tofu)/2(Pimiento)"
    if ($ingveg -eq 1){

        Write-host "Su pizza es vegetariana y contiene tomate mozzarella y tofu"

    }elseif($ingveg -eq 2){
        Write-host "Su pizza es vegetariana y contiene tomate mozzarella y pimiento"
    
    }else{
    Write-host "Lo que ha introducido no es un ingrediente de los listados.(1=tofu o 2=pimiento)"

   }

} elseif($op -eq 2){

    Write-Host "1.Peperoni"
    Write-Host "2.Jamón"
    Write-Host "3.Salmón"

    $ingnoveg = Read-host "Escoja un ingrediente: "

    switch($ingnoveg) {
    
    1{
    Write-host "Su pizza es no vegetariana y contiene tomate, mozzarella y peperoni"
    
    }
    2{
    Write-host "Su pizza es no vegetariana y contiene tomate, mozzarella y jamón"
    
    }
    3{
    Write-host "Su pizza es no vegetariana y contiene tomate, mozzarella y salmón"
    
    }
    default{Write-host "Lo que ha introducido no es uno de los ingredientes listados."}
    
    }
} else {
    Write-Host "Escoja un tipo de pizza correcto."

}
