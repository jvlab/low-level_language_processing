%% Shuffling labels

function shuffledIndices = shuffleIndices(numEntities, numBlocks, seed)
	
	% Number of blocks
	blockSize = ceil(numEntities/numBlocks);
	shuffledIndices = 1:numEntities;
	
	% Setting seeds
	if nargin < 3
        seed = 'shuffle';
    end
	stream = RandStream('mt19937ar', 'Seed', seed);
	
    % Shuffling indices within each block
	% to preserve long distance correlations
	for blockIter = 0:blockSize:((blockSize*numBlocks)-1)
		startIndex = blockIter + 1;
		endIndex = min(blockIter + blockSize, numEntities);
		sz = endIndex - startIndex + 1;
		shuffledIndex = blockIter + randperm(stream, sz);
		shuffledIndices(startIndex:endIndex) = ...
			shuffledIndices(shuffledIndex);
	end
end
