%% Extract mean corrected stimulus specfic response from the file read

function stimulusSpecificResponse = extractStimulusSpecificResponse(recordingData)
	% dataSpecs has fields:
	% recordingData (structure containing data and trigger fields,
	% corresponding to collected data and array of event markers respectively),
	% triggerString (string used to mark event by recording software)
    	
    % Find indices for event markers
    triggerIndices = find(strcmp(recordingData.trigger, ...
		recordingData.dataSpecs.triggerString));
	
	% Error if file is missing start marker, stop marker, or has additional markers
	if length(triggerIndices) ~= 2
		error(cat(2, 'File should have only 2 markers, correspondig ', ...
			'to start and end of the stimulus. The current file has ', ...
			num2str(length(triggerIndices)), '.'));
	end
	
    startIndex = triggerIndices(1);
    endIndex = triggerIndices(2);

    % Extract the response corresponding to event of interest
    stimulusSpecificResponse.data = recordingData.data(startIndex:endIndex, :);
	stimulusSpecificResponse.dataSpecs = recordingData.dataSpecs;
	
    % Normalize the response to have zero mean and 1 variance
    stimulusSpecificResponse.data = normalize(stimulusSpecificResponse.data);

    %Free memory
    clear recordingData;
end
