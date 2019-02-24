#!/bin/bash

# Ethan Weed
# Spring 2019
# Based on code snippets found here: https://superuser.com/questions/323119/how-can-i-normalize-audio-using-ffmpeg

cd /inputpath/
for file in *.wav

do 

# find the maximum volume of the sound file and save in text file
ffmpeg -i "$file" -af volumedetect -f null -y nul &> read_volume.txt

# call python script to parse text file output from above and calculate gain needed to bring maximum dB to zero
python path_to_python_file/get_max_volume.py gain_adjust.txt
gain_adjust=$(<path_to_python_outputfile/gain_adjust.txt)
echo "$gain_adjust"

# adjust sound file by value calculated above
ffmpeg -i "$file" -af "volume=$gain_adjust" "path_to_output_directory/$file"

# clean up
rm gain_adjust.txt
rm read_volume.txt

done
