%% Specification for spatio-temporal summary plot

% initialization 
figureSpecs = struct;

% position
figureSpecs.position = [];

% % introduce lines to separate channels based on brain regions
figureSpecs.channelBreaks = [];

% time points
figureSpecs.timePoints = 0:4:500;

% color specification
figureSpecs.colormap = colormap(flipud(gray));
figureSpecs.caxis = 'auto';
figureSpecs.colorbar = [];
figureSpecs.shading = 'flat';

% axis properties
figureSpecs.title = '';

figureSpecs.xlim = [0 500];
figureSpecs.xlabel = 'Time (ms)';
figureSpecs.xticks = 0:100:500;
figureSpecs.xticklabels = 'auto';

figureSpecs.ylim = 'auto';
figureSpecs.ylabel = 'Channels';
figureSpecs.yticks = 'auto';
figureSpecs.yticklabels = 'auto';
