function fig = makeFingerprintPlot(data, figureSpecs)
	
	% Initializing figure specifications if not provided
	if nargin < 2
		figureSpecs = struct;
	end
	
	% Position
	if isfield(figureSpecs, 'position') && ~isempty(figureSpecs.position)
		figure('Position', figureSpecs.position);
	end
	
	% Timepoints
	[numTimePoints, numChannels] = size(data);
	if ~isfield(figureSpecs, 'timePoints') || isempty(figureSpecs.timePoints)
		figureSpecs.timePoints = 1:numTimePoints;
	end
	
	% Plotting
	[X, Y] = meshgrid(figureSpecs.timePoints, 1:(numChannels+1));
	data(:, numChannels+1) = data(:, numChannels);
	fig = surface(X, Y, data');
	hold on;
	
	%% Editing
	
	% Colormap details
	if isfield(figureSpecs, 'colormap')
    	colormap(figureSpecs.colormap);
	end
	
	% Setting color range
	if isfield(figureSpecs, 'caxis')
		caxis(figureSpecs.caxis);
	end
	
	% Displaying colorbar
	if isfield(figureSpecs, 'colorbar') && ...
            ~isempty(figureSpecs.colorbar)
		colorbar(figureSpecs.colorbar);
	else
        colorbar();
	end
    
    % Shading
	if isfield(figureSpecs, 'shading')
		shading(figureSpecs.shading);
	else
		shading flat;
	end
	
	% X-Axis details
	if isfield(figureSpecs, 'xlim')
		xlim(figureSpecs.xlim);
	end
	if isfield(figureSpecs, 'xlabel')
		xlabel(figureSpecs.xlabel);
	end
	if isfield(figureSpecs, 'xticks')
		xticks(figureSpecs.xticks);
	end
	if isfield(figureSpecs, 'xticklabels')
		xticklabels(figureSpecs.xticklabels);
	end
	
    % plotting lines to differentiate brain regions
	if isfield(figureSpecs, 'channelBreaks') && ...
            ~isempty(figureSpecs.channelBreaks)
        for breakIter = figureSpecs.channelBreaks
			plot(figureSpecs.xlim, breakIter*[1 1], 'k');
        end
	end
    
	% Y-Axis details
	if isfield(figureSpecs, 'ylim')
		ylim(figureSpecs.ylim);
	end
	if isfield(figureSpecs, 'ylabel')
		ylabel(figureSpecs.ylabel);
	end
	if isfield(figureSpecs, 'yticks')
		yticks(figureSpecs.yticks);
	end
	if isfield(figureSpecs, 'yticklabels')
		yticklabels(figureSpecs.yticklabels);
	end
	
	% Title
	if isfield(figureSpecs, 'title')
		title(figureSpecs.title);
	end
	
	hold off;
end