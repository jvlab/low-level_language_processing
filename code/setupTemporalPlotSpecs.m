%% Setting properties for temporal plot

% initialization
figureSpecs = struct;

% axis properties
figureSpecs.timePoints = 0:4:500;
figureSpecs.title = '';
figureSpecs.color = [0 0 1 1];
figureSpecs.linewidth = 1;

figureSpecs.xlim = [0 500];
figureSpecs.xlabel = 'Time (ms)';
figureSpecs.xticks = 0:100:500;
figureSpecs.xticklabels = 'auto';

figureSpecs.ylim = 'auto';
figureSpecs.ylabel = 'Response';
figureSpecs.yticks = 'auto';
figureSpecs.yticklabels = 'auto';

