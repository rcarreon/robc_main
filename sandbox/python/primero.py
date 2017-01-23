#!/usr/bin/python
############################ Para compilar : 
	###python -m compileall <nombre_archivo>

############################
import pygtk
import gtk 
import webbrowser





url = "https://my.pingdom.com"
host = "430216"
##Here I will open a browser window

#webbrowser.open(url + "/reports/uptime#check=" + host + "&daterange=7days")
webbrowser.open(url + "/reports/uptime#check=" + host )
## This works!  this is for the uptime report  so we can see the list of ups and downs of host , with this we open the monitor  from treeview:q


print "Hello, world !"

##numeros 
mientero = 10
miflotante = 15.5   #flotante 
x,y,z = 4,5.5,7    ## definiendo varias variables en una linea 
print x + y + z
resultado = mientero + miflotante
print resultado  #imprimiendo 
micadena = "Hello madafacka"


##listas 

milista = []
milista.append(1)
milista.append(2)
milista.append(3)

print milista[0] 
print milista[1]
print milista[2]

milista2 = []
milista2.append("HOla")
milista2.append("Mundo,")
milista2.append("Culeros")

for x in milista2: 
	print x

#doing  some math :D 
#cuadrado
cuentas =  5 ** 2
holasmultiple = "Hola" * 5
 
print "Holas multiple ", holasmultiple 
print "Cuadrado " ,cuentas 

#cuantas con listas

todo = milista + milista2
print "Todo junto ", todo

for y in milista:
	for z in milista2: 
		print  	y
		print	z

## text format 
nombre = "robc"
print "Sup %s!" % nombre




####################### STRING METHODS ###########################


#####  len () , lower(), upper() , str()


bird = "PArrOT"
pi = 3.1416

print len(bird)
print bird.lower()
print bird.upper()
print str(pi)

ministry = "The Ministry of Silly Walks"

print len(ministry)
print ministry.upper()


#################  PRINTING #########################

print "spam "+"and "+"eggs"  ## spaced before and after the word inside quotes count.. 
## you can't print this ##
print  "Your change is " + 10.5
## but you can print this ###
print "Your change is " + str(10.5)

