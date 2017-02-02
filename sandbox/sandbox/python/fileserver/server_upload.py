#!/bin/python
#!/usr/bin/env python

import socket
import sys
import subprocess
import threading
import os


##so far only works with localhost, error comes up when trying to add another ip address ###
s = socket.socket()
hostname = raw_input("A que hostname quieres dar accesso? \n")
s.bind((hostname,9999))
s.listen(10) # Acepta hasta 10 conexiones entrantes.
print "Server started"
print "Esperando conexion"
while True:
    sc, address = s.accept()
    print "Cliente conectado ip:<"+ str(address)+">"
    i=1
    archivo = ('file_' + str(i))
    #archivoo = sc.recv(1024)
    #archivo = os.path.basename(archivoo)
    f = open(archivo,'wb') #open in binary
    i=i+1
    while (True):       
    # recibimos y escribimos en el fichero
        l = sc.recv(1024)
        while (l):
                f.write(l)
                l = sc.recv(1024)
   
    #if address:
    #    print "archivo %s recivido" % archivo
  
    f.close()


    sc.close()

s.close()
