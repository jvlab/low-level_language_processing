%% Setting basic visualizations specs common to all plots

% initialization
visualizationSpecs = struct;

% axis to plot 'time' for temporal, 'space' for topoplot, 
% 'both' for spatiotemporal surface plot
visualizationSpecs.strategy = 'both';

% method to combine across multiple datasets and pairs
visualizationSpecs.operation = 'average';

% initialization of strategy specific figure specifications
visualizationSpecs.figureSpecs = struct;
