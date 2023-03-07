%% Wilcoxon ranksum Test / Mann-Whitney test

function [hValue, pValue] = estimateRanksum(x, y, tailed)
    % Estimate values
	x = x(:);
	y = y(:);
	N = length(x) + length(y);
	total = 0.5*N*(N+1);
    [pValue, ~, hValue] = ranksum(x, y, 'tail', tailed);
    % Correct for Nan p-value
    if isnan(pValue)
        pValue = 1;
    end
    hValue = hValue.ranksum;
	hValue = min(hValue, total-hValue);
end