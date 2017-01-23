#!/usr/bin/python

import subprocess
### Recibo variable  far de abajo  y regreso la operacion de conv como far

def converFC(far):
	conv = (float(far) - 32)/1.8
	return conv
def converCF(cent):
	conv = (float(cent) * 1.8) + 32
	return conv

opt = raw_input('Quienes calcular Centigrados o Frenheit?  C/F \n')

###Obtengo el resultado de converFC en forma de variable far e imprimimos

if opt == 'f':
	far = raw_input ('Cuantos farenheit? \n')		
	print "Los Centigrados son %f" % eval('converFC(far)')
elif opt == 'c':
	cent = raw_input('Cuantos centigrados? \n')
	print "Los farenheit son %f" % eval('converCF(cent)')
	

#subprocess.call("date")
#subprocess.call(["ls","-la"])

		
