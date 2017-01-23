#!/usr/bin/python

import Tkinter
import MySQLdb as mdb 
import sys
#from Tkinter import Tk,BOTH,Frame,Button
from Tkinter import *

def connection(self):
	conn = mdb.connect(host = "localhost", user = "root" , passwd ="root", db = "nocreports")
	cursor = conn.cursor ()
	cursor.execute("select * from verticals")
	data = cursor.fetchall()
	for row in data:
		print row[0], row[1]

	cursor.close()
	conn.close()

##################################							    ################################	
##################################	THIS IS A CLASS THAT WE WONT USE FOR NOW  BEGGINING #################################
#from ttk import Button
## import Tk and Fram clases
## This class is to set some paremeters that we will call later on  with  app=Example(top) 
## for example we will define like a template  that could be used in diferent windows 
#class Example(Frame):
#	def __init__(self,parent):  
	## constructor __init__
#		Frame.__init__(self,parent,background = 'black')
#		self.parent = parent
	#	self.initUI()
#		self.show1()
#	def initUI(self):		
#	initUI method
#		self.parent.title("Simple Window")
#		self.pack(fill=BOTH,expand=1)  #pack method is one geometry manager
		##now create a button 
#		quitButton = Button (self, text="Get out",command=self.quit)
#		quitButton.place(x=30, y=50)
		#openButton = Button (self, text="Open child",command=self.deiconify)
		#openButton.place (x=50 y=50)
#	def show1(self):
#		self.pack(fill=BOTH,expand=1)
#		openButton =Button (self, text="Open",command=self.deiconify)
#		openButton.place(x=50,y=50)
		
###################################################################################################################################
###################################################################################################################################
#to create buttons  to show and hide windows
#Our Main 
def main():
	top = Tk()
	top1=Toplevel(top)
	 # top window is created 
	top.title("Simple window")
	top.geometry("500x200+500+500")  
	# size and position
	top1.geometry("500x200+400+500")
	top1.title("Siple window2")
	top1.withdraw()
	def texting():
                pass
                text = Text(top)
                text.insert(INSERT,"Sup")
                text.insert(INSERT,"Dude..")
                text.pack()

	#show(top1)
	def Button1(self):
        	button1 = Button(top1,text="quit", command=self.quit)
 	#        button1.pack(fill=BOTH,expand=1)
        	button1.grid(row=0, column=0)
		button3 = Button(top, text="another")
		button3.grid(row=0, column=3)
        def Button2(self):
 	        button2 = Button(top, text="open", bd=3 ,fg="black", command=self.deiconify)
        #	button2.pack(fill=BOTH,expand=2)
	        button2.grid(row=5, column=5)

	Button1(top)
	Button2(top1)
#	texting()
	connection(top)
#	app = Example (top1)
	# adding a child window but since it opens at the same time that the parent we need to define this
	top.mainloop()  
	## enter the mainloop . The even handling starts from this point.
			##The mainloop receives events from the window system and dispatches them to the application widgets


main()
#if __name__ == '__main__':
#	main()


