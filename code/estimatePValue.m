%% Estimate empirical p-value for a single data point
function [pValue] = estimatePValue(dataStatistic, empiricalStatistics, tailed)

	% Default tail setting 
	if nargin < 3
		tailed = 'both';
	end

	% Count for right and left tails
	pValueRight = sum(empiricalStatistics < dataStatistic, 'all');
	pValueLeft = sum(empiricalStatistics > dataStatistic, 'all');
	pEqual = sum(empiricalStatistics == dataStatistic, 'all');
	numShuffles = length(empiricalStatistics);
	
	% p-value estimation based on tail
	if strcmp(tailed, 'right')
		pValue = (1/numShuffles)*(pValueRight + pEqual);
	elseif strcmpi(tailed, 'left')
		pValue = (1/numShuffles)*(pValueLeft + pEqual);
	else
		pValue = (1/numShuffles)*(2*min(pValueRight, pValueLeft) + pEqual);
	end
	
	% Edge case p-value set to half of step size
	if pValue == 0
		pValue = 0.5/numShuffles;
	end
end
