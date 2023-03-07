function fig = makeTemporalPlot(data, figureSpecs)

	% Time points (x-values)
	if ~isfield(figureSpecs, 'timePoints') || isempty(figureSpecs.timePoints)
		figureSpecs.timePoints = 1:length(data);
	end
	
	% Plotting
	fig = plot(figureSpecs.timePoints, data);
	hold on;
	
	%% Editing
	
	% Title
	if isfield(figureSpecs, 'title'), title(figureSpecs.title); end
	
	% Line color
	if isfield(figureSpecs, 'color'), fig.Color = figureSpecs.color; end
    
    % Linewidth
	if isfield(figureSpecs, 'linewidth')
		fig.LineWidth = figureSpecs.linewidth;
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
	
	hold off;
end