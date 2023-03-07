function fig = visualizeResults(data, visualizationSpecs)
	
	% Define operation
	if strcmp(visualizationSpecs.operation, 'union')
		operator = @(x, dimension) logical(sum(x, dimension));
	elseif strcmp(visualizationSpecs.operation, 'average')
		operator = @(x, dimension) mean(x, dimension);
	else
		error('Operator can only be average or union.');
	end
	
	% Figure handle to return
    fig = [];
    
    % Make plot
	if strcmp(visualizationSpecs.strategy, 'time')
		values = operator(data, 2);
		fig = makeTemporalPlot(values, visualizationSpecs.figureSpecs);
	elseif strcmp(visualizationSpecs.strategy, 'space')
		values = operator(data, 1);
		fig = makeTopoplot(values, visualizationSpecs.figureSpecs);
	elseif strcmp(visualizationSpecs.strategy, 'both')
		fig = makeFingerprintPlot(data, visualizationSpecs.figureSpecs);
	else
		error(cat(2, 'Wrong strategy. Choose time for temporal, ', ...
			'space for spatial, and both for spatio-temporal.'));
	end		
end
