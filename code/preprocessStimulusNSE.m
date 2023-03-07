%% Preprocess simulus for NSE analysis

function stimulus = preprocessStimulusNSE(stimulusSpecs)
	
	% read audio file
	[originalData, stimulusSpecs.originalFrequency] = ...
        audioread(stimulusSpecs.fileName);
	
	% estimate Hilber transform
	hilbertTransformStimulus = hilbert(originalData);
	
	% magnitude of of Hilbert transform
	hilbertMagnitudeStimulus = abs(hilbertTransformStimulus);
	
	% filter magnitude of transform
	filteredStimulus = filterData(hilbertMagnitudeStimulus, ...
		stimulusSpecs.originalFrequency, stimulusSpecs.frequencyBand);
	
	% resample stimulus
	resampledStimulus = resample(filteredStimulus, ...
		stimulusSpecs.frequency, stimulusSpecs.originalFrequency);
	
	% populate stimulus
	stimulus.data = mean(resampledStimulus, 2);
	
    % add specifications for recordkeeping 
    stimulus.stimulusSpecs = stimulusSpecs;
end
