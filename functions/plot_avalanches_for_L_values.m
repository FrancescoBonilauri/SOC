function [dataStruct, sizeFig, durationFig] = plot_avalanches_for_L_values(dataStruct, resetToDefaults)
    arguments
        dataStruct
        resetToDefaults (1,1) = 0;
    end
    
    % Default xline values if not provided in dataStruct
    defaultSizeMin = [5, 5, 8, 16];        % Example default values for sizeMin
    defaultSizeMax = [200, 200, 200, 200]; % Example default values for sizeMax
    defaultDurationMin = [5, 5, 5, 8];     % Example default values for durationMin
    defaultDurationMax = [200, 200, 400, 800]; % Example default values for durationMax
    
    % Get the field names for each L (e.g., 'L_50', 'L_100', etc.)
    L_fields = fieldnames(dataStruct);
    numFields = length(L_fields);
    
    % Create two figures for Size and Duration scatter plots
    sizeFig = figure('Name', 'Size Counts for each L', 'NumberTitle', 'off');
    durationFig = figure('Name', 'Duration Counts for each L', 'NumberTitle', 'off');
    
    % Create tight_subplot axes for size and duration in a 2x2 grid
    [sizeAxes, ~] = tight_subplot(2, 2, [0.05, 0.05], [0.1, 0.1], [0.1, 0.1]);
    [durationAxes, ~] = tight_subplot(2, 2, [0.05, 0.05], [0.1, 0.1], [0.1, 0.1]);
    
    % Loop through each L and plot both SizeCounts and DurationCounts
    for i = 1:numFields
        L_str = L_fields{i};  % Get the field name for current L
        
        % Extract size and duration data from dataStruct
        sizeCounts = dataStruct.(L_str).sizeCounts;
        durationCounts = dataStruct.(L_str).durationCounts;
        sizeBins = dataStruct.(L_str).sizeBins;
        durationBins = dataStruct.(L_str).durationBins;
        L = dataStruct.(L_str).L;
        
        % Check if sizeMin, sizeMax, durationMin, and durationMax are already in the struct
        if isfield(dataStruct.(L_str), 'sizeMin') && ~resetToDefaults
            sizeMin = dataStruct.(L_str).sizeMin;
        else
            sizeMin = defaultSizeMin(i);  % Use default if not present
        end
        
        if isfield(dataStruct.(L_str), 'sizeMax') && ~resetToDefaults
            sizeMax = dataStruct.(L_str).sizeMax;
        else
            sizeMax = defaultSizeMax(i);  % Use default if not present
        end
        
        if isfield(dataStruct.(L_str), 'durationMin') && ~resetToDefaults
            durationMin = dataStruct.(L_str).durationMin;
        else
            durationMin = defaultDurationMin(i);  % Use default if not present
        end
        
        if isfield(dataStruct.(L_str), 'durationMax') && ~resetToDefaults
            durationMax = dataStruct.(L_str).durationMax;
        else
            durationMax = defaultDurationMax(i);  % Use default if not present
        end
        
        % Plot SizeCounts vs SizeBins in the first figure
        axes(sizeAxes(i));  % Switch to the correct subplot axis
        tau = plot_avalanches(sizeBins(1:end-1), sizeCounts, sizeMin, sizeMax, '', '', 'avalanche_size');
        dataStruct.(L_str).tau = tau;
        dataStruct.(L_str).sizeMin = sizeMin;
        dataStruct.(L_str).sizeMax = sizeMax;
        
        % Plot DurationCounts vs DurationBins in the second figure
        axes(durationAxes(i));  % Switch to the correct subplot axis
        alpha = plot_avalanches(durationBins(1:end-1), durationCounts, durationMin, durationMax, '', '', 'avalanche_duration');
        dataStruct.(L_str).alpha = alpha;
        dataStruct.(L_str).durationMin = durationMin;
        dataStruct.(L_str).durationMax = durationMax;
        
        % Remove x-axis labels for all subplots except the bottom row
        if i <= 2  % Top row
            set(sizeAxes(i), 'XTickLabel', []);
            set(durationAxes(i), 'XTickLabel', []);
        end
        
        % Remove y-axis labels for all subplots except the left column
        if mod(i, 2) == 0  % Right column
            set(sizeAxes(i), 'YTickLabel', []);
            set(durationAxes(i), 'YTickLabel', []);
        end
    end
    
    % Add common x-label to the bottom row subplots
    xlabel(sizeAxes(3), 'Avalanche Size', 'Interpreter', 'latex');
    xlabel(sizeAxes(4), 'Avalanche Size', 'Interpreter', 'latex');
    xlabel(durationAxes(3), 'Avalanche Duration', 'Interpreter', 'latex');
    xlabel(durationAxes(4), 'Avalanche Duration', 'Interpreter', 'latex');
    
    % Add common y-label to the left column subplots
    ylabel(sizeAxes(1), 'Count', 'Interpreter', 'latex');
    ylabel(sizeAxes(3), 'Count', 'Interpreter', 'latex');
    ylabel(durationAxes(1), 'Count', 'Interpreter', 'latex');
    ylabel(durationAxes(3), 'Count', 'Interpreter', 'latex');
    
    % Link the y-axes for all subplots in each figure
    linkaxes(sizeAxes, 'y');
    linkaxes(durationAxes, 'y');
end
