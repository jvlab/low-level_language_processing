%% Statistical test specifications

% initialize structure
statisticalTestSpecs = struct;

%% default parameters

% pairwise statistical test function 
statisticalTestSpecs.statisticalTestFunction = @estimateRanksum;

% tailed ('left', 'right', 'both')
statisticalTestSpecs.tailed = 'both';

% analysis interval, in seconds
statisticalTestSpecs.analysisInterval = [0 0.5];

% paired values of class IDs or 'all' for all 
statisticalTestSpecs.idPairsToCompare = 'all';

% flag for theoretical (false) or empirical (true) p-value estimation
statisticalTestSpecs.empiricalEstimateFlag = false;

%% parameters for shuffling for empirical p-value estimation
% used when empiricalEstimateFlag is true

% number of shuffles for empirical p-value estimation
statisticalTestSpecs.numShuffles = 1000;

% number of blocks to divide data in for empirical p-value estimation
% breaking into blocks keeps short range correlations
statisticalTestSpecs.numBlocks = 10;

% seeds for randomizing shuffles for empirical p-value estimation
statisticalTestSpecs.seeds = 1:1000;
