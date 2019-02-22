# Ethan Weed
# Spring 2019
# Basically copy/pasted entirely from: http://www.praatscriptingtutorial.com/loopingThroughFiles

# Save the files in the wrong folder, but whatever...

clearinfo

# read files
inDir$ = chooseDirectory$: "Select folder with your .wav files"

if inDir$ == ""
	exitScript: "No folder given. Exiting"
endif

inDir$ = inDir$ + "/"
inDirWild$ = inDir$ + "*.wav"

# Get list of files
wavList = Create Strings as file list: "wavList", inDirWild$

# See how many there are for the loop
numFiles = Get number of strings

#if there are no files, we have a problem
if numFiles == 0
	exitScript: "I didn't find any .wav files in that folder. Exiting"
endif

outDir$ = chooseDirectory$: "Select a folder to store the output files"

for fileNum from 1 to numFiles

	# I always select objects explicitly
	# at the beginning of a loop, since
	# they may not be selected by the end
	
	selectObject: wavList
	wavFile$ = Get string: fileNum
	wav = Read from file: inDir$ + wavFile$
	
	filt = Filter (pass Hann band): 0, 400, 100
	
	# Get the name of the object, use it
	# to create a file name for the TextGrid
	
	objName$ = selected$: "Sound"
	outPath$ = outDir$ + "/" + objName$ + ".wav"

	# Since this will be for the "public",
	# be strict about overwriting files
	if fileReadable: outPath$
		pauseScript: objName$ + ".wav" + " exists! Overwrite?"
	endif
	
	Save as WAV file: outPath$

	# Remove newly opened objects for cleanup
	selectObject: wav
	plusObject: filt
	Remove
endfor
	
	
# Remove the wav list
selectObject: wavList
Remove

# Friendly message
pauseScript: "All done!"

