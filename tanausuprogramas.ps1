# Declaramos la variable progs, que contiene el contenido del fichero de texto.
$progs = Get-Content .\programas.txt

# Evitamos que por una salida erronea de un cmdlet salga texto rojo ya que winget nos responderá también.
$ErrorActionPreference="SilentlyContinue"

# Bucle de interación en el fichero.
foreach ($pro in $progs) {

# Línea que desinstala el programa silenciosamente.
    winget uninstall $pro --force --silent --disable-interactivity 


}