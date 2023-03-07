%% Setup defaults

frequencyBand = [2 15]; % Frequency band analyzed

%% Load default annotation specs
setupAnnotationSpecs;

disp('Select annotation file');
disp(cat(2, 'Annotation file : ', annotationSpecs.timeMarkerFile));

disp('Select phoneme to class map');
disp(cat(2, 'Phoneme to class map file : ', ...
    annotationSpecs.entityClassMapFile));

disp('Select class to ID map');
disp(cat(2, 'Class to ID map file : ', ...
    annotationSpecs.entityClassIDMapFile));

disp('Reading PRAAT annotation to create time markers with class ID ...');
[idTaggedTimeMarkers, classifiedTimeMarkers] = loadAnnotationFile(annotationSpecs);
disp('Done. Output is structure idTaggedTimeMarkers and array classifiesTimeMarkers');

%% Reading text file

% Loading default data file specifications
setupDataSpecs;

disp('Select data-set file');
disp(cat(2, 'Dataset to analyse (txt file) : ', dataSpecs.fileName));

disp('Reading recording data from dataset text file ...');
recordingData = readXLTekRecordingTextFile(dataSpecs);
disp('Done. Output is structure recordingData.');

recordingData.frequencyBand = frequencyBand;
disp('Filtering data ...');
recordingData.data = filterData(recordingData.data, ...
    dataSpecs.dataCollectionFrequency, recordingData.frequencyBand);
disp('Done. Filtered data is in recordingData.data');

disp('Extracting stimulus-specific response from read data ...');
stimulusSpecificResponse = extractStimulusSpecificResponse(recordingData);
disp('Done. Output is the structure stimlusSpecificResponse.');

disp('Extracting phoneme-specific responses ...');
phonemeSpecificResponses = extractEntitySpecificResponses(...
    stimulusSpecificResponse, idTaggedTimeMarkers);
disp('Done. Output is structure phonemeSpecificResponses.');

%% Statistical Testing 
setupStatisticalTestSpecs

disp(cat(2, 'Statistical Analysis using ', ...
    func2str(statisticalTestSpecs.statisticalTestFunction)));

% Perform statistical tests
disp('Doing statistical tests ...');
statisticalTestResults = pairwiseStatisticalTesting(...
    phonemeSpecificResponses, statisticalTestSpecs);
disp('Done with statistical tests.');

%% FDR Correction
setupFDRSpecs;

% FDR analysis
disp('Doing FDR correction ...');
significanceMaps = allPairsFDRCorrection(statisticalTestResults, fdrSpecs);
disp('Done.');

%% Plotting
loadColors;
warning('off', ...
    'MATLAB:handle_graphics:Patch:NumColorsNotEqualNumVertsException')

%% Figure 1A HC
setupResponsePlotSpecs;
phonemePairIter = 10;
pairID = ...
    statisticalTestResults.statisticalTestSpecs.idPairsToCompare(10, :);
timeIdx = 1:126;

% first phoneme category (Plosives)
figureSpecs.newPlotFlag = true;
figureSpecs.color = phonemeColors{pairID(1)};
indices = phonemeSpecificResponses.entityID == pairID(1);
data = phonemeSpecificResponses.data(timeIdx, :, indices);
fig1A = makeResponsePlot(data, figureSpecs);

% second phoneme category (Vowels)
figureSpecs.newPlotFlag = false;
figureSpecs.color = phonemeColors{pairID(2)};
indices = phonemeSpecificResponses.entityID == pairID(2);
data = phonemeSpecificResponses.data(timeIdx, :, indices);
makeResponsePlot(data, figureSpecs);

% highlight significance
figureSpecs.color = 'y';
data = significanceMaps.data(:, :, phonemePairIter);
markSignificanceInResponsePlot(data, figureSpecs);
sgtitle('Figure 1A: responses to plosives and vowels');

%% Figure 1B HC
setupSummaryPlotSpecs;
figureSpecs.ylim = struct('both', [0 1], 'time', [0 0.2], 'space', [0 0.4]);
fig1B = makeSummaryPlot(significanceMaps.data(:, :, phonemePairIter), figureSpecs);
sgtitle('Figure 1B: responses to plosives and vowels as a fingerprint');

%% Figure 1C HC
setupSummaryPlotSpecs;
figureSpecs.ylim = struct('both', [0 0.25], 'time', [0 0.05], 'space', [0 0.1]);
fig1C = makeSummaryPlot(mean(significanceMaps.data, 3), figureSpecs);
sgtitle('Figure 1C: average responses to all phoneme clas-pairs for the repeat');

