#!/bin/bash

##### Opciones por defecto
filename=~/sysinfo.txt


##### Constantes
TITLE="Información del sistema para $HOSTNAME" # $HOSTNAME muestra el nombre del host
RIGHT_NOW=$(date +"%x %r%Z") # date muestra la fecha y hora actual
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER" # muestra el nombre del usuario actual con la fecha y hora actual

##### Estilos

TEXT_BOLD=$(tput bold) # tput bold hace que el texto sea negrita
TEXT_GREEN=$(tput setaf 2) # tput setaf 2 hace que el texto sea verde
TEXT_RESET=$(tput sgr0) # tput sgr0 hace que el texto sea normal
TEXT_ULINE=$(tput sgr 0 1) # tput sgr 0 1 hace que el texto sea subrayado

##### Funciones

usage()
{
  echo "Usage: scdebug [-h] [-sto arg] [-v | -vall] [-nattch progtoattach] [prog [command][arg1 …]]"
}

stooo(){
  # la funcion -sto fue llamada con argumentos
  if [ $# -eq 0 ]; then
    echo "La función '-sto' fue llamada sin argumentos."
    exit 1
  else
    echo "La función '-sto' fue llamada con argumentos: $@"
  fi
  echo "$2"

  if [ -d "scdebug" ]; then # comprobar que la carpeta scdebug existe
    echo "La carpeta scdebug existe."
  else
    #echo "La carpeta scdebug no existe."
    echo "mkdir scdebug"
    $(mkdir scdebug )
  fi


  if [ "$3" = "prog" ]; then
    echo "se ejecuta prog"
    echo "el programa es $4"

    if [ -d "scdebug/$4" ]; then # comprobar que la carpeta scdebug/$1 existe
      echo "La carpeta $4 existe."
    else
      #echo "La carpeta $4 no existe."
      echo "mkdir scdebug/$4"
      $(mkdir scdebug/$4 )
    fi

    uuid=$(uuidgen)
    echo "dolar4 ${@:4}"
    $( ${@:4} ) &
    PID=$( ps | grep $4 | tr -s ' ' | cut -d ' ' -f2 )
    echo "el pid es..."
    echo " $PID"
    echo "strace $2 -p $PID -o scdebug/$4/trace_$uuid.txt "
    $(strace $2 -p $PID -o scdebug/$4/trace_$uuid.txt )
  fi

  #si $3 es -nattch imprimir nache
  #ps -eo pid,ppid,cmd,start --sort=-start --no-header  |head -n 1
  #ps aux | grep sleep | sort -k 9 | tail -n 1
  #ps aux | grep sleep | sort -k 9 | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f2 --- si no hago esto sale el grep como el m'as reciente
  if [ "$3" = "-nattch" ]; then
    echo "se ejecuta nattch"
    echo "el programa es $4"

    if [ -d "scdebug/$4" ]; then # comprobar que la carpeta scdebug/$1 existe
      echo "La carpeta $4 existe."
    else
      #echo "La carpeta $4 no existe."
      echo "mkdir scdebug/$4"
      $(mkdir scdebug/$4 )
    fi

    uuid=$(uuidgen)
    echo "dolar4 ${@:4}"
    PID=$( ps aux | grep sleep | sort -k 9 | tail -n 2 | head -n 1 | tr -s ' ' | cut -d ' ' -f2 )
    echo "el pid es..."
    echo " $PID"
    echo "strace $2 -p $PID -o scdebug/$4/trace_$uuid.txt "
    # $(strace $2 -p $PID -o scdebug/$4/trace_$uuid.txt)

  fi

}

verbose(){
  echo "verbose"
}

nache(){
  if [ $# -eq 0 ]; then
    echo "La función 'nattch' fue llamada sin argumentos."
    exit 1
  else
    echo "La función 'nattch' fue llamada con argumentos: $@"
  fi

  if [ -d "scdebug" ]; then # comprobar que la carpeta scdebug existe
    echo "La carpeta scdebug existe."
  else
    echo "La carpeta scdebug no existe."
    echo "mkdir scdebug"
    $(mkdir scdebug )
  fi

  if [ -d "scdebug/$1" ]; then # comprobar que la carpeta scdebug/$1 existe
    echo "La carpeta $1 existe."
  else
    echo "La carpeta $1 no existe."
    echo "mkdir scdebug/$1"
    $(mkdir scdebug/$1 )
  fi

    uuid=$(uuidgen)
    echo $(ps aux | grep $1 | tr -s ' ' | cut -d ' ' -f2)
    echo "cual quiere seleccionar?:"
    read $PID
    echo "strace -p $PID -o scdebug/$1/trace_$uuid.txt "


}

programa() {
  if [ $# -eq 0 ]; then
    echo "La función 'prog' fue llamada sin argumentos."
    exit 1
  else
    echo "La función 'prog' fue llamada con argumentos: $@"
  fi

  if [ -d "scdebug" ]; then # comprobar que la carpeta scdebug existe
    echo "La carpeta scdebug existe."
  else
    echo "La carpeta scdebug no existe."
    echo "mkdir scdebug"
    $(mkdir scdebug )
  fi

  if [ -d "scdebug/$1" ]; then # comprobar que la carpeta scdebug/$1 existe
    echo "La carpeta $1 existe."
  else
    echo "La carpeta $1 no existe."
    echo "mkdir scdebug/$1"
    $(mkdir scdebug/$1 )
  fi

  uuid=$(uuidgen)
  echo "strace -o scdebug/$1/trace_$uuid.txt $@"
  $(strace -o scdebug/$1/trace_$uuid.txt $@)
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi


# Procesar la línea de comandos del script para leer del script las opciones
while [ "$1" != "" ]; do
  case $1 in
    -h | --help )           
      usage
      exit
      ;;
    -sto | --stop )
      stooo "$@"
      exit
      ;;
    -v | -vall )            
      verbose
      exit
      ;;
    -nattch )       
      nache "${@:2}" 
      exit
      ;;
    prog )
      programa "${@:2}"
      exit
      ;;
    * )
      usage
      exit 1
    esac
    shift # elimina el argumento que se acaba de procesar de la lista de argumentos
done

# ps | grep sleep | tr -s ' ' | cut -d ' ' -f2