# bmt.awk
# Document all Global Variables in a Bome BMT Project File
# Mostly good for rules. Lots of work needed for incoming and outgoing
# By Steven J. Caldwell 9-Mar-2018 
# Last Update 29-Jan-2020
# please send any corrections to the author
# Some features not supported by awk and mawk. Use gawk and you should be OK
# bome@sniz.biz
# Steps
# 1) Export your project into a text file
# 2) Run the following command
#   $awk -f bmt.awk filename | sort -t: -k 1 -n | uniq > outputfile
# if you then want to look for a given global variable such as "ga"
# and find which translators use it
#  $grep '\- ga' outputfile
#  Captures global variables only and saves to the output file
# Format of output file will look like this
# ...data excluded above
# 26.3: Bank Select LSB  - gb
# 26.3: Bank Select LSB  - gd
# 26.3: Bank Select LSB  - gf
# 26.3: Bank Select LSB  - ha
# 26.3: Bank Select LSB  - hb
# 26.3: Bank Select LSB  - hc
# 314 Total Translators
 
 
BEGIN	 {IGNORECASE=1; pr="FALSE"}
/_____/	{ pr="TRUE";next}
match($0, /(\[.\].*)(Translator.*)/,a)	{tr++; name[tr]=a[2] ; next} #pr="FALSE";next }

/Rules:/ {pr="TRUE" ;} #  printf("true\n")}
pr=="FALSE"	{ next ; printf("f\n")}
# Don't look at commented lines
/.*\/\/.*/		{next}

# or presets
match($0, /(\[.\].*)(Preset.*)/)	{next}

# Ignore Options 
/^Options:.*/	{next}

#ignore Label
/Label/  {next}
#ignore Goto
/Goto/  {next}
# Ignore incoming and outgoing
# /^Incoming/ {next}
# /^Outgoing/ {next}
/^Outgoing: Physical Keys:.*/	{next}
/^Incoming: Physical Keys:.*/	{next}

# Ignore timers
/^.*timer.*/ {next}

#ignore Project Opened
/^.*Project Opened*/ {next}

# added -2020-01-13 - We may need to add rules to include some of
# these back in 
/^Incoming: Bank Change/	{next}
/^Incoming: Active Sensing/	{next}
/^Incoming: Control Change/	{next}
/^Incoming: (none)/	{next}
/^Incoming: Note Off/	{next}
/^Incoming: Note On/	{next}
/^Incoming: on activation/	{next}
/^Incoming: on deactivation/	{next}
/^Incoming: On timer/	{next}
/^Incoming: Pysical Keys:/	{next}
/^Incoming: Pitch Bend/	{next}
/^Incoming: Program Change/	{next}
/^Incoming: Project Opened/	{next}
/^Outgoing: (none)/	{next}
/^Outgoing: activate preset/	{next}
/^Outgoing: All notes off/	{next}
/^Outgoing: Mouse move/	{next}
/^Outgoing: Control Change/	{next}
/^Outgoing: deactivate preset/	{next}
/^Outgoing: Note Off/	{next}
/^Outgoing: Note On/	{next}
/^Outgoing: One-shot timer/
/^Outgoing: Program Change/	{next}
/^Outgoing: Serial:/	{next}
 

# greater than equal or less than
match($0,/([=<>]\s*)([g-n|y-z][a-z0-9])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*[=<>])/, a)	{var=a[2]; var2[var,tr]++ }
 
# ignore if line starts with if statement
# in some cases you actually might want to catch these
# the side affect can be to many hits on the global variable "if"

#conditional equal
# 10-Jan-2020 - New

match($0,/([g-n|y-z][a-z0-9])(\s*==\s*)(.*)/, a)	{var=a[1]; var2[var,tr]++}
#match($0,/([g-n|y-z][a-z0-9])(\s*==\s*)(.*)/, a)	{printf("match xx=anything a=%s\n",a[1])}


match($0,/(.*)(\s*==\s*)([g-n|y-z][a-z0-9])/,a)	{ var=a[3]; var2[var,tr]++}
#match($0,/(.*)(\s*==\s*)([g-n|y-z][a-z0-9])/,a)	{printf("match anything=xx a=%s\n",a[3])}
 
 
 
# Conditional not equal
# ! = 041 octal
# = = 075 octal 

# 10-Jan-2020 - New

match($0,/([g-n|y-z][a-z0-9])(\s*!=\s*)(.*)/, a)	{var=a[1]; var2[var,tr]++}
#match($0,/([g-n|y-z][a-z0-9])(\s*!=\s*)(.*)/, a)	{printf("match xx=anything a=%s\n",a[1])}


match($0,/(.*)(\s*!=\s*)([g-n|y-z][a-z0-9])/,a)	{ var=a[3]; var2[var,tr]++}
#match($0,/(.*)(\s*!=\s*)([g-n|y-z][a-z0-9])/,a)	{printf("match anything=xx a=%s\n",a[3])}
 
#assignment equal after condition
match($0,/(.*then.*)([g-n|y-z][a-z0-9])(\s*=)/, a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*then.*)(=\s*)([g-n|y-z][a-z0-9])/,a)	{var=a[3]; var2[var,tr]++ }
 
#Mulitply * 
match($0,/(\*\s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\*)/, a)	{var=a[2]; var2[var,tr]++ }
 
#Divide / 
match($0,/(\/\s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\/)/, a)	{var=a[2]; var2[var,tr]++ }
 
#Add + 
match($0,/(\+\s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\+)/, a)	{var=a[2]; var2[var,tr]++ }
 
#Subtract - 
match($0,/(\-\s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\-)/, a)	{var=a[2]; var2[var,tr]++ }
 
#Modulo % 
match($0,/(\037s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\037)/, a)	{var=a[2]; var2[var,tr]++ }
 
#Right Shift >> 
 
# 10-Jan-2020 - New

match($0,/([g-n|y-z][a-z0-9])(\s*>>\s*)(.*)/, a)	{var=a[1]; var2[var,tr]++}
#match($0,/([g-n|y-z][a-z0-9])(\s*>>\s*)(.*)/, a)	{printf("match xx=anything a=%s\n",a[1])}


match($0,/(.*)(\s*>>\s*)([g-n|y-z][a-z0-9])/,a)	{ var=a[3]; var2[var,tr]++}
#match($0,/(.*)(\s*>>\s*)([g-n|y-z][a-z0-9])/,a)	{printf("match anything=xx a=%s\n",a[3])}
 
 
#Left Shift <<
 
# 10-Jan-2020 - New

match($0,/([g-n|y-z][a-z0-9])(\s*<<\s*)(.*)/, a)	{var=a[1]; var2[var,tr]++}
#match($0,/([g-n|y-z][a-z0-9])(\s*<<\s*)(.*)/, a)	{printf("match xx=anything a=%s\n",a[1])}


match($0,/(.*)(\s*<<\s*)([g-n|y-z][a-z0-9])/,a)	{ var=a[3]; var2[var,tr]++}
#match($0,/(.*)(\s*<<\s*)([g-n|y-z][a-z0-9])/,a)	{printf("match anything=xx a=%s\n",a[3])}
 
 
#bitwise AND & 
#next line breaks
match($0,/(\038s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\038)/, a)	{var=a[2]; var2[var,tr]++ }
 
#bitwise OR |
match($0,/(\|\s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\|)/, a)	{var=a[2]; var2[var,tr]++ }
 
#bitwise XOR ^ 
match($0,/(\^\s*)([g-n|y-z][a-z0-9]])(.*)/,a)	{var=a[2]; var2[var,tr]++ }
match($0,/(.*)([g-n|y-z][a-z0-9])(\s*\^)/, a)	{var=a[2]; var2[var,tr]++ }
 
 
 


# Raw MIDI in
# Incoming raw MIDI space separated globals only
match($0,/(^Incoming: MIDI )(([g-n|y-z][a-z0-9](\s)*)*)/,a)	{
	searchstring=substr(a[2],1,length(a[2]))
#	printf("line=%s\tss:%s\n",$0,a[2])
	counter=1
	found=1
	mylength=RLENGTH
	currentlength=mylength
	while (found>0) {
	   match(searchstring,/[g-n|y-z][a-z0-9]/)
	   found=RSTART
	   mylength=RLENGTH
	   a[counter]=substr(searchstring,found,mylength)
	   currentlength=currentlength-mylength+1
	   searchstring=substr(searchstring,found+mylength,currentlength)
	   counter++
        }
	for(x=1; x<counter-1 ; x++)
		{
		var=a[x]
		var2[var,tr]++
#		printf("var=%s\tv=%d\tx=%d\n",var, var2[var,tr],x)
		}
		
}
# Outgoing raw MIDI space separated globals only
match($0,/(^Outgoing: MIDI )(([g-n|y-z][a-z0-9](\s)*)*)/,a)	{
	searchstring=substr(a[2],1,length(a[2]))
#	printf("line=%s\tss:%s\n",$0,a[2])
	counter=1
	found=1
	mylength=RLENGTH
	currentlength=mylength
	while (found>0) {
	   match(searchstring,/[g-n|y-z][a-z0-9]/)
	   found=RSTART
	   mylength=RLENGTH
	   a[counter]=substr(searchstring,found,mylength)
	   currentlength=currentlength-mylength+1
	   searchstring=substr(searchstring,found+mylength,currentlength)
	   counter++
        }
	for(x=1; x<counter-1 ; x++)
		{
		var=a[x]
		var2[var,tr]++
#		printf("var=%s\tv=%d\tx=%d\n",var, var2[var,tr],x)
		}
		
}

END {
	for (y in var2)
	{
	b = substr(y,4)
	#printf("b=%s\n",b)
	if (length(b) >0)
		{
			printf("%s - %s\n",substr(name[b],12),  substr(y,1,2))
		}
	}
	printf("%d Total Translators",tr) 
    }
