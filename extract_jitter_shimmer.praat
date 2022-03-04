# Extract jitter and shimmer
# Ethan Weed
# Most of this script adapted from scripts on https://www.praatscriptingtutorial.com/


# Create a Table with no rows
table = Create Table with column names: 
..."table", 0, "file jitter(local) shimmer(local)"


#################################
# specifiy input and output directories
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
#################################


for fileNum from 1 to numFiles

	# Always select objects explicitly
	# at the beginning of a loop, since
	# they may not be selected by the end
	
	selectObject: wavList
	wavFile$ = Get string: fileNum
	wav = Read from file: inDir$ + wavFile$
	
	selectObject: wav
	p = To Pitch (cc): 0, 75, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14, 600
	
	selectObject: wav
	plusObject: p
	pp = To PointProcess (cc)
	
	selectObject: wav
	plusObject: p
	plusObject: pp
	voiceReport$ = Voice report: 0, 0, 75, 500, 1.3, 1.6, 0.03, 0.45
	jitter = extractNumber (voiceReport$, "Jitter (local): ")
	shimmer = extractNumber (voiceReport$, "Shimmer (local): ")
	jitter$ = string$ (jitter)
	shimmer$ = string$ (shimmer)

	
	selectObject(table)
	Append row
	current_row = Get number of rows
	Set string value:  current_row, "file", wavFile$
	Set string value:  current_row, "jitter(local)", jitter$
	Set string value: current_row, "shimmer(local)", shimmer$
	

	# Remove newly opened objects for cleanup
	selectObject: wav
	plusObject: p
	plusObject: pp
	Remove
endfor

selectObject(table)
Save to comma-separated file: outDir$+ "/" + "voice_report.csv"