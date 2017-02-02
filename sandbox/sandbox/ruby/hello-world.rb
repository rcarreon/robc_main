#!/usr/bin/env ruby  
#The lien above is to tell the shell to search for the executable of ruby in my PATH
##first Ruby program
#hello = "Hello World"
puts "How old ar you "
#age = gets.chomp
age = STDIN.gets
#puts hello.split('/', 2)[0]
#if age > 30
#puts "Your age is %d" % age
#end
if age ==  30 
	puts "you are older than me I'm 30 "
end
#if age <= 29 
#	puts "what're you doing greenie boy ?. you're %d" % age
#end
#the split divides the sentence into args with delimiter '/' and after that prints out  the arg number [#]
puts 'crowdignite.com/landing_page/visual_check'.split('/', 2)[0]
puts 'admin.sheknows.com'.split('/', 2)[0]

##ruby seems nice.. 

