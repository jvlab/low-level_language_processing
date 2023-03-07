function [nseResponse, shuffledNSEResponse] = estimateNSE(...
    stimulusSpecificResponse, stimulus, nseSpecs)
	
	blockSizeInIndices = indexTimeMarkers(nseSpecs.blockSize, ...
        stimulusSpecificResponse.dataSpecs.dataCollectionFrequency);

	[timePoints, channels] = size(stimulusSpecificResponse.data);
	stimulusDuration = ...
        min(timePoints, length(stimulus.data) ...
        )/stimulusSpecificResponse.dataSpecs.dataCollectionFrequency;
	
	intervalsToDiscard = ...
        stimulusSpecificResponse.dataSpecs.intervalsToDiscard;
	if isempty(intervalsToDiscard)
		cleanBlockIndices = ...
            extractCleanBlocksIndices(timePoints, blockSizeInIndices);
	else
		transposedIntervals = intervalsToDiscard';
		cleanIntervals = reshape(transposedIntervals(2:end-1), 2, [])';
		if intervalsToDiscard(1, 1) > 0
			cleanIntervals = ...
                cat(1, [0 intervalsToDiscard(1, 1)], cleanIntervals);
		end
		if intervalsToDiscard(end, 2) < stimulusDuration
			cleanIntervals = cat(1, cleanIntervals, ...
                [intervalsToDiscard(end, 2), stimulusDuration]);
		end
		cleanBlockIndices = [];
		cleanIntervalsCount = size(cleanIntervals, 1);
		
		for intervalIter = 1:cleanIntervalsCount
			indices = indexTimeMarkers(cleanIntervals(intervalIter, :), ...
				stimulusSpecificResponse.dataSpecs.dataCollectionFrequency) ...
                + 1;
			intervalLength = diff(indices) + 1;
			cleanBlockIndices = cat(1, ...
				extractCleanBlocksIndices(intervalLength, ...
                blockSizeInIndices) + indices(1), cleanBlockIndices);
		end
	end
	
	nseSpecs.blockIndices = cleanBlockIndices;
    nseSpecs.maxLag = abs(nseSpecs.maxLag);
	stimulusSpecificResponse.dataSpecs.analysisInterval = ...
        [-nseSpecs.maxLag nseSpecs.maxLag];
	maxLagInIndices = indexTimeMarkers(nseSpecs.maxLag, ...
        stimulusSpecificResponse.dataSpecs.dataCollectionFrequency);
	nseSpecs.maxLagInIndices = maxLagInIndices;
    
	%% NSE Estimation

	% For record keeping
	nseResponse.dataSpecs = stimulusSpecificResponse.dataSpecs;
	nseResponse.stimulusSpecs = stimulus.stimulusSpecs;
	nseResponse.nseSpecs = nseSpecs;
	
	% xcorr shifts the first argument meaning the stimulus causes reponse is
	% in the second half of the resulting array
	nseResponse.data = estimateNSERoutine(...
        stimulusSpecificResponse, ...
		stimulus, nseSpecs, []);
	
	%% Shuffling
	shuffledNSEResponse.dataSpecs = stimulusSpecificResponse.dataSpecs;
	shuffledNSEResponse.nseSpecs = nseSpecs;

    shuffledNSE = nan(2*maxLagInIndices+1, channels, nseSpecs.numShuffles);
    
    poolobj = parpool();
	parfor shuffleIter = 1:nseSpecs.numShuffles
        shuffledNSE(:, :, shuffleIter) = estimateNSERoutine(...
            stimulusSpecificResponse, ...
            stimulus, nseSpecs, shuffleIter);
	end
	delete(poolobj);
    
	shuffledNSEResponse.data = shuffledNSE;
    
    % estimate p-values
    nseResponse.pValues = estimateEmpiricalPValues( ...
        nseResponse.data, shuffledNSEResponse.data);
    
	clear shuffledNSE;
end

function nseResponse = estimateNSERoutine( ...
    stimulusSpecificResponse, stimulus, nseSpecs, shuffleSeed)

	channels = size(stimulusSpecificResponse.data, 2);
	cleanBlockCount = size(nseSpecs.blockIndices, 1);
	xcorrLength = 2*nseSpecs.maxLagInIndices + 1;
    
	nseResponse = nan(xcorrLength, channels, cleanBlockCount);
    
    shuffledBlockIndices = nseSpecs.blockIndices;
    if ~isempty(shuffleSeed)
        shuffledBlockIndices = nseSpecs.blockIndices(...
                shuffleIndices(cleanBlockCount, ...
                nseSpecs.numBlocks, shuffleSeed), :);
    end

	%	xcorr(a, b) = a is caused by b
	for c = 1:channels
		for b = 1:cleanBlockCount
           nseResponse(:, c, b) = xcorr( ...
                stimulusSpecificResponse.data( ...
                nseSpecs.blockIndices(b, 1):nseSpecs.blockIndices(b, 2), c), ...
			    stimulus.data( ...
                shuffledBlockIndices(b, 1):shuffledBlockIndices(b, 2), 1), ...
				nseSpecs.maxLagInIndices, 'coeff');
		end
	end
	
	nseResponse = mean(nseResponse, 3);
	
	clear stimulusSpecificResponse stimulusData
	clear shuffledBlockIndices shuffledPhonemes
end

