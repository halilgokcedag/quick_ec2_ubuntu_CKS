import re
import os

#run the tf output command to save the output for ips
home_dir = os.system("terraform output>ips.txt")
  
# opening and reading the file 
with open('ips.txt') as fh:
   fstring = fh.readlines()
  
# declaring the regex pattern for IP addresses
pattern = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
  
# initializing the list object
lst=[]
  
# extracting the IP addresses
for line in fstring:

    #
    if "." in line:
        lst.append(pattern.search(line)[0])
  
# displaying the extracted IP addresses
#print(lst)
lst=lst[:3]
if len(lst)==3:
    number=1
    for i in lst:
        print("ubuntuk8s-"+str(number)+"\t"+i)
        number+=1