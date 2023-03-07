function [fig] = makeResponsePlot(data, figureSpecs)
    
    xLen = 610;
    yLen = 550;
    subFigSz = 45;
    subFigXLen = subFigSz/xLen;
    subFigYLen = subFigSz/yLen;
	
	if ~isfield(figureSpecs, 'newPlotFlag') || ...
            isempty(figureSpecs.newPlotFlag)
		figureSpecs.newPlotFlag = true;
	end
		
	if figureSpecs.newPlotFlag
		fig = figure('Position', [0 0 xLen yLen]);
		ha = axes('units','normalized', 'position', [0 0 1 1]);
		uistack(ha,'bottom');
		imagesc(imread(figureSpecs.baseImage));
		colormap gray;
		set(ha, 'handlevisibility', 'off', 'visible','off');
	else
        fig = gca();
        hold on;
	end
	
	if ~isfield(figureSpecs, 'color') || isempty(figureSpecs.color)
        figureSpecs.color = [0 0 0];
	end
    
	if ~isfield(figureSpecs, 'alpha') || isempty(figureSpecs.alpha)
        figureSpecs.alpha = 0.6;
	end

    if ~isfield(figureSpecs, 'linewidth') || isempty(figureSpecs.linewidth)
        figureSpecs.linewidth = 1;
    end
    
    if ~isfield(figureSpecs, 'xticks') || isempty(figureSpecs.xticks)
        figureSpecs.xticks = ...
            0;
%             (ceil(min(timePoints)/100):floor(max(timePoints)/100))*100;
	end
    
	if ~isfield(figureSpecs, 'ymax') || isempty(figureSpecs.ymax)
		figureSpecs.ymax = max(abs(data(:)));
	end
    
    if ~isfield(figureSpecs, 'yticks') || isempty(figureSpecs.yticks)
        figureSpecs.yticks = (-1:0.5:1)*figureSpecs.ymax;
    end
    
	[timePointCount, channelCount, sampleCount] = size(data);
	load(figureSpecs.locationFile);
	xlimit = [min(figureSpecs.timePoints) max(figureSpecs.timePoints)];
    ylimit = [-1 1]*figureSpecs.ymax;
    
	for channelIter = 1:channelCount
        subplot('Position', ...
            [location(channelIter, 1) location(channelIter, 2), ...
            subFigXLen, subFigYLen]);
		hold on;
		if figureSpecs.newPlotFlag
			hold on;
			ylim(ylimit);
			yticks(figureSpecs.yticks);
			xlim(xlimit);
			xticks(figureSpecs.xticks);
            axis square;
			set(gca, 'TickLength', 0.05*[1 1]);
			plot([0 0], ylimit, 'Color', 'k', ...
                'LineStyle', '--', 'LineWidth', 0.5);
			plot(xlimit, [0 0], 'Color', 'k', ...
                'LineStyle', '--', 'LineWidth', 0.5);
			set(gca, 'FontSize', 5);
            set(gca, 'LineWidth', 1);
			set(gca, 'XTickLabel', []);
			set(gca, 'YTickLabel', []);
		end
		if size(data, 3) == 1
	 		plot(figureSpecs.timePoints, data(:, channelIter), ...
                'color', figureSpecs.color, ...
                'LineWidth', figureSpecs.linewidth);
		else
			plotWithErrorBars(figureSpecs.timePoints, ...
				reshape(data(:, channelIter, :), ...
                [timePointCount, sampleCount]), figureSpecs);
		end
	end
end