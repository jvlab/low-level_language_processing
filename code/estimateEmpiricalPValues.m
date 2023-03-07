%% Estimate p values from empirical statistic values

function pValues = estimateEmpiricalPValues( ...
    dataStatisticValues, empiricalStatisticValues, tailed) 
    
	% Default tail setting 
	if nargin < 3
		tailed = 'both';
	end
	
	% Reshaping for comparison
	dataStatisticValues = dataStatisticValues(:, :);
	empiricalStatisticValues = empiricalStatisticValues(:, :, :);
	[numTimepoints, numChannels, ~] = size(empiricalStatisticValues);
	
	pValues = zeros(numTimepoints, numChannels);

	% Estimating p-value esmmpirically given data and shuffled data
	% statistic values
	for channelIter = 1:numChannels
		for timeIter = 1:numTimepoints
			pValues(timeIter, channelIter) = ...
				estimatePValue(dataStatisticValues(timeIter, channelIter), ...
				empiricalStatisticValues(timeIter, channelIter, :), tailed);
		end
	end
    clear dataStatisticValues empiricalStatisticValues
end
