function dataStruct = bin_for_all_L(model,N_bins,folderPath,beta,B_0)

% Set the default folder path if it is not provided
if nargin < 3
	folderPath = "data/";  % Use the current working directory as the default
end

if nargin < 2
	N_bins = 1000;
end

% Input validation
if nargin < 1
	error('Usage: load_largest_file_for_all_L(model, [folderPath])');
end


dataStruct = update_model_data_for_all_L(model,folderPath);


L_fields = fieldnames(dataStruct);  % Get all available L fields

% Make sure N_bins is the right size
if size(N_bins) ~= [2 length(L_fields)]
	if isscalar(N_bins)
		N_bins = ones(2,length(L_fields))*N_bins;
	else
		error ("N_bins has to be either a scalar or a 2x length(L_fields) matrix. The first row is" + ...
			"for avalanche size bins, the second for duration.")
	end
end


for i = 1:length(L_fields)
	L_str = L_fields{i};  % Field name like 'L_50', 'L_100', etc.
	L_N_bins = N_bins(:,i);
	% Do something with the data for this L
	[dataStruct.(L_str).sizeCounts, dataStruct.(L_str).sizeBins] = ...
		count_occurrences_in_intervals(dataStruct.(L_str).avalanche_sizes, L_N_bins(1),beta,B_0);
	[dataStruct.(L_str).durationCounts, dataStruct.(L_str).durationBins] = ...
		count_occurrences_in_intervals(dataStruct.(L_str).avalanche_duration, L_N_bins(2),beta,B_0);

end

fileName = "data/"+model+"_data.mat";
save(fileName,"dataStruct");

fprintf('Saved binned data for all L in %s\n', fileName);





	function [counts, bins] = count_occurrences_in_intervals(data, N,beta,B_0)
		% data: The dataset containing the occurrences
		% N: Number of intervals

		if nargin < 3
			% Find the minimum and maximum value of the data
			B_0 = min(data);  % First bin boundary
			B_max = max(data);  % Maximum value in the data

			% Compute the growth factor beta
			beta = (1 / N) * log(B_max / B_0);
		end

		if nargin < 2
			B_0 = min(data);  % First bin boundary
		end


		% Precompute the interval boundaries (bins) based on b_n = B_0 * exp(beta * n)
		bins = B_0 * exp(beta * (0:N));

		% Initialize an array to store the counts for each interval
		counts = zeros(1, N);

		% Loop over the data and count occurrences in each interval
		for i = 1:N
			% For each interval [b_i, b_{i+1}], count occurrences in data
			counts(i) = sum(data >= bins(i) & data < bins(i+1));
		end

		% Optionally handle data greater than the last boundary
		counts(N) = counts(N) + sum(data >= bins(N));

	end

end