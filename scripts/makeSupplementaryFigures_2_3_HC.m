%% Loading default dataSpecs

setupDataSpecs;

%% Reading text file

disp(cat(2, 'Dataset to analyse (txt file) : ', dataSpecs.fileName));

disp('Reading recording data from dataset text file ...');
recordingData = readXLTekRecordingTextFile(dataSpecs);
disp('Done. Output is structure recordingData.');

recordingData.frequencyBand = [2 15];
disp('Filtering data ...');
recordingData.data = filterData(recordingData.data, ...
	dataSpecs.dataCollectionFrequency, recordingData.frequencyBand);
disp('Done. Filtered data is in recordingData.data');

disp('Extracting stimulus-specific response from read data ...');
stimulusSpecificResponse = extractStimulusSpecificResponse(recordingData);
disp('Done. Output is the structure stimlusSpecificResponse.');

%% Loading stimulus file

disp('Loading stimulus specifications');
setupStimulusSpecs;
disp(cat(2, 'Audio stimulus file (.wav file) : ', stimulusSpecs.fileName));

filePath = fileparts(which(stimulusSpecs.fileName));
stimulusSpecs.processedFileName = strcat(filePath, '/', stimulusSpecs.processedFileName);

if isfile(stimulusSpecs.processedFileName)
	load(stimulusSpecs.processedFileName);
    disp(strcat("Loaded NSE from ", stimulusSpecs.processedFileName), ".");
else
	stimulus = preprocessStimulusNSE(stimulusSpecs);
	save(stimulusSpecs.processedFileName, 'stimulus');
    disp('Done. Extracted NSE.');
end


%% Estimate NSE
setupNSESpecs;

disp("Estimating NSE using empirical p-value distributions ...");
[nseResponse, shuffledNSEResponse] = estimateNSE(...
	stimulusSpecificResponse, stimulus, nseSpecs);
disp("Done. Output in structure nseResponse.");

%% FDR Correction
setupFDRSpecs;
lag0Idx = 0.5*size(nseResponse.pValues, 1) + 0.5;

% FDR analysis
disp('Doing FDR correction ...');
significanceMaps.data = ...
    estimateFDRCorrectedValues(nseResponse.pValues(lag0Idx:end, :), fdrSpecs);
disp('Done.');

%% Plotting
loadColors;
warning('off', ...
    'MATLAB:handle_graphics:Patch:NumColorsNotEqualNumVertsException');

%% Figure S1A HC
setupResponsePlotSpecs;
figureSpecs.ymax = 0.25;
timeIdx = 125 + (1:126);

figureSpecs.newPlotFlag = true;
figureSpecs.color = 0.3*[1 1 1];
figureSpecs.linewidth = 1;
figS2A = makeResponsePlot(nseResponse.data(timeIdx, :), figureSpecs); 
figureSpecs.newPlotFlag = false;
figureSpecs.color = 'y';
data = significanceMaps.data;
markSignificanceInResponsePlot(data, figureSpecs);
sgtitle('Figure S1A: NSE tracking response for 500 ms');

%% Figure S1B HC
setupSummaryPlotSpecs;
figureSpecs.ylim = struct('both', [0 1], 'time', [0 0.2], 'space', [0 0.2]);
figS2B = makeSummaryPlot(significanceMaps.data, figureSpecs);
sgtitle('Figure S1A: NSE tracking response for 500 ms as a fingerprint');
