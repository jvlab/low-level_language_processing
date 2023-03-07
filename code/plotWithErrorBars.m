function plotWithErrorBars(xValues, data, figureSpecs)
    if size(xValues, 1) > 1
        xValues = xValues';
    end
    meanValues = mean(data, 2);
	sz = size(data, 2);
	stdErr = std(data, 0, 2)/sqrt(sz-1);
	hold on;
	plot(xValues, meanValues, 'Color', figureSpecs.color, ...
        'LineWidth', figureSpecs.linewidth);
    fill([xValues flip(xValues)], ...
		[(meanValues - 1.96*stdErr); flip(meanValues + 1.96*stdErr)], ...
		figureSpecs.color, 'LineStyle', 'none', ...
        'FaceAlpha', figureSpecs.alpha, 'FaceColor', figureSpecs.color);
end
