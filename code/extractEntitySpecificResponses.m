%% Extract entity-specific responses provided stimulus-specific response

function entitySpecificResponses = extractEntitySpecificResponses(...
	stimulusSpecificResponse, idTaggedTimeMarkers)
	
	% dataSpecs contains details of dataset with fields:
    	% stimulusSpecificRespose (respose to stimulus, for electrodes recorded),
        % dataCollectionFrequency (frequency at which, data was collected),
        % extractionInterval (interval to be extracted (in seconds), 
            %relative to start of the entity).
        %intervalsToExclude (temporal windows, in seconds, relative to start
            % of stimulus, to be discarded from analysis due to motion artifacts),
            % provided as [numberOfWindows x 2] array
	% idTaggedTime markers has fields:
        % data (time markers for entities, format: start time, class ID, end time),
        % entityClassMap (mapping of entities to class, as cell array),
        % classIDMap (mapping of classes to unique numeric ID, as cell array)
	
	dataSpecs = stimulusSpecificResponse.dataSpecs;
	
	% intervals to discard based on manual inspection
	if ~isfield(dataSpecs, 'intervalsToDiscard')
		dataSpecs.intervalsToDiscard = [];
	end
	
	% thereshold to automatically reject segmants based on normalized amplitude
	if ~isfield(dataSpecs, 'maxCutoff')
		dataSpecs.maxCutoff = [];
	end
    
	% Indexing time markers and adjusting for 0
	indexedTimeMarkers = idTaggedTimeMarkers;
	indexedTimeMarkers.data(:, 1) = indexTimeMarkers( ...
		idTaggedTimeMarkers.data(:, 1), dataSpecs.dataCollectionFrequency) + 1;
	indexedTimeMarkers.data(:, 3) = indexTimeMarkers(...
		idTaggedTimeMarkers.data(:, 3), dataSpecs.dataCollectionFrequency) + 1;
	indexedExtractionInterval = indexTimeMarkers(dataSpecs.extractionInterval, ...
		dataSpecs.dataCollectionFrequency);
    responseLength = indexedExtractionInterval(2) ...
        - indexedExtractionInterval(1) + 1;
	
    % Number of records
    [numSamples, numChannels] = size(stimulusSpecificResponse.data);
	
	% Initialize structure to return
	entitySpecificResponses = struct('data', [], 'entityID', []);

    % Removing any overflowing entity markers
	startIndices = indexedTimeMarkers.data(:, 1) + indexedExtractionInterval(1);
    endIndices = indexedTimeMarkers.data(:, 1) + indexedExtractionInterval(2);
	spillOvers = ((startIndices<1) | (endIndices>numSamples));
	if sum(spillOvers)
		startIndices = startIndices(~spillOvers);
		endIndices = endIndices(~spillOvers);
		indexedTimeMarkers.data = indexedTimeMarkers.data(~spillOvers, :);
	end
	
	% Looping over each unclean interval to discard 
	if ~isempty(dataSpecs.intervalsToDiscard)
		indexedItervalsToDiscard = indexTimeMarkers(...
			dataSpecs.intervalsToDiscard, ...
			dataSpecs.dataCollectionFrequency) + 1;
		numIntervals = size(indexedItervalsToDiscard, 1);
		for intervalIter = 1:numIntervals
			intervalStart = indexedItervalsToDiscard(intervalIter, 1);
			intervalEnd = indexedItervalsToDiscard(intervalIter, 2);
			indicesToExclude = ( ...
                startIndices>=intervalStart & startIndices<=intervalEnd) | ...
				(endIndices>=intervalStart & endIndices<=intervalEnd);
			startIndices = startIndices(~indicesToExclude);
			endIndices = endIndices(~indicesToExclude);
			indexedTimeMarkers.data = ...
                indexedTimeMarkers.data(~indicesToExclude, :);
		end
	end
	
	numEntities = size(indexedTimeMarkers.data, 1);
	
	% Initializing the arrays
    entitySpecificResponses.data = ...
        zeros(responseLength, numChannels, numEntities);
	% Populate entity ID array
	entitySpecificResponses.entityID = indexedTimeMarkers.data(:, 2);
	% Data specs for record
	entitySpecificResponses.dataSpecs = dataSpecs;
	% Annotation specs for record
	entitySpecificResponses.annotationSpecs = ...
        idTaggedTimeMarkers.annotationSpecs;
	% Indexed extraction interval
	entitySpecificResponses.indexedExtractionInterval = ...
        indexedExtractionInterval;

	% Populate return structure
	for entityIter = 1:numEntities
        startIndex = startIndices(entityIter);
        endIndex = endIndices(entityIter);
		entitySpecificResponses.data(:, :, entityIter) = ...
            stimulusSpecificResponse.data(startIndex:endIndex, :);
	end

	% Removal of segments with amplitude more than threshold on account of artefacts
	if ~isempty(dataSpecs.maxCutoff)
		indicesToExclude = ...
            sum(abs(entitySpecificResponses.data) > dataSpecs.maxCutoff, [1 2]);
		indicesToExclude = indicesToExclude(:) > 0;
		entitySpecificResponses.data = ...
            entitySpecificResponses.data(:, :, ~indicesToExclude);
		entitySpecificResponses.entityID = ...
            entitySpecificResponses.entityID(~indicesToExclude);
	end
	
	% Reference the individual resposes to have mean 0 activity before
	% entity start in case of extraction window includes pre-start timepoints
% 	if indexedExtractionInterval(1) < 0
% 		zerothIndex = find(indexedExtractionInterval(1):indexedExtractionInterval(2) == 0);
% 		entitySpecificResponses.data = entitySpecificResponses.data ...
% 			- mean(entitySpecificResponses.data(1:zerothIndex, :, :), 1);
% 	end

	% Free memory
	clear idTaggedTimeMarkers indexedTimeMarkers dataset
	clear indexedItervalsToDiscard startIndices endIndices
end
