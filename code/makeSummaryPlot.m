function figureF = makeSummaryPlot(data, summaryFigureSpecs)

	figureF = figure('units','normalized','outerposition',[0 0 0.75 1]);
	
	%% Both
	setupVisualizationSpecs;
	visualizationSpecs.strategy = 'both';
	setupFingerprintPlotSpecs;
    figureSpecs.timePoints = summaryFigureSpecs.timePoints;
    figureSpecs.xlim = ...
        [min(figureSpecs.timePoints) max(figureSpecs.timePoints)];
    figureSpecs.xticks = 100 * (ceil(min(figureSpecs.timePoints)/100): ...
        floor(max(figureSpecs.timePoints)/100));
    figureSpecs.xlabel = '';
    
    figureSpecs.caxis = summaryFigureSpecs.ylim.both;
	channelCount = length(summaryFigureSpecs.plotIndices);
	figureSpecs.ylim = [1 channelCount+1];
	figureSpecs.yticks = 1.5:(channelCount+0.5);
    
    channelNames = strsplit(fileread(summaryFigureSpecs.channelLabelsFile));
    channelLabels = channelNames(~cellfun('isempty', channelNames));

	figureSpecs.yticklabels = channelLabels( ...
        summaryFigureSpecs.plotIndices);
    figureSpecs.channelBreaks = summaryFigureSpecs.channelBreaks;
	visualizationSpecs.figureSpecs = figureSpecs;

    subplot(10, 10, [4:10 64:70]);
	hold on;
	visualizeResults(data(:, summaryFigureSpecs.plotIndices), ...
        visualizationSpecs);
    c = colorbar;
    c.Ticks = [figureSpecs.caxis(1), mean(figureSpecs.caxis), ...
        figureSpecs.caxis(2)];
    figureF.Children(1).AxisLocation = 'out';
    figureF.Children(1).Position = ...
        figureF.Children(1).Position + [0.05 0 0 0];
    
	set(gca, 'YDir','reverse');
	clear visualizationSpecs figureSpecs

	%% Temporal
	setupVisualizationSpecs
	visualizationSpecs.strategy = 'time';
	setupTemporalPlotSpecs
    
	figureSpecs.timePoints = summaryFigureSpecs.timePoints;
	figureSpecs.xlim = ...
        [min(figureSpecs.timePoints) max(figureSpecs.timePoints)];
    figureSpecs.xticks = 100 * (ceil(min(figureSpecs.timePoints)/100): ...
        floor(max(figureSpecs.timePoints)/100));
    figureSpecs.ylim = summaryFigureSpecs.ylim.time;
    figureSpecs.yticks = [figureSpecs.ylim(1), ...
        mean(figureSpecs.ylim),  figureSpecs.ylim(2)];
	figureSpecs.color = 'k';
    figureSpecs.ylabel = '';
	figureSpecs.linewidth = 2;
	visualizationSpecs.figureSpecs = figureSpecs;

	subplot(3, 30, 70:90);
	hold on;
	visualizeResults(data, visualizationSpecs);
	clear visualizationSpecs figureSpecs

	%% Topoplot
	setupVisualizationSpecs;
	visualizationSpecs.strategy = 'space';
	setupTopoplotSpecs;

	figureSpecs.locationFile = summaryFigureSpecs.locationFile;
    figureSpecs.caxis = summaryFigureSpecs.ylim.space;
	visualizationSpecs.figureSpecs = figureSpecs;

   	subplot(3, 10, 21:23);
    visualizeResults(data, visualizationSpecs);
    c = colorbar;
    c.Ticks = [figureSpecs.caxis(1), mean(figureSpecs.caxis), ...
        figureSpecs.caxis(2)];
	figureF.Children(1).Location = 'westoutside';
    figureF.Children(1).Position = ...
        figureF.Children(1).Position + [-0.02 0 0 0]; 

	text(0.15, 0.05, 'L', 'HorizontalAlignment', 'right', 'FontWeight', ...
        'bold', 'FontSize', 16, 'Color', 'k', 'Units', 'normalized');
	text(0.95, 0.05, 'R', 'HorizontalAlignment', 'right', 'FontWeight', ...
        'bold', 'FontSize', 16, 'Color', 'k', 'Units', 'normalized');
	clear figureSpecs

	%% Spatial

	subplot(10, 20, [2:5 122:125]);
	hold on;
	channelFrequency = mean(data(:, summaryFigureSpecs.plotIndices));
	bar(channelFrequency, 'k');
	xlim([0.5 channelCount+0.5]);
	xticks(1:channelCount);
	xticklabels([]);
    ylimit = summaryFigureSpecs.ylim.space;
	ylim(ylimit);
    yticks([ylimit(1) mean(ylimit) ylimit(2)]);
	ylabel('');
	set(gca, 'XDir','reverse')
	camroll(90);

end