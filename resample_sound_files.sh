#!/bin/sh
for file in /path/to/sound_files/*
do
 ffmpeg -i $file -ac 1 -ar 16000 ${file%.wav}.16kHz.wav
 mv ${file%.wav}.16kHz.wav /path/to/output
done