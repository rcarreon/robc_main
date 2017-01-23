#!/usr/bin/python           
# This is client.py file

import socket               # Import socket module
import sys
s = socket.socket()         # Create a socket object
host = socket.gethostname() # Get local machine name
port = 12345                # Reserve a port for your service.

#s.connect((host, port))
s.connect(('127.0.0.1', port))
print s.recv(1024)
while True:
	c, addr = s.accept()
	c.send('Hey there from client \n')	
	c.close
s.close                     # Close the socket when done

