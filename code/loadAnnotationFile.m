%% Load annotation file into a matlab array provided mappings to convert entity to entity class ID

function [idTaggedTimeMarkers, classifiedTimeMarkers] = ...
    loadAnnotationFile(annotationSpecs)
    % start and end time of entities in timeMarkerFilesec
	% entity to class (text) mapping in entityClassMapFile
	% class (text) to class ID (numeric) mapping in entityClassIDMapFile
	% delimiter for the file needs to be classified.
	
    % Load time marker data corresponding to annotation
    % (start_time label end_time)
    classifiedTimeMarkers = loadEncodedFile(annotationSpecs.timeMarkerFile, ...
        annotationSpecs.delimChar);
    
    % convert start and end times to number inside cells
    classifiedTimeMarkers(:, 1) = ...
        num2cell(str2double(classifiedTimeMarkers(:, 1))); 
    classifiedTimeMarkers(:, 3) = ...
        num2cell(str2double(classifiedTimeMarkers(:, 3)));
   
    % Mapping of individual entities to their classes
    % (entity entity_class)
	entityClassMap = loadEncodedFile(annotationSpecs.entityClassMapFile, ...
        annotationSpecs.delimChar);
    numEntities = size(entityClassMap, 1);
	
	% Initialize array to filter entities which have mapping
    entitiesToSelect = false(size(classifiedTimeMarkers, 1), 1);
    for entityIter = 1:numEntities
        indices = strcmp(classifiedTimeMarkers(:, 2), ...
            entityClassMap(entityIter, 1));
		entitiesToSelect = entitiesToSelect + indices;
		classifiedTimeMarkers(indices, 2) = entityClassMap(entityIter, 2);
    end
    
    classifiedTimeMarkers = ...
        classifiedTimeMarkers(logical(entitiesToSelect), :);
	idTaggedTimeMarkers.data = classifiedTimeMarkers;
    
	% Free memory
	clear annotationData entitiesToSelect
	
    % Mapping of entity classes to respective numeric code
    % (entity_class entity_class_id)
    entityClassIDMap = loadEncodedFile(annotationSpecs.entityClassIDMapFile, ...
        annotationSpecs.delimChar);
    numClasses = size(entityClassIDMap, 1);

	% Initialize array to filter entities which have mapping
    classesToSelect = false(size(classifiedTimeMarkers, 1), 1);
	for classIter = 1:numClasses
        indices = strcmp(classifiedTimeMarkers(:, 2), ...
            entityClassIDMap{classIter, 1});
		classesToSelect = classesToSelect + indices;
        idTaggedTimeMarkers.data(indices, 2) = ...
            entityClassIDMap(classIter, 2);
	end
	
	% Include only mapped classes and convert to numeric array
	idTaggedTimeMarkers.data = ...
        idTaggedTimeMarkers.data(logical(classesToSelect), :);
	idTaggedTimeMarkers.data(:, 2) = ...
        num2cell(str2double(idTaggedTimeMarkers.data(:, 2)));
	
	% Convert to matrix
	idTaggedTimeMarkers.data = cell2mat(idTaggedTimeMarkers.data);
	
	% Data details for record keeping
	annotationSpecs.classIDMap = entityClassIDMap;
	annotationSpecs.entityClassMap = entityClassMap;
	idTaggedTimeMarkers.annotationSpecs = annotationSpecs;
	
	% Free memory
	clear entitiesToSelect entityClassMap indices
    clear classesToSelect entityClassIDMap annotationSpecs
end