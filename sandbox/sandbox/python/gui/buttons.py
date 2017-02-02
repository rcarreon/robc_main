#!/usr/bin/python
from Tkinter import *
import tkinter as tk
def klik_1():
    button1.config(image=s1)
def klik_2():
    button2.config(image=s2)
def klik_3():
    button3.config(image=s3)
def klik_4():
    button4.config(image=s4)
root = tk.Tk()
 
frame1 = tk.Frame(root)
frame1.pack(side=tk.TOP, fill=tk.X)
karirano = tk.PhotoImage(file="kari.GIF")
s1 = tk.PhotoImage(file="1.GIF")
s2 = tk.PhotoImage(file="2.GIF")
s3 = tk.PhotoImage(file="3.GIF")
s4 = tk.PhotoImage(file="4.GIF")
button1 = tk.Button(frame1, image=karirano, command=klik_1)
button1.grid(row=0,column=0)
button2 = tk.Button(frame1, image=karirano, command=klik_2)
button2.grid(row=0,column=1)
button3 = tk.Button(frame1, image=karirano, command=klik_3)
button3.grid(row=0,column=2)
button4 = tk.Button(frame1, image=karirano, command=klik_4)
button4.grid(row=0,column=3)
root.mainloop()
