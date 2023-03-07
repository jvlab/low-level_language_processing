%% Find spatio-temporal map marking statistically significant differences
%% returned as a matrix of 1 at places of significance and
%% 0 vlaues everywhere else 
	
function [significanceMap, cutoffValues] = estimateFDRCorrectedValues(pValues, fdrSpecs)
	
	[numTimepoints, numChannels] = size(pValues);
	
	% Cases based on the strategy - space, time, all
	if strcmpi(fdrSpecs.strategy, 'time')
		% Across time i.e. for each channel
		cutoffValues = zeros(1, numChannels);
		for channelIter = 1:numChannels
			cutoffValues(channelIter) = estimateFDRCutoff(...
				pValues(:, channelIter), fdrSpecs.rate);
		end
	elseif strcmpi(fdrSpecs.strategy, 'space')
		% Across space i.e. for each time point
		cutoffValues = zeros(numTimepoints, 1);
		for timepointIter = 1:numTimepoints
			cutoffValues(timepointIter) = estimateFDRCutoff(...
				pValues(timepointIter, :), fdrSpecs.rate);
		end
	else
		% Across time and space (channels)
		cutoffValues = estimateFDRCutoff(pValues(:), fdrSpecs.rate);
	end
	
	% FDR correction, setting significant p-values to 1, others 0
	significanceMap = (pValues<=cutoffValues);
	
end
