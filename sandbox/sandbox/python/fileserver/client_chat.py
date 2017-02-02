#!/usr/bin/python

import socket
import time 

def main():
        host = '127.0.0.1'
        port = 5000

        s = socket.socket()
        s.connect((host,port))
        msgsend = raw_input("Reply\n")
        time.sleep(10)
        print "closing.."
        s.close        

if __name__ == '__main__':
    main()


