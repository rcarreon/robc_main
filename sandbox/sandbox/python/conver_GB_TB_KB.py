#!/usr/bin/python

import subprocess
### Recibo variable  far de abajo  y regreso la operacion de conv como far

def converTB(tb):
        conv = float(tb) / 1024 
        return conv
def converGB(gb):
        conv = (float(gb) * 1024)
        return conv
def converMB(mb):
        conv = (float(mb) * 1024)
        return conv
def converMBG(mbg):
        conv = (float(mbg) / 1024)
        return conv

opt = raw_input('Quienes calcular GB to TB (t) , TB to GB (g) o GB to MB (m), MB to GB (M)?   \n')

###Obtengo el resultado de converFC en forma de variable far e imprimimos

if opt == 't':
        tb = raw_input ('Cuantos Gigabytes? \n')    
        print "Los TB son %f" % eval('converTB(tb)')
elif opt == 'g':
        gb  = raw_input('Cuantos Terabytes? \n')
        print "Los Gigabytes  son %f" % eval('converGB(gb)')
elif opt == 'm':
	mb  = raw_input('Cuantos Gigabytes? \n')
	print "Los Megabytes son %f" % eval('converMB(mb)')
elif opt == 'M':
        mbg  = raw_input('Cuantos Megabytes? \n')
        print "Los Gigabytes son %f" % eval('converMBG(mbg)')
	
  

#subprocess.call("date")
#subprocess.call(["ls","-la"])

