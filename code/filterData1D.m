%% Filter data with bandpass defined by bandpassWindow along the columns,
%% also removes 60 Hz noise

function [filteredData] = filterData1D(data, ...
    dataCollectionFrequency, bandpassWindow)
	
	% data: data to filter
	% dataCollectionFrequency: frequency of EEG recording
	% bandpassWindow: window of frequency of resposes to retain

	% Notch filter of order 2, centerd at 60 Hz, quality factor 10
	notchFilterSpecs = fdesign.notch(2, 60, 10, dataCollectionFrequency);
	notchFilter = design(notchFilterSpecs, 'SystemObject', true);
    filteredData = notchFilter(data);

	% Bandpass filter with window defined by bandpassWindow
    %one channel at a time since bandpass behavior seems to depend on version
    %if data are 2D
    for ichan=1:size(filteredData,2)
        filteredData(:,ichan) = (bandpass(filteredData(:,ichan)', ...
            bandpassWindow, dataCollectionFrequency))';
    end	
	clear data;
end