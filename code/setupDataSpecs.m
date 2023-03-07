%% Setting base variables for file

dataSpecs = struct; % initialization

% file name with path (full or relative)
dataSpecs.fileName = 'sample_HC_data.txt';

% maximum number of electrodes recored in input file
dataSpecs.numHeadboxElectrodes = 128;

% number of lines containing file details
dataSpecs.numHeaderLines = 15;

% electrode indices from file used to recording
dataSpecs.channelsRecorded = 1:37;

% trigger marking start and end of stimuli
dataSpecs.triggerString = 'ON';

% frequency of data collection in Hz
dataSpecs.dataCollectionFrequency = 250;

% interval to be extracted, in seconds, 0 marks stimuli onset
dataSpecs.extractionInterval = [-0.2 0.5];

% intervals in seconds to discard due to artefacts, after manual inspection
dataSpecs.intervalsToDiscard = [0 3; 145 150]; 

% threshold for removing data segments above x units std on account of artefacts
dataSpecs.maxCutoff = 10;

% regex for reading file completely into a matlab structure
% with data, time, event bytes, data, and event markers
dataSpecs.textFormat = cat(2, '%s %s %d64 ', ...
	repmat('%f64 ', 1, dataSpecs.numHeadboxElectrodes), ' %s');

