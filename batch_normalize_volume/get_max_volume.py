#read file into python

# Ethan Weed
# Spring 2019

# get maximum volume from file "read_volume.txt"
# find gain needed to add to bring dB to zero
# save output as "gain_adjust.txt"

import os
pathin = 'path/to/read_volume/file'
file = 'read_volume.txt'

os.chdir(pathin)

with open(file,'r') as f:
    text = f.read()
text = text.split('\n')
maxvol = text[27]
maxvol = ''.join(maxvol)
maxvol = maxvol.split()
maxvol = maxvol[4]
maxvol = float(maxvol)

# reduce 0 to e.g. -5 or less if the output files are getting clipped
gain_adjust = str(0-maxvol)



with open('gain_adjust.txt', 'a+') as newfile:
    newfile.write(gain_adjust)
newfile.close()
