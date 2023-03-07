%% Specification for the components summary plot

% timePoints
figureSpecs.timePoints = 0:4:500;

% y-limit for spatiotemporal, temporal, and spatial plots, respectively
figureSpecs.ylim = struct('both', [0 1], 'time', [0 1], 'space', [0 1]);

% File with channel locations for making topoplot
figureSpecs.locationFile = 'channels37.locs';

% File containing channel names
figureSpecs.channelLabelsFile = 'channelLabels.txt';

% Rearranging channel labels to plot top to bottom, and then left to right
figureSpecs.plotIndices = [8:14 1:2 36 3:7 15:21 22 37 23:35];

% Introduce breaks via lines for grouping electrodes on spatiotemporal plot
% by providing index of reordered channels
figureSpecs.channelBreaks = [8 16 23 31];

