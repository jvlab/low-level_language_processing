%% Setup annotation specifications

annotationSpecs = struct; % initialization

% file containing time markers of all segments (phonemes) in seconds,
% provided in sampleInputFiles
annotationSpecs.timeMarkerFile = 'phonemeTimes.txt';

% file containing mapping of segments (phonemes) to classes
% provided in sampleInputFiles
annotationSpecs.entityClassMapFile = 'phonemeClassMap.txt';

% mapping of classes to numeric ID for faster comparison
% provided in sampleInputFiles
annotationSpecs.entityClassIDMapFile = 'classIDMap.txt';
	
% delimiting character of all 3 anotation files, must be same
annotationSpecs.delimChar = '\t';

