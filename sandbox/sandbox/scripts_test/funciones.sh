#!/bin/bash 


# A=41 
# B=35
#let varieble=valor  hace que se defina la variable  asignando un valor 
#Si la variable se define  normal  podemos leerla de teclado.


#funcion suma() 	
#suma las variables A y B
#
#
#
echo "Dame  valor  numericos 1"
read A
echo "Dame  valor  numericos 2"
read B

function suma(){
let C=$A+$B
echo "Suma es : $C"
}

#funcion resta()
#resta A -B

function resta(){
let C=$A-$B
echo "resta es : $C"
}

suma 
resta
 
