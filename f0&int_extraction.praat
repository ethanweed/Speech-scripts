#By: Riccardo Fusaroli

clearinfo

chunkLength = 1000

# Defining all the relevant parameters

form Extracting pitch, intensity and syllables onset
   sentence directory /Users/semrf/DropBox
   real timestep 0.01
   real pitchFloor(Hz) 50
   real pitchCeiling(Hz) 700
   real intensityFloor(dB) 0
   real intensityCeiling(dB) 75
endform

# Read files

Create Strings as file list... list 'directory$'/*.wav
numberOfFiles = Get number of strings
for ifile to numberOfFiles
   select Strings list
   fileName$ = Get string... ifile
   Read from file... 'directory$'/'fileName$'

	type$ = left$ (selected$ (), index (selected$ (), " ")-1)
	name$ = selected$ (type$)

	if type$ = "Sound"
		# printline >'type$'<
		mySound = selected("Sound")
		To Pitch... timestep pitchFloor pitchCeiling
		q1 = Get quantile... 0 0 0.25 Hertz
		q3 = Get quantile... 0 0 0.75 Hertz
		Remove
                select mySound
		floor = q1*0.75
		ceiling = q3*1.75
		pitch = To Pitch... timestep floor ceiling

		table = Create Table with column names... 'name$'_f0 0 time f0
		for j to Object_'pitch'.nx
			call AnalyzeFrame_f0
		endfor
		select pitch
		Remove
	elsif type$ = "LongSound"
		# printline >'type$'<
		long = selected ()
		length = Get total duration
		chunks = ceiling (length / chunkLength)
		table = Create Table with column names... 'name$'_f0 0 time f0
		start = 0
		# printline 'chunks' chunks...
		for c to chunks
			select long 
			if c < chunks
				end = start + chunkLength
			else
				end = Object_'long'.xmax
			endif
			# printline Processing chunk 'c' of 'chunks' : 'start'..'end'
			part = Extract part... start end yes
			To Pitch... timestep pitchFloor pitchCeiling
			q1 = Get quantile... 0 0 0.25 Hertz
			q3 = Get quantile... 0 0 0.75 Hertz
			select long
			if c < chunks
				end = start + chunkLength
			else
				end = Object_'long'.xmax
			endif
			floor = q1*0.75
			ceiling = q3*2
			pitch = To Pitch... timestep pitchFloor pitchCeiling
			select part
			textgrid = To TextGrid (silences)... pitchFloor 0 -25 0.1 0.1 silent sounding
			intervals = Get number of intervals... 1
			label$ = Get label of interval... 1 intervals
			if label$ = "sounding"
				# printline Moving boundary to previous silence...
				a = Get start point... 1 intervals-1
				b = Get end point... 1 intervals-1
				end = a+((b-a)/2)
				select pitch
				lastframe = Get frame number from time... end
			else
				lastframe = Object_'pitch'.nx
			endif
			for j to lastframe
				call AnalyzeFrame_f0
			endfor
			select part
			plus pitch
			plus textgrid
			Remove
			start = end
		endfor
	endif
	select 'type$' 'name$'
   	Remove
	select Table 'name$'_f0
	Save as tab-separated file... 'directory$'/'name$'_f0.txt
	Remove

	Read from file... 'directory$'/'fileName$'
	type$ = left$ (selected$ (), index (selected$ (), " ")-1)
	name$ = selected$ (type$)
	
	if type$ = "Sound"
		# printline >'type$'<
		intensity = To Intensity... intensityCeiling timestep yes
		table = Create Table with column names... 'name$'_int 0 time int
		for j to Object_'intensity'.nx
			call AnalyzeFrame_int
		endfor
		select intensity
		Remove
	elsif type$ = "LongSound"
		# printline >'type$'<
		long = selected ()
		length = Get total duration
		chunks = ceiling (length / chunkLength)
		table = Create Table with column names... 'name$'_int 0 time int
		start = 0
		# printline 'chunks' chunks...
		for c to chunks
			select long 
			if c < chunks
				end = start + chunkLength
			else
				end = Object_'long'.xmax
			endif
			# printline Processing chunk 'c' of 'chunks' : 'start'..'end'
			part = Extract part... start end yes
			intensity = To Intensity... IntensityCeiling timestep yes
			select part
			textgrid = To TextGrid (silences)... pitchFloor 0 -25 0.1 0.1 silent sounding
			intervals = Get number of intervals... 1
			label$ = Get label of interval... 1 intervals
			if label$ = "sounding"
				 printline Moving boundary to previous silence...
				a = Get start point... 1 intervals-1
				b = Get end point... 1 intervals-1
				end = a+((b-a)/2)
				select intensity
				lastframe = Get frame number from time... end
			else
				lastframe = Object_'intensity'.nx
			endif
			for j to lastframe
				call AnalyzeFrame_int
			endfor
			select part
			plus intensity
			plus textgrid
			Remove
			start = end
		endfor
	endif

	select 'type$' 'name$'
   	Remove
	select Table 'name$'_int
	Save as tab-separated file... 'directory$'/'name$'_int.txt
	Remove
endfor
# printline Done

procedure AnalyzeFrame_f0
	select pitch
	time = Get time from frame number... j
	f0 = Get value in frame... j Hertz
	if f0 != undefined
		select table
		Append row
		Set numeric value... Object_'table'.nrow time 'time:3'
		Set numeric value... Object_'table'.nrow f0 'f0:2'
	endif
endproc

procedure AnalyzeFrame_int
	select intensity
	time = Get time from frame number... j
	int = Get value in frame... j
	if int != undefined
		select table
		Append row
		Set numeric value... Object_'table'.nrow time 'time:3'
		Set numeric value... Object_'table'.nrow int 'int:2'
	endif
endproc