%% Filter data with bandpass defined by bandpassWindow along the columns,
%% also removes 60 Hz noise

function [filteredData] = filterData(data, ...
    dataCollectionFrequency, bandpassWindow)
	
	% data: data to filter
	% dataCollectionFrequency: frequency of EEG recording
	% bandpassWindow: window of frequency of resposes to retain

	% Notch filter of order 2, centerd at 60 Hz, quality factor 10
	notchFilterSpecs = fdesign.notch(2, 60, 10, dataCollectionFrequency);
	notchFilter = design(notchFilterSpecs, 'SystemObject', true);
    filteredData = notchFilter(data);

	% Bandpass filter with window defined by bandpassWindow
    disp("Filtering signal now ...");
    filteredData = bandpass(filteredData, ...
        bandpassWindow, dataCollectionFrequency);

%     channelCount = size(filteredData, 2);
%     disp(strcat("Filtering ", num2str(channelCount), " Channels ..."));
%     for channelIter = 1:channelCount
%         disp(strcat("Now filtering channel ", num2str(channelIter), " ..."));
%         filteredData(:, channelIter) = bandpass(filteredData(:, channelIter), ...
%             bandpassWindow, dataCollectionFrequency);
%     end

    disp('Finished filtering.');
	
	clear data;
end