function [fig] = scatter_plot(x, y, titleText, xlabelText, ylabelText)
    % Inputs:
    % x - x-axis data
    % y - y-axis data
    % titleText - title of the graph
	% xlabelText
	% ylabelText

    % Create a figure and scatter plot in log-log scale
    fig = figure;
    scatter(x, y, '.', 'LineWidth', 1.5);  % scatter plot, circle markers
    hold on;
    
    % Customize the plot appearance
    grid off;                              % Disable grid
    set(gca, 'FontSize', 14);              % Set font size for the axis labels
    set(gca, 'LineWidth', 1.5);            % Thicker axis lines
    set(gca, 'TickLabelInterpreter', 'latex');  % Use LaTeX interpreter for tick labels
    
    % Title and labels with LaTeX interpreter
    title(titleText, 'Interpreter', 'latex', 'FontSize', 16);
    xlabel(xlabelText, 'Interpreter', 'latex', 'FontSize', 14);
    ylabel(ylabelText, 'Interpreter', 'latex', 'FontSize', 14);
    
    % Set the axis limits automatically
    axis tight;
    hold off;
end
