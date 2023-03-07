function beautifySummaryPlot(fig)

	subPlots = flipud(fig.Children);
	mainFontSize = 16;

	subPlots(1).XAxis.FontSize = mainFontSize;
	subPlots(1).YAxis.FontSize = 12;
	subPlots(1).YLabel.FontSize = 16;
	subPlots(2).FontSize = mainFontSize;
	subPlots(2).TickLabels = zeroTrimmer(subPlots(2).TickLabels);
	subPlots(3).FontSize = mainFontSize;
	subPlots(3).YTickLabel = zeroTrimmer(subPlots(3).YTickLabel);
	subPlots(4).FontSize = mainFontSize;
	subPlots(5).FontSize = mainFontSize;
	subPlots(5).TickLabels = zeroTrimmer(subPlots(5).TickLabels);
	subPlots(5).Position = [0.1530 0.1101 0.0117 0.2151];
	subPlots(6).FontSize = mainFontSize;
	subPlots(6).YTickLabel = zeroTrimmer(subPlots(6).YTickLabel);

end