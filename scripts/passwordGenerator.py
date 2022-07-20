#!/bin/python3

def generatePassword():
	"""generate three random strings;
	join them and add a dash along;
	print it out and copy to clipboard"""

	from random import choice as rc
	from string import printable as sp

	tempOne = []
	tempTwo = []
	tempThree = []
	
	for i in range(9):
		tempOne.append(rc(sp[:64]))
		tempTwo.append(rc(sp[:64]))
		tempThree.append(rc(sp[:64]))
	
	password = ''.join(tempOne) + '-' + ''.join(tempTwo) + '-' + ''.join(tempThree)
	print(password)

generatePassword()
