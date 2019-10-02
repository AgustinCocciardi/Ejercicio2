#!/bin/bash

#Nombre del script: Ejercicio2.sh
#Trabajo practico 1 Ejercicio 2 - ENTREGA
#INTEGRANTES:
#Perez Antonacci, Lucas Ezequiel - 35944531
#Cocciardi, Agustin Ignacio - 40231779
#Vazquez, Mario Waldo - 36623991
#Barra Quelca, Guido Alberto - 39274352

#Funcion que muestra la ayuda
function ayuda(){
    echo "Este script se ha creado con la finalidad de renombrar archivos de un directorio"
    echo "El script puede recibir cero, uno o dos parámetros"
    echo "El script puede recibir el directorio donde se buscarán los archivos"
    echo "El script puede recibir un -r para que busque de forma recursiva entre los subdirectorios del directorio pasado"
    echo "El script puede no recibir un directorio, y en ese caso tomará el directorio actual"
    echo "Formas de ejecutar el script:"
    echo "Con 2 parámetros       <---> ./Ejercicio2.sh [ruta] -r"
    echo "Con 1 parámetro (ruta) <---> ./Ejercicio2.sh [ruta]"
    echo "Con 1 parámetro (-r)   <---> ./Ejercicio2.sh -r"
    echo "Con 0 parámetros       <---> ./Ejercicio2.sh"
	exit 0
} 

#Funcion que me hace salir del script si los parámetros no son correctos
function salir1(){
    echo "El numero de parametros no es correcto"
    exit 1
}

#Funcion que me hace salir del script si la ruta ingresada no es válida
function salir2(){
    echo "La ruta ingresada no es un directorio VALIDO";
	exit 2;
}

#Funcion que me hace salir del script si el directorio que pasó por parámetro está vacío
function salir3(){
    echo "El directorio que pasó por parámetro está vacío";
	exit 3;
}

#valido que los parametros pasados sean correctos
if [ $# -ge 3 ]; then
    salir1
fi

#ayuda
if [ "$1" = "-h" -o "$1" = "-?" -o "$1" = "-help" ]
then
	ayuda
fi

#valido que la ruta pasada sea un directorio
if [ $# -eq 1 -a "$1" != "-r" -a ! -d "$1" ] 
then
	salir2
fi

#hago que el nuevo separador de campos sea un salto de línea
IFS='
'

if [ $# -eq 2 -a "$2" != "-r" ]
then
    echo "solo se acepta '-r' como segundo parámetro"
    exit 7;
fi

#reviso si me pasaron un "-r" y extraigo los archivos de forma recursiva (o no)
if [ "$1" = "-r" -o "$2" = "-r" ]
then
    if [ "$2" = -r ]
    then
    cd "$1"
    fi
    archivos=$( find -name "* *")
else
    if [ -d "$1" ]
    then
    cd "$1"
    fi
    archivos=$( find -maxdepth 1 -name "* *")
fi

#con esta variable contaré los archivos que he renombrado
renombrados=0

#declaro un array asociativo que usaré para guardar los nombres y una variable que usaré en caso de que se repita un nombre luego
#de realizar la modificacion
declare -a nombres
seRepitio=1

#le quito la primera ocurrencia del espacio por el caracter underscore (_) y luego elimino el resto de espacios
for f in $archivos; 
do
nuevoNombre=`echo $f | sed "s/ /_/" | tr -d ' '`  
    for i in ${nombres[@]}
    do
        if [ "$i" = "$nuevoNombre" ];then
            nuevoNombre=`echo $f | sed "s/ /_$seRepitio/" | tr -d ' '`
            #nuevoNombre+=$seRepitio
            seRepitio=$((seRepitio+1))
        fi
    done
    nombres[$renombrados]+=$nuevoNombre 
#mv "$f" `echo $f | sed "s/ /_/" | tr -d ' ' `
renombrados=$((renombrados+1))
mv "$f" "$nuevoNombre"
done

echo "Se renombraron $renombrados archivos"
#FIN DE ARCHIVO
