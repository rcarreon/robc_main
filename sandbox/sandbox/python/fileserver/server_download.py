#!/usr/bin/python

import socket 
import os
import threading

def retrfile(name, sock):
        filename = sock.recv(4096)
        ## if the file exists
        #if os.path.isfile(filename):
        if os.path.isdir(filename):
                ## send exists msg and the sizo of the file
                sock.send("EXISTS " + str(os.path.getsize(filename)))
                userResponse = sock.recv(1024)
                ### Get teh first 2 characthers of user response
        #        if userResponse[:2] == 'OK':
                with  open(filename, 'rb') as f:
                   bytesToSend = f.read(4096)
                   sock.send(bytesToSend)
                   while bytesToSend != "":
                       bytesToSend = f.read(4096)
                       sock.send(bytesToSend)
        else:
            sock.send("ERR")
        
        sock.close()

def main():
        host = '127.0.0.1'
        port = 5000
        ##Create TCP ( default with no args)
        s = socket.socket()
        s.bind((host,port))
        ## start listen 
        s.listen(5)
        
        print "Server started"
        
        while True:
            ## connection socket and address
            c, addr = s.accept()
            print "Client connected ip:<"+ str(addr)+ ">"
            ##Creating a thread
            t = threading.Thread(target=retrfile, args=("retrThread", c))
            t.start()

        s.close()        

if  __name__ == '__main__':
        main()
