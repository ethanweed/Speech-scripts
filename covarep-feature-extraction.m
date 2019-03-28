%%
% Pipeline for feature extraction
%%
% remember to remove
%
% covarerp/....../external/backcompatability_2015/audioread.m from the path
%
in_dir = '/Users/ethan/Desktop/covarep_test_deleteme/soundfiles/';
sample_rate = 0.01;
COVAREP_feature_extraction(in_dir,sample_rate);

%%


cd /Users/ethan/Desktop/covarep_test_deleteme/matfiles

% make a struct with all the ".mat" files in the folder
files = dir('*.mat');



for i = 1:length(files)
    

    % get the next file name from the struct "files"
    filename = files(i,1).name;
    str = filename(1:end-10);
    sname = strcat(str, '.csv');
    
    dataset = load(filename);
    data = dataset.features;
    
   
    
    csvwrite(sname,data);
end    

disp('All done!');

%%
clear all
close all


cd '/Users/ethan/Desktop/eigsti_project/resampled_sound_files/'


frameSize = 30; % size of the frames (default = 30)
frameShift = 10; % duration between two successive frames. (default = 10)

% Outputs
%  formantPeaks    : vector containing the estimated frequencies (in Hz) of
%  the first 5 formants.
%  t_analysis      : [s] vector containing the analysis time instants.



% make a struct with all the ".mat" files in the folder
files = dir('*.wav');



for i = 1:length(files)
    

    % get the next file name from the struct "files"
    filename = files(i,1).name;
    str = filename(1:end-10);
    sname = strcat(str, '.csv');
    
    % extract formants
    [Y, FS]=audioread(filename);
    [formantPeaks,t_analysis]=formant_CGDZP(Y,FS,frameSize,frameShift);
   
    data = formantPeaks
    csvwrite(sname,data);
    
    disp(strcat('done with..... ', num2str(i), '/ ', num2str(length(files))))
end    

disp('All done!');




