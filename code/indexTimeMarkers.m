%% Convert the time markers to indices, t=0 at index 1

function indexedTimeMarkers = indexTimeMarkers(...
    timeMarkers, dataCollectionFrequency)
	 
    indexedTimeMarkers = round(timeMarkers * dataCollectionFrequency);
end
