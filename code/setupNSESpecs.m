%% Default parameters for NSE analysis

nseSpecs = struct;	% Initialization

nseSpecs.blockSize = 2;	% Length of the segment in seconds
nseSpecs.maxLag = 0.5;	% Maximum correlation lag in seconds

% Number of shuffles for p-value estimation
nseSpecs.numShuffles = 10000;

% Number of blocks to break the short temporal structure
nseSpecs.numBlocks = 10;
