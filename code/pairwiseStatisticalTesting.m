%% Pairwise statistical testing for all data, theoretically or empirically based on testing specs

function [results, empiricalStatisticValues] = pairwiseStatisticalTesting(...
	entitySpecificResponses, statisticalTestSpecs)

	% Case for all idsCompare
	if strcmpi(statisticalTestSpecs.idPairsToCompare, 'all')
		idList = unique(entitySpecificResponses.entityID);
		numID = length(idList);
		statisticalTestSpecs.idPairsToCompare = nan(0.5*numID*(numID-1), 2);
		idsIter = 1;
		for id1 = 1:numID
			for id2 = id1+1:numID
				statisticalTestSpecs.idPairsToCompare(idsIter, :) = ...
                    [idList(id1) idList(id2)];
				idsIter = idsIter + 1;
			end
		end
	end
	
	% Error if no pair provided
	if isempty(statisticalTestSpecs.idPairsToCompare)
		error('Phoneme ID pairs to compare not provided');
	end
	
	% Indexing statistical analysis interval
	indexedAnalysisInterval = indexTimeMarkers(...
        statisticalTestSpecs.analysisInterval, ...
		entitySpecificResponses.dataSpecs.dataCollectionFrequency);
	indexedExtractionInterval = indexTimeMarkers( ...
		entitySpecificResponses.dataSpecs.extractionInterval, ...
		entitySpecificResponses.dataSpecs.dataCollectionFrequency);
	indexedExtractionTimepoints = ...
        indexedExtractionInterval(1):indexedExtractionInterval(2);
	startIndex = find(indexedExtractionTimepoints == indexedAnalysisInterval(1));
	endIndex = find(indexedExtractionTimepoints == indexedAnalysisInterval(2));
	
	if (isempty(startIndex) || isempty(endIndex))
		error('Statistical test interval should be a subset of data analysis interval!');
	end
	
	statisticalTestSpecs.indexedAnalysisInterval = indexedAnalysisInterval;
	entitySpecificResponses.data = ...
        entitySpecificResponses.data(startIndex:endIndex, :, :);
	
	% Estimate for data
	results = pairwiseStatisticalTestingRoutine(entitySpecificResponses, ...
		statisticalTestSpecs);
	
	% Initialization
	empiricalStatisticValues = [];
	
	% Shuffles for empirical p-value estimation
	if statisticalTestSpecs.empiricalEstimateFlag
		numComparisons = size(statisticalTestSpecs.idPairsToCompare, 1);
		[numTimepoints, numChannels, numEntities] = size(entitySpecificResponses.data);
		empiricalStatisticValues = nan(numTimepoints, numChannels, ...
			statisticalTestSpecs.numShuffles, numComparisons);
		numBlocks = statisticalTestSpecs.numBlocks;
		if isfield(statisticalTestSpecs, 'seeds')
			seeds = statisticalTestSpecs.seeds;
		else
			seeds = [];
		end
		
		% Parallel estimation of statistic values for shuffles
		parfor shuffleIter = 1:statisticalTestSpecs.numShuffles
			shuffledResponses = entitySpecificResponses;
			% Assumption that the distribution of phonemes stays the same
			% across the dataset and 1/numBlocks of the data-set is a big enough
			% sample containing the same distribution
			if isempty(seeds)
				shuffledIndices = shuffleIndices(numEntities, numBlocks);
			else
				shuffledIndices = shuffleIndices(numEntities, numBlocks, ...
                    seeds(shuffleIter));
			end
			shuffledResponses.entityID = ...
					shuffledResponses.entityID(shuffledIndices);
			shuffledResults = pairwiseStatisticalTestingRoutine(...
                shuffledResponses, statisticalTestSpecs);
			empiricalStatisticValues(:, :, shuffleIter, :) = ...
				shuffledResults.statisticValues;
		end
		
		% Close parallel pool
		poolObject = gcp('nocreate');
		delete(poolObject);
		clear shuffledResults
		
		% Estimate empirical p-values
		for pairIter = 1:numComparisons
			results.pValues(:, :, pairIter) = estimateEmpiricalPValues(...
				results.statisticValues(:, :, pairIter), ...
				empiricalStatisticValues(:, :, :, pairIter), ...
				statisticalTestSpecs.tailed);
		end
	end
end

%% Common routine for testing for data and shuffles
function [results] = pairwiseStatisticalTestingRoutine(...
	entitySpecificResponses, statisticalTestSpecs)
	
	numComparisons = size(statisticalTestSpecs.idPairsToCompare, 1);
	[numTimepoints, numChannels, ~] = size(entitySpecificResponses.data);
	
	results.pValues = nan(numTimepoints, numChannels, numComparisons);
	results.statisticValues = [];
	
	% data specs, annotation, and test specs for record
	results.dataSpecs = entitySpecificResponses.dataSpecs;
	results.annotationSpecs = entitySpecificResponses.annotationSpecs;
	results.statisticalTestSpecs = statisticalTestSpecs;
	
	if statisticalTestSpecs.empiricalEstimateFlag
		results.statisticValues = ...
            nan(numTimepoints, numChannels, numComparisons);
	end
	
	for pairIter=1:numComparisons
		pairToCompare = statisticalTestSpecs.idPairsToCompare(pairIter, :);
		singlePairResults = singlePairStatisticalTesting(...
			entitySpecificResponses.data(:, :, ...
                entitySpecificResponses.entityID == pairToCompare(1)), ...
			entitySpecificResponses.data(:, :, ...
                entitySpecificResponses.entityID == pairToCompare(2)), ...
			statisticalTestSpecs);
		if statisticalTestSpecs.empiricalEstimateFlag
			% Case of statistics evaluation
			results.statisticValues(:, :, pairIter) = ...
                singlePairResults.statisticValues;
		else
			% Case of p-values estimation
			results.pValues(:, :, pairIter) = singlePairResults.pValues;
		end
		% Free memory
		clear singlePairResults
	end
	% Free memory
	clear entitySpecificResponses statisticalTestSetup
end
