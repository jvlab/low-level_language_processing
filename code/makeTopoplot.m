function fig = makeTopoplot(data, figureSpecs)
	
	% Location file 
	if ~isfield(figureSpecs, 'locationFile') || ...
            isempty(figureSpecs.locationFile)
		disp('Select electrode location file');
		figureSpecs.locationFile = UIGetFileNameWithPath('*.locs', ...
            'Select electrode location file');
	end
	
	% Position
	if isfield(figureSpecs, 'position') && ~isempty(figureSpecs.position)
		figure('Position', figureSpecs.position);
	end
	
	% Plotting
	fig = topoplot(data, figureSpecs.locationFile, 'style', 'fill');
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
		shading interp;
	end
	
	% Title
	if isfield(figureSpecs, 'title')
		title(figureSpecs.title);
	end
    
	hold off;
end