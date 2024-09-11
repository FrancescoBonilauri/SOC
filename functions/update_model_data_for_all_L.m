function dataStruct = update_model_data_for_all_L(model, folderPath)
% Set the default folder path if it is not provided
if nargin < 2
	folderPath = "data/";  % Use the current working directory as the default
end

% Input validation
if nargin < 1
	error('Usage: load_largest_file_for_all_L(model, [folderPath])');
end

% Get list of .mat files in the folder
files = dir(fullfile(folderPath, '*.mat'));

% Initialize a container for storing the largest file for each L
largestFiles = containers.Map('KeyType', 'double', 'ValueType', 'char');
fileSizes = containers.Map('KeyType', 'double', 'ValueType', 'double');

% Loop through each file
for i = 1:length(files)
	fileName = files(i).name;

	% Parse the filename using regular expression
	tokens = regexp(fileName, sprintf('^%s_data_(\\d+)_([^_]+)_(\\d+)-(\\d+)\\.mat$', model), 'tokens');

	% Check if the filename matches the expected format with L
	if ~isempty(tokens)
		tokens = tokens{1};
		fileL = str2double(tokens{1});  % Extract L value
		fileSize = files(i).bytes;      % Get file size

		% Update the largest file for this L if necessary
		if ~isKey(largestFiles, fileL) || fileSize > fileSizes(fileL)
			largestFiles(fileL) = fullfile(folderPath, fileName);
			fileSizes(fileL) = fileSize;
		end
	end
end


% Initialize structure to store data for each available L
dataStruct = struct();

% Load the largest files for each available L and store the relevant variables
L_values = keys(largestFiles);  % Available L values found in the files
for i = 1:length(L_values)
	L = L_values{i};
	largestFileName = largestFiles(L);
	fileData = load(largestFileName);  % Load the file data

	% Check if the required fields exist in the file
	if isfield(fileData, 'avalanche_sizes') && isfield(fileData, 'avalanche_duration') && ...
			isfield(fileData, 'steps') && isfield(fileData, 'wait')
		% Store the variables for this L in a sub-structure
		dataStruct.(sprintf('L_%d', L)).avalanche_sizes = fileData.avalanche_sizes;
		dataStruct.(sprintf('L_%d', L)).avalanche_duration = fileData.avalanche_duration;
		dataStruct.(sprintf('L_%d', L)).steps = fileData.steps;
		dataStruct.(sprintf('L_%d', L)).wait = fileData.wait;
		dataStruct.(sprintf('L_%d', L)).L = fileData.L;


		fprintf('Loaded data for L = %d: %s\n', L, largestFileName);
	else
		warning('File for L = %d does not contain the required variables.', L);
	end
end
end