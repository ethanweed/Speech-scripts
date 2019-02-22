#!/bin/bash
cd /Users/ethan/Dropbox/Sharing/eigsti_filter/filtered_files
for file in *.wav

do
ffmpeg -i "$file" -filter:a "volume=15dB" "/Users/ethan/Dropbox/Sharing/eigsti_filter/boosted_500Hz/$file"
done