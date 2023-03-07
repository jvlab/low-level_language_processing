%% Estimate statistically significant difference in spatial and temporal domain for all pairs

function [significanceMaps] = allPairsFDRCorrection( ...
    statisticalTestResults, fdrSpecs)
		
	[numTimepoints, numChannels, numPairs] = ...
        size(statisticalTestResults.pValues);
	significanceMaps.data = zeros(numTimepoints, numChannels, numPairs);
	
	% Specifications for record
	significanceMaps.dataSpecs = statisticalTestResults.dataSpecs;
	significanceMaps.annotationSpecs = statisticalTestResults.annotationSpecs;
	significanceMaps.statisticalTestSpecs = statisticalTestResults.statisticalTestSpecs;
	significanceMaps.fdrSpecs = fdrSpecs;
	
	% FDR correction for each pair of etity classes
	% estimateFDRCorrectedValues returns matrix of
	% significant p-values and nan elsewhere
	for pairIter = 1:numPairs
		significanceMaps.data(:, :, pairIter) = estimateFDRCorrectedValues(...
			statisticalTestResults.pValues(:, :, pairIter), fdrSpecs);
	end
end
