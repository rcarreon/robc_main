#!/bin/python
#!/usr/bin/env python

import socket
import sys
import os
import time 

hostname =  raw_input("A que hostname te quieres conectar?\n")
command =  os.system("ls")
print command
archivo = raw_input("Nombre del archivo a mandar \n")
s = socket.socket()
#s.connect(("localhost",9999))
s.connect((hostname,9999))
f = open (archivo, "rb")
l = f.read(1024)
while (l):
    s.send(l)
    l = f.read(1024)
    print "file %s sent.." % archivo
s.close()
