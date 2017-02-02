 #!/bin/bash

  echo Nombre del script: $0
  echo Número de argumentos: $#
  echo Cadena con todos los argumentos: $*
  echo Primer argumento: $1
  echo Segundo argumento: $2
  while [[ $@ ]];do
  	shift # Desplazamos los argumentos
	
	echo Primer argumento: $1
	 if [[ -z  $@ ]]
	 then
		  echo "Ya no hay nada"
	 fi

  done
