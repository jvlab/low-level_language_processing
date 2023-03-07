%% Specifications for topoplot, needs eeglab path added to path variable

% initialization 
figureSpecs = struct;

% location file
figureSpecs.locationFile = 'channels37.locs'; % provided in sampleInputFiles

% position
figureSpecs.position = [];

% color specification
figureSpecs.colormap = flipud(gray);
figureSpecs.caxis = 'auto';
figureSpecs.colorbar = [];
figureSpecs.shading = 'interp';

% title
figureSpecs.title = '';

