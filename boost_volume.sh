#!/bin/bash
cd /path_to_input_files
for file in *.wav

do
ffmpeg -i "$file" -filter:a "volume=15dB" "path_to_output_files/$file"
done