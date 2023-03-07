%% Setup stimulus file specifications

stimulusSpecs = struct;

% Name of the stimulus file
stimulusSpecs.fileName = 'alice.wav';

% For filtering data in the same wavelength as EEG
stimulusSpecs.frequencyBand = [2 15];

% For downsampling to the same frequency as EEG
stimulusSpecs.frequency = 250;

% Filename to save the NSE in
stimulusSpecs.processedFileName = strrep(stimulusSpecs.fileName, '.wav', ...
	strcat('_B', num2str(stimulusSpecs.frequencyBand(1)), 'Hz_', ...
	num2str(stimulusSpecs.frequencyBand(2)), 'Hz_F', ...
	num2str(stimulusSpecs.frequency), 'Hz.mat'));
