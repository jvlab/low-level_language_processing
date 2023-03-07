%% Loading default dataSpecs

setupDataSpecs;

%% Reading text file

dataSpecs.textFormat = input('Regex for reading data into matlab : ');

disp('Select data-set file');
[fileName, filePath] = uigetfile('*.txt');
dataSpecs.fileName = fullfile(filePath, fileName);
disp(cat(2, 'Dataset to analyse (txt file) : ', dataSpecs.fileName));

dataSpecs.numHeadboxElectrodes = input('Maximum number of electrodes recored in input file (eg 128) : ');
dataSpecs.numHeaderLines = input('Number of header lines containing file details to skip (eg 15) : ');
dataSpecs.channelsRecorded = input('Indices of electrode from file used to recording (eg 1:37, [1:2:32 40 45:50]) : ');
dataSpecs.triggerString = input('Trigger marking start and end of stimuli (eg ON) : ', 's');
dataSpecs.dataCollectionFrequency = input('Frequency of data collection in Hz (eg 250) : ');

dataSpecs.extractionInterval = input('Interval to be extracted, in seconds, 0 marks stimuli onset (eg [0 1] [-0.1 0.5]) : ');
dataSpecs.intervalsToDiscard = input('Intervals in seconds to discard due to artefacts, after manual inspection (eg [0 2; 24 26; 148 150) : ');
dataSpecs.maxCutoff = input('Threshold for removing data segments above x units of std on account of artefacts (eg 10) : ');

disp('Reading recording data from dataset text file ...');
recordingData = readXLTekRecordingTextFile(dataSpecs);
disp('Done. Output is structure recordingData.');

recordingData.frequencyBand = input('Frequency band to keep in bandpass filtering (eg [2 15]) : ');
disp('Filtering data ...');
recordingData.data = filterData(recordingData.data, ...
	dataSpecs.dataCollectionFrequency, recordingData.frequencyBand);
disp('Done. Filtered data is in recordingData.data');

disp('Extracting stimulus-specific response from read data ...');
stimulusSpecificResponse = extractStimulusSpecificResponse(recordingData);
disp('Done. Output is the structure stimlusSpecificResponse.');

%% Loading stimulus file

disp('Select stimuli file');
[fileName, filePath] = uigetfile('*.wav');
stimulus.fileName = fullfile(filePath, fileName);
disp(cat(2, 'Audio stimulus file (.wav file) : ', stimulus.fileName));
stimulus.frequencyBand = recordingData.frequencyBand;
stimulus.frequency = dataSpecs.dataCollectionFrequency;

stimulus.processedFileName = strrep(stimulus.fileName, '.wav', ...
	strcat('_B', num2str(stimulus.frequencyBand(1)), 'Hz_', ...
	num2str(stimulus.frequencyBand(2)), 'Hz_F', ...
	num2str(stimulus.frequency), 'Hz.mat'));

if isfile(stimulus.processedFileName)
	load(stimulus.processedFileName);
else
	stimulus = preprocessStimulusNSE(stimulus);
	save(stimulus.processedFileName, 'stimulus');
end

%% Estimate NSE
setupNSESpecs;

nseSpecs.blockSize = input('Size of segments in seconds (eg 2) : ');
nseSpecs.maxLag = input('Maximum lag for cross correlation in seconds (eg 1, 0.5) : ');

nseSpecs.numShuffles = input('Number of shuffles for empirical p-value estimation (eg 10000) : ');
nseSpecs.numBlocks = input('Number of block to break stimulus into, for breaking local temporal correlations (eg 10) : ');

[nseResponse, shuffledNSEResponse] = estimateNSE(...
	stimulusSpecificResponse, stimulus, nseSpecs);

%% p-value estimation

pValues.dataSpecs = dataSpecs;
pValues.nseSpecs = nseSpecs;
pValues.data = estimateEmpiricalPValues( ...
    nseResponse.data, shuffledNSEResponse.data);

%% FDR Correction
setupFDRSpecs
fdrSpecs.rate = input('Rate of FDR correction (eg: 0.05) : ');
fdrSpecs.strategy = input(...
    'Strategy for FDR correction (time, space, both) : ', 's');

% FDR analysis
disp('Doing FDR correction ...');
significanceMaps.data = estimateFDRCorrectedValues(pValues.data, fdrSpecs);
disp('Done.');

%% Saving results

