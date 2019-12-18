#!/usr/bin/env python3


###
### "Regular" imports go here:
###
if True:
	import datetime
	import string
	import re
	import os
	import collections
	import warnings
	import time
	import pprint
	import sys
	import types

from pathlib import Path
    
   

TOOL_HELP_TEXT = """
`basename $0` [arg] [arg]

Renumber files in current directory.
All small fields in front of filenames are replaced with "01 - Artist - track - remix"

Example Input:
  0 cbfce jioef - deknfe.mp3
  0b a cbfce jioef - deknfe.mp3
  1b b cbfce jioef - deknfe.mp3

Result:
  01 - cbfce jioef - deknfe.mp3
  02 - cbfce jioef - deknfe.mp3
  03 - cbfce jioef - deknfe.mp3
  
Options:
  TBD
  
"""

def die(st):
	print("""
	****
	Error: %s
	****""" % (st))
		


def require_argc(n):
	assert (argc >= n)

	
argc = len(sys.argv)
argv = []

for arg in argv:
	if re.match("--something", arg):
		pass
	elif re.match("--something", arg):
		pass
	elif re.match("-*", arg):
		die("Unhandled parameter: %s" % arg)
	else:
		argv.append(arg)
    
	
def isorted(lst):
	ret = sorted(lst, key=lambda s: s.lower())
	return ret
	
def please_press_enter(st=""):
	a = input()
	return
	
			
def please_input_yes(st=""):
	print("\n***************************\nInput 'y' to proceed")
	a = input()
	a = a.lower()
	if a == "yes" or a == "y":
		return True
	else:
		return False	
	
def reduce_file(file, count):
	new_file=[]
	
	accept=False
	accept_next=False
	for field in file.split():
		#print(field)
		if len(field) > 3:
			accept=True

		if accept_next:
			accept=True
			
		if '-' in field:
			accept_next=True
			
		if accept:
			new_file.append(field)
			
	new_file = " ".join(new_file)
	new_file = "%02d - %s" % (count, new_file)
	return new_file
	

	
def rename_files(debug_print, *, dry_run=True):

	orig_list = isorted(os.listdir("."))
	new_list = []
	count=0
	
	for file in orig_list:
		p = Path(file)
		if not p.is_file():
			continue

		if not p.suffix.lower() in [".mp3", ".wav", ".flac", ".wma", ".m4a", ]:
			print("ignoring %s " % (file))
			continue

		count += 1
			
		new_file = reduce_file(file, count)
		new_list.append(new_file)
		
		if debug_print == 0:
			pass
		elif debug_print == 1:
			print("%s" % (file))
		elif debug_print == 2:
			print("%s" % (new_file))
		elif debug_print == 3:
			print("\n%s\n%s" % (file, new_file))
	
		if not dry_run:
			os.rename(file, new_file)
			pass
			
	print("")

	

	
def show_what_will_happen(debug_print, st):
	print("\n%s" % (st))
	rename_files(debug_print)

	
def main():	
	show_what_will_happen(1, "Current Files.\n\nPLEASE CONFIRM THIS IS IN RIGHT ORDER!\n\n")
	please_press_enter()

	show_what_will_happen(2, "Proposed Renaming.\n\nPLEASE CONFIRM NO REMOVED FIELDS\n\n")


	if please_input_yes():
		rename_files(0, dry_run=False)
		show_what_will_happen(1, "NEW Files:")
	else:
		print("Skipped.")
	
main()	
	