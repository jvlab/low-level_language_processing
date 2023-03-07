%% Loading default dataSpecs

setupDataSpecs;

%% Reading text file

disp('Select data-set file');
[fileName, filePath] = uigetfile('*.txt');
dataSpecs.fileName = fullfile(filePath, fileName);
disp(cat(2, 'Dataset to analyse (txt file) : ', dataSpecs.fileName));

dataSpecs.textFormat = input('Regex for reading data into matlab : ');

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

band = input('Frequency band to keep in bandpass filtering (eg [2 15]) : ');
disp('Filtering data ...');
recordingData.data = filterData(recordingData.data, ...
	dataSpecs.dataCollectionFrequency, band);
disp('Done. Filtered data is in recordingData.data');

disp('Extracting stimulus-specific response from read data ...');
stimulusSpecificResponse = extractStimulusSpecificResponse(recordingData);
disp('Done. Output is the structure stimlusSpecificResponse.');

%% Load default annotation specs
setupAnnotationSpecs;

disp('Select annotation file');
[fileName, filePath] = uigetfile('*.txt');
annotationSpecs.timeMarkerFile = fullfile(filePath, fileName);
disp(cat(2, 'Annotation file : ', annotationSpecs.timeMarkerFile));

disp('Select phoneme to class map');
[fileName, filePath] = uigetfile('*.txt');
annotationSpecs.entityClassMapFile = fullfile(filePath, fileName);
disp(cat(2, 'Phoneme to class map file : ', annotationSpecs.entityClassMapFile));

disp('Select class to ID map');
[fileName, filePath] = uigetfile('*.txt');
annotationSpecs.entityClassIDMapFile = fullfile(filePath, fileName);
disp(cat(2, 'Class to ID map file : ', annotationSpecs.entityClassIDMapFile));

disp('Reading PRAAT annotation to create time markers with class ID ...');
[idTaggedTimeMarkers, classifiedTimeMarkers] = loadAnnotationFile(annotationSpecs);
disp('Done. Output is structure idTaggedTimeMarkers and array classifiesTimeMarkers');

stimulusSpecificResponse.dataSpecs = dataSpecs;

disp('Extracting phoneme-specific responses ...');
phonemeSpecificResponses = extractEntitySpecificResponses(stimulusSpecificResponse, idTaggedTimeMarkers);
disp('Done. Output is structure phonemeSpecificResponses.');

%% Statistical Testing 
setupStatisticalTestSpecs

statisticalTestSpecs.statisticalTestFunction = input('Function handle for pairrwise test to use (eg @estimateRanksum) : ');
disp(cat(2, 'Statistical Analysis using ', func2str(statisticalTestSpecs.statisticalTestFunction)));

statisticalTestSpecs.empiricalEstimateFlag = input('Estimate p-values empirically (true, false): ');
statisticalTestSpecs.idPairsToCompare = input('List of entity id pairs for statistical testing (eg all, [1 3; 1 4]) : ', 's');
if ~strcmp(statisticalTestSpecs.idPairsToCompare, 'all')
	statisticalTestSpecs.idPairsToCompare = str2num(statisticalTestSpecs.idPairsToCompare);
end
statisticalTestSpecs.tailed = input('Sideness of test (both, right, left) : ', 's');
statisticalTestSpecs.analysisInterval = input('Analysis interval in seconds, 0 marks phoneme onset (eg [0 1] [-0.1 0.5]) : ');

if statisticalTestSpecs.empiricalEstimateFlag
	statisticalTestSpecs.numShuffles = input('Numebr of shuffles for null distribution (eg 1000) : ');
	statisticalTestSpecs.numBlocks = input({'Number of blocks to break stimulus duration into', ...
		'to preserve short range correlation (eg 10) : '});
 	statisticalTestSpecs.seeds = input('Seeds for shuffles (eg 1:1000, []) : ');
end

% Perform statistical tests
disp('Doing statistical tests ...');
[statisticalTestResults, empiricalStats] = pairwiseStatisticalTesting(phonemeSpecificResponses, ...
	statisticalTestSpecs);
disp('Done with statistical tests.');

%% FDR Correction
setupFDRSpecs
fdrSpecs.rate = input('Rate of FDR correction (eg: 0.05) : ');
fdrSpecs.strategy = input(...
    'Strategy for FDR correction (time, space, both) : ', 's');

% FDR analysis
disp('Doing FDR correction ...');
significanceMaps = allPairsFDRCorrection(statisticalTestResults, fdrSpecs);
disp('Done.');

%% Saving results


