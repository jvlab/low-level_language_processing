%% Pairwise statistical test for a single pair of entity classes, given their responses and testing specs

function [singlePairResults] = singlePairStatisticalTesting(...
    responseToFirstClass, responseToSecondClass, statisticalTestSpecs)

	% Case for all idsCompare
	[numTimepoints, numChannels, ~] = size(responseToFirstClass);
	singlePairResults.pValues = nan(numTimepoints, numChannels);
	singlePairResults.statisticValues = [];

	% Initialize statistical values array for empirical p-value estimation
	if statisticalTestSpecs.empiricalEstimateFlag
		singlePairResults.statisticValues = nan(numTimepoints, numChannels);
	end
	
	% Estimation for each channel and each time point
	for channelIter = 1:numChannels
		for timeIter = 1:numTimepoints
			if statisticalTestSpecs.empiricalEstimateFlag
				% Case of statistics estimation
				singlePairResults.statisticValues(timeIter, channelIter) = ...
					statisticalTestSpecs.statisticalTestFunction(...
					responseToFirstClass(timeIter, channelIter, :), ...
					responseToSecondClass(timeIter, channelIter, :), ...
					statisticalTestSpecs.tailed);
			else
				% Case of p-value evaluation
				[~, singlePairResults.pValues(timeIter, channelIter)] = ...
					statisticalTestSpecs.statisticalTestFunction(...
					responseToFirstClass(timeIter, channelIter, :), ...
					responseToSecondClass(timeIter, channelIter, :), ...
					statisticalTestSpecs.tailed);
			end
		end
	end
	clear responseToFirstClass responseToSecondClass statisticalTestSpecs
end
