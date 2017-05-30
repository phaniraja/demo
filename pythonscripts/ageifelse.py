#!/usr/bin/python

name = str(raw_input("what is your name: "))
age = int(raw_input("what is your age: "))

if age <= 18 : 
	print "\nhi " + name + " your age is " + str(age) + "  and you are not eligeble to smoke\n"
else : 
	print "\nhi " + name + " your age is " + str(age) + " and you are eligeble to smoke\n"


