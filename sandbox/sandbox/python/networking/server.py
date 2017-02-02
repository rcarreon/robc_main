#!/usr/bin/python           
# This is server.py file


import socket               # Import socket module
import sys 


##Creating a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
##bind()  server ip address and port 
server_address = ('localhost',12345)
print >>sys.stderr, 'stating up on %s port %s' % server_address
sock.bind(server_address)
##calling listen () 

sock.listen(5)
while True:
	print >>sys.stderr, 'Waiting for a connection'
	connection, client_address = sock.accept()
##accept() returns an open connection between the server and client, along with the address of the client. The connection is actually a different socket on another port (assigned by the kernel). Data is read from the connection with recv() and transmitted with sendall().

	try:
		print >>sys.stderr, 'connection from', client_address
		while True:
			data = connection.recv(1024)
			print >>sys.stderr, data
			while  data: 
###added next line to interact with client
				data = raw_input('Send back a message to client \n' )		
				connection.send(data)
				
				if data == 'bye':
                                        print >>sys.stderr, 'Later..'
                                        connection.close()
                                        sys.exit(0)
				data = connection.recv(1024)
				print >>sys.stderr,  'Client says \n' , data
				if data == 'bye':
					print >>sys.stderr, 'Later..'
					connection.close()
					sys.exit(0)
	finally:
		connection.close()
		
		


