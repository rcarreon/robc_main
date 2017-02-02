#!/usr/bin/python           


import socket
import sys

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = ('localhost', 12345)
print >>sys.stderr, 'connecting to %s port %s' % server_address
sock.connect(server_address)
try:
    
    # Send data
#    message = 'This is the message.  It will be repeated.'
### Added next line to interact with server ###
	message = raw_input('Enter message to send to the server: \n')
	print >>sys.stderr,  message
	sock.sendall(message)

    # Look for the response
    	#amount_received = 0
   	#amount_expected = len(message)
    
    	while True:
       		data = sock.recv(1024)
 	        #amount_received += len(data)
#       		print >>sys.stderr, data
		while data: 
			print >>sys.stderr,'server says \n', data
#			print >>sys.stderr, data
			message_rpl = raw_input('Send reply \n')
       			sock.send(message_rpl)	
			if message_rpl == 'bye':
				print >>sys.stderr, 'Later..'
				sock.close()
                                sys.exit(0)
			data = sock.recv(1024)
			if data == 'bye':
                                        print >>sys.stderr, 'Later..'
                                        sock.close()
					sys.exit(0)


finally:
    print >>sys.stderr, 'closing socket'
    sock.close()
