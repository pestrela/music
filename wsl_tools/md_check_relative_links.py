#!/usr/bin/env python3

from yapu.imports.all import *



parser = argparse.ArgumentParser(description="merge cues and tracklists",
  formatter_class=argparse.RawDescriptionHelpFormatter,
  epilog=""
)

parser.add_argument('file', type=str, nargs='?',
                    help='file to analyse')


                    
parser.add_argument('-n', dest="match_count", default=16, type=int,
                    help='Number of characters to match to show hint')

                    
parser.add_argument('-v', dest="verbose", default=False, action="store_true",
                    help='verbose')
                    
parser.add_argument('-s', dest="single", default=False, action="store_true",
                    help='exit at first error')
                    
                    
opts = parser.parse_args()


  

########
#print(opts.file)

text = file_to_ml(opts.file)

links = text.re_findall(r'\(#.+?\)')
links = st_chop_lines(links, 1)
links = st_lower(links)
links = st_uniq(links)


regexp_replace_chars = r"[ \(\),:\?=]"

headers = text.re_findall(r'^#+ .*$', re.MULTILINE)
headers = [ RString(st).re_sub(r"^#+ ", "#")
  .re_sub(regexp_replace_chars, "-")
  .re_sub(r"--+", r"-")
  .re_sub(r"\/")
  .re_sub(r"-$", "") 
  
  for st in headers ]
headers = st_lower(headers)
headers = st_sort(headers)


if opts.verbose:
  st_print(headers)
  print()


print("Checking file: %s" % (opts.file))
 
  
errors = 0
for link in links:
  if not link in headers:
    errors += 1
    print("\n\nError:\n%s" % (link))
    
    if opts.match_count:
      print("Options are:")
      st_print(st_startswith_min(link, headers, opts.match_count))
      
    if opts.single:
      break

if errors == 0:
  print("No errors detected")
  sys.exit(0)
 
else:  
  print("Detected errors in file.")
  sys.exit(1)
 