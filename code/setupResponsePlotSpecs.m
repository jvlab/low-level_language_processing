%% Setting properties for response headplot

% initialization
figureSpecs = struct;

% make a new figure or plot on the open figure
figureSpecs.newPlotFlag = true;

% base montage image to plot over, provided in sampleInputFiles
figureSpecs.baseImage = 'EEGMontageBase37.png'; 

% file with location of subplots, provided in sampleInputFiles
figureSpecs.locationFile = 'channelLocations37.mat';

% color specification
figureSpecs.color = [0 0 0];

% transparency level of error region
figureSpecs.alpha = 0.3;

% linewidth for average response
figureSpecs.linewidth = 1;

% axis properties
figureSpecs.timePoints = 0:4:500;

figureSpecs.xlim = [0 500];
figureSpecs.xticks = 0:100:500;

figureSpecs.ymax = 0.25;
figureSpecs.yticks = '';


