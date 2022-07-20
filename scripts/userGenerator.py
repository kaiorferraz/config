from random import choice as rc
from string import printable as sp
import os, sys

def generate(x):
	placeholder = []
	for i in range(x):
		placeholder.append(rc(sp[10:36]))
		# if i in placeholder:
		# 	pass
		# else:
			# placeholder.append(i)
	print(''.join(placeholder))

generate(30)
