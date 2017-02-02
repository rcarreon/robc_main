#!/usr/bin/python

import socket

def main():
        host = '127.0.0.1'
        port = 5000
        
        s = socket.socket()
        s.connect((host,port))
        
        filename = raw_input("Filename?  ->")
        
        if filename != "q": 
            s.send(filename)
            data = s.recv(4096)
            if data[:6] == 'EXISTS':
                filesize = long(data[6:])
                message =  raw_input("File exists and is a dir "+str(filesize)+ "Bytes, download (Y/N)")

                if message == 'Y':
                    s.send('OK')
                    #f = open('new_'+filename,'wb')
                    data = s.recv(4096)
                    totalrecv = len(data)
                    #f.write(data)
                    while data: 
                        print data
                        i=1
                        f = open(filename +str(i),'wb')
                    #while totalrecv < filesize:
                        data = s.recv(4096)
                        #totalrecv += len(data)
                        f.write(data)
                        i += 1
                        #f.close()
                        #print "{0:.2f}".format((totalrecv/float(filesize))*100+"% Done"

                        print "Download is complete"
                else:
                    print "Download aborted"
            else: 
                print "File does not exists"
        s.close()

if __name__ == '__main__':
    main()
        
