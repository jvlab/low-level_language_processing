%% T-test

function [tValue, pValue] = estimateTStatistic(x, y, tailed)
    % Estimate values
    [~, pValue, ~, tValue] = ttest2(x, y, 'Vartype', 'unequal', 'Tail', tailed);
    % Correct for Nan p-value
    if isnan(pValue)
        pValue = 1;
    end
    tValue = tValue.tstat;
end