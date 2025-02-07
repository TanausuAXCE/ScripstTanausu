
$par = 0
$impar = 0
 
0..365 | ForEach-Object{
    $dia = ([datetime]"01/01/2025 00:00").AddDays($_).Day
    if ($dia %2)
    {
        $impar++
    }
    else
    {
        $par++
    }
}
 
"Días pares: " + $par.ToString()
"Días impares: " + $impar.ToString()