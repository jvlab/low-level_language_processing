%% Find start and end of contiguous, non overlapping blocks of given length
%% for a length of clean segment, given as number of time points

function cleanBlockIndices = extractCleanBlocksIndices( ...
    timePointCount, blockLengthInIndices)

	countCleanBlocks = floor(timePointCount/blockLengthInIndices);
	cleanBlockIndices = zeros(countCleanBlocks, 2);
	lastEndIdx = 0;
	for blockIter = 1:countCleanBlocks
		cleanBlockIndices(blockIter, :) = lastEndIdx + [1 blockLengthInIndices];
		lastEndIdx = lastEndIdx + blockLengthInIndices;
	end
end