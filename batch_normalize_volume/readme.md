# Batch Normalize Volume

- shell script uses ffmpeg to calculate max volume and re-encode files with added gain.
- python script parses output from ffmpeg volumedetect 


If the output files are clipping, reduce the desired output dB in the python script