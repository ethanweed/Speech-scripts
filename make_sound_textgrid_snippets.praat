# Script for slicing a portion out of a wav file and associated TextGrid.
# The script assumes the .TextGrid files and the .wav files are in the same folder and the filenames are the same (except for the extension)


# clear out the Praat Info window
clearinfo

# make a popup that tells you what you are about to do
pauseScript: "Choose a directory for the input folder"

# choose the input directory and store the path in a variable
inDir$ = chooseDirectory$: "Choose the folder containing your wav files"
inDir$ = inDir$ + "/"
inDirWav$ = inDir$ + "*.wav"

# make a popup that tells you what you are about to do
pauseScript: "Choose the folder to save the extracted files in"

# choose the output directory and store the path in a variable
outDir$ = chooseDirectory$: "Choose the folder to save the extracted files"
outDir$ = outDir$ + "/"

# make a variable containing all the file names for the wav files
wavList = Create Strings as file list: "wavList", inDirWav$

# creates a popup that lets you set the desired start and end time for the selection
beginPause: "Select the time limits for splitting the files"
	comment: "Start time?"
	real: "startTime", 0
	comment: "End time?"
	real: "endTime", "100"
clicked = endPause: "Continue", 1


# loop that does all the work
numFiles = Get number of strings
for fileNum from 1 to numFiles

	# select the list with all the wav file names
	selectObject: wavList

	# get the next file name
	fileName$ = Get string: fileNum				

	# get the file name without the .wav extension
	# my file names were all 5 characters long, except for the extension
	fileRoot$ = left$ (fileName$, 5)

	# read the next wav file into a variable
	wav = Read from file: inDir$ + fileRoot$ + ".wav"

	# read the next TextGrid file into a variable
	text = Read from file: inDir$ + fileRoot$ + ".TextGrid"

	# give a status update	
	appendInfoLine: "Splitting file.... " + fileRoot$	
	# select the sound and extract the desired portion
	selectObject: wav
	partWav = Extract part: 180, 300, "rectangular", 1, "no"
	
	# select the TextGrid and extract the desired portion
	selectObject: text
	partText = Extract part: 180, 300, "no"
	
	# save the extracted sound with the old name
	# to the new folder
	selectObject: partWav
	Save as WAV file: outDir$ + fileRoot$ + ".wav"

	# select the extracted TextGrid with the old name
	# to the new folder
	selectObject: partText
	Save as text file: outDir$ + fileRoot$ + ".TextGrid"	
	# remove everything except the list of file names
	select all
    minus Strings wavList
    Remove

endfor

# status update
appendInfoLine: "All done!"

# final clean up
select Strings wavList
Remove




