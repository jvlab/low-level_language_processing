%% Function to read XLTek file and populate a fields of structure representating date, time, triggers, and data

function recordingData = readXLTekRecordingTextFile(dataSpecs)
	
	% dataSpecs: specification of data, with fields:
	% fileName (name of text file containing extracted XLTek data), 
	% numHeadaboxElectrodes (maximum number of electrodes that can be recorded using the headbox),
	% channelsRecorded (array of index of channels indices recorded, as list of indices or logical array), and
	% numHeaderLines (number of lines to skip before recording data starts in the xltek txt file) 
	
    % Open file
    [fid, message] = fopen(dataSpecs.fileName);
	if fid < 0
      error(cat(2, 'Failed to open file ', dataSpecs.fileName, ' because: ', message));
	end
	
	% Create text format to read
	if (~isfield(dataSpecs, 'textFormat')) || isempty(dataSpecs.textFormat)
		dataSpecs.textFormat = cat(2, '%s %s %d64 ', ...
			repmat('%f64 ', 1, dataSpecs.numHeadboxElectrodes), ' %s');
	end
	
    % Scan the entire file using the defined regex excluding the header lines
    % which are full of demarcating character "%%"
    text = textscan(fid, dataSpecs.textFormat, ...
        'HeaderLines', dataSpecs.numHeaderLines);
	
	% Number of lines
    numLines = size(text{1}, 1);
    
	% Initialize cell arrays for required data entries
    dates = cell(1, numLines);
    times = cell(1, numLines);
    eventBytes = nan(1, numLines);
    data = nan(numLines, dataSpecs.numHeadboxElectrodes);
	triggers = cell(1, numLines);
    
	% Loop for each line, popuating the cell arrays of information
	for lineIter = 1:numLines
        dates(lineIter) = text{1}(lineIter);
        times(lineIter) = text{2}(lineIter);
        eventBytes(lineIter) = text{3}(lineIter);
		for channelIter = 1:dataSpecs.numHeadboxElectrodes
            data(lineIter, channelIter) = text{3+channelIter}(lineIter);
		end
        triggers(lineIter) = text{end}(lineIter);
	end
	
	% Check for errors resulting from corrupted recording or data exporting
    gaps = diff(eventBytes);
	if sum(gaps ~= 1)
        error('Error in file! Gap(s) in record.');
	end

	% Extract the response for channels recorded
	data = data(:, dataSpecs.channelsRecorded);
	
	% Populate respective fields of structure 
	recordingData.date = dates;
	recordingData.time = times;
	recordingData.eventByte = eventBytes;
	recordingData.data = data;
	recordingData.trigger = triggers;
	recordingData.dataSpecs = dataSpecs;
	
    % Free memory
    clear dates times eventBytes data triggers dataSpecs

    % Close file
    fclose(fid);
end
