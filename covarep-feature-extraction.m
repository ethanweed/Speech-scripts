
% Pipeline for feature extraction with COVAREP
% Ethan Weed
%
%%%%%%%%%%%%%%%%%%%%%%%
% Notes
%%%%%%%%%%%%%%%%%%%%%%%
%
%
% NOTE 1: This script is just a convenience script that calls functions
% from the COVAREP repository. The COVAREP functions need to be added to the Matlab path for the script to work
%
% COVAREP can be downloaded here:
%
% http://covarep.github.io/covarep/
%
%
% NOTE 2: wavfiles should be resampled to 16kHz if necessary
% This can be done with ffmpeg using shell script "resample_sound_files"
% from this repo. ffmpeg can be downloaded here:
%
% https://ffmpeg.org
%
%
% NOTE 3: At least for me (using COVAREP 1.4.2), it is necessary to remove the file:
% covarerp/....../external/backcompatability_2015/audioread.m 
% from Matlab path. Without doing this, the script crashes with the folowing error
% message: 
%
% Warning: An error occurred while analysing FILENAME: Undefined function 'wavread'
% for input arguments of type 'char'.
% 
% Error in audioread (line 3)
%     [y,Fs] = wavread(filename);
% 
% Error in COVAREP_feature_extraction (line 104)
%         [x,fs]=audioread([in_dir filesep basename '.wav']);
% 
% Error in LiveEditorEvaluationHelperESectionEval (line 10)
% COVAREP_feature_extraction(in_dir,sample_rate);
% 
% Error in matlab.internal.editor.evaluateCode 
%
%
%%%%%%%%%%%%%%%%%%%%%%%
% BEGIN SCRIPT
%%%%%%%%%%%%%%%%%%%%%%%
%
% edit in_dir for the correct path to the resampled sound files
in_dir = 'path/to/soundfiles/';

cd(in_dir)

mkdir 'acoustic_features_matfiles'
mkdir 'acoustic_features_csvfiles'
mkdir 'formant_peaks'
mkdir 'wav_files'

sample_rate = 0.01;
COVAREP_feature_extraction(in_dir,sample_rate);


% make a struct with all the ".mat" files in the folder
files = dir('*.mat');


for i = 1:length(files)
    

    % get the next file name from the struct "files"
    filename = files(i,1).name;
    str = filename(1:end-10);
    sname = strcat(str, '.csv');
    
    % add headers to the data
    dataset = load(filename);
    data = dataset.features;
    data = [dataset.names; num2cell(data)];
    
    % Convert cell to a table and use first row as variable names
    data_table = cell2table(data(2:end,:),'VariableNames',data(1,:));
 
    % Write the table to a CSV file
    writetable(data_table,sname);
    
   
end    


% clean up
movefile '*.mat' acoustic_features_matfiles
movefile '*.csv' acoustic_features_csvfiles


disp('Done with acoustic features');


% extract formant peaks

% clean up workspace
clearvars -except in_dir

cd(in_dir)


frameSize = 30; % size of the frames (default = 30)
frameShift = 10; % duration between two successive frames. (default = 10)

% Outputs
%  formantPeaks    : vector containing the estimated frequencies (in Hz) of
%  the first 5 formants.
%  t_analysis      : [s] vector containing the analysis time instants.

headers = {'F1', 'F2', 'F3', 'F4', 'F5'};

% make a struct with all the ".wav" files in the folder
files = dir('*.wav');


for i = 1:length(files)
    

    % get the next file name from the struct "files"
    filename = files(i,1).name;
    str = filename(1:end-10);
    sname = strcat(str, '.csv');
    
    % extract formants
    [Y, FS]=audioread(filename);
    [formantPeaks,t_analysis]=formant_CGDZP(Y,FS,frameSize,frameShift);
   
    % add headers to output file
    data = [headers; num2cell(formantPeaks)];
    data_table = cell2table(data(2:end,:),'VariableNames',data(1,:));
    
    % Write the table to a CSV file
    writetable(data_table,sname);
    
    disp(strcat('done with..... ', num2str(i), '/ ', num2str(length(files))))
end    

% clean up
movefile '*.csv' formant_peaks
movefile '*.wav' wav_files


disp('All done!');




