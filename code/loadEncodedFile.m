%% Load encoded files saved with UTF16BE encoding
%% containing mappings of entity to class and class to class ID

function [dataFieldsText] = loadEncodedFile(fileName, delimChar)
	
	% Open file
	[fid, message] = fopen(fileName, 'r');
	% Error if file fails to open
	if fid < 0
      error(cat(2, 'Failed to open file ', fileName, ...
          ' because: ', message));
	end
	
	% Load first byte to check format is UTF16BE
    firstBytes = fread(fid, [1,4], '*uint8');
	if length(firstBytes) < 2 && any(firstBytes(1:2) ~= [254, 255])
		error(cat(2, 'Incorrect encoding of file "%s"\n', ...
            fileName, '. Save as UTF16BE.'));
	end

	% Function to convert bytes to Char
    bytes2char = @(B) char(swapbytes(typecast(uint8(B), 'uint16')));

	% Load file
    fileId = fopen(fileName, 'rt');
    headerLine = fgets(fileId);

    % Ignores the end of line characters
    dataCell = textscan(headerLine, '%s', 'delimiter', delimChar);
    
	% Find header fields and their number 
    headerFields = reshape(dataCell{1}, 1, []);
    numFields = length(headerFields);

    dataLine = fread(fileId, [1 inf], '*uint8');

	% Convert to char and populate data structures
    dataLine = bytes2char(dataLine);
    textFormat = repmat('%s', 1, numFields);
    dataCell = textscan(dataLine, textFormat, 'delimiter', delimChar);
	
	% Convert from cell array to array of cells
    dataFieldsText = horzcat(dataCell{:});
	
	% Free memory
	clear dataCell headerLine headerFields dataLine dataCell
	
	% Close file
	fclose(fid);
end
