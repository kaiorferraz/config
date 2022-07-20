def dateWithDashes():
	"""fetch the date with dashes.
	good to append within files and folders"""
	
	from datetime import date
	
	format = "%m-%d-%y"
	today = date.today().strftime(format)
	
	copy(today)
	print(today)
	
dateWithDashes()
