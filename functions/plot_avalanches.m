function [fig,exponent] = plot_avalanches(x, y, xline1, xline2, titleText, subtitleText)
% Inputs:
% x - x-axis data
% y - y-axis data
% xline1 - position of the first vertical dotted line
% xline2 - position of the second vertical dotted line
% titleText - title of the graph

ylabelText = "Count";
xlabelText = "Avalanche size";

% Create a figure and scatter plot in log-log scale
fig = figure;
loglog(x, y, '.', 'MarkerSize', 6, 'LineWidth', 1.5);  % scatter plot, circle markers
hold on;

% Add the vertical dotted lines at x = xline1 and x = xline2
xline(xline1, '--k', 'LineWidth', 1.5);  % vertical dotted line, black
xline(xline2, '--k', 'LineWidth', 1.5);

% Select the data points between xline1 and xline2 for fitting
idx_fit = (x >= xline1) & (x <= xline2);  % indices where x is between xline1 and xline2
x_fit = x(idx_fit);
y_fit = y(idx_fit);

% Apply log transformation to the selected data for fitting
log_x_fit = log10(x_fit);
log_y_fit = log10(y_fit);

% Perform linear fit (log-log space)
p = polyfit(log_x_fit, log_y_fit, 1);  % p(1) is the slope, p(2) is the intercept

exponent = p(1);

% Generate fitted line in the original log-log scale
log_y_fit_line = polyval(p, log10(x_fit));
y_fit_line = 10.^log_y_fit_line;  % Convert back to original scale

% Plot the fitted line
loglog(x_fit, y_fit_line, 'r--', 'LineWidth', 2);  % red dashed line for fit

% Customize the plot appearance
grid off;                              % Disable grid
set(gca, 'FontSize', 14);              % Set font size for the axis labels
set(gca, 'LineWidth', 1.5);            % Thicker axis lines
set(gca, 'TickLabelInterpreter', 'latex');  % Use LaTeX interpreter for tick labels
set(gca, 'XMinorTick', 'on');

% Title and labels with LaTeX interpreter
title(titleText,'Interpreter', 'latex', 'FontSize', 16);
subtitle(subtitleText, 'Interpreter', 'latex', 'FontSize', 14);
xlabel(xlabelText, 'Interpreter', 'latex', 'FontSize', 14);
ylabel(ylabelText, 'Interpreter', 'latex', 'FontSize', 14);

% Set the axis limits automatically
axis tight;

% Prepare the fit equation for the legend
%fit_eqn = sprintf('Fit: $y = %.2f \\cdot x^{%.2f}$', 10^p(2), p(1));
fit_eqn = sprintf('Fit: $y = c x^{%.2f}$', p(1));


% Add a legend for the vertical lines and fit line (skip the first entry)
legend({'', sprintf('x = %.0f', xline1), sprintf('x = %.0f', xline2), fit_eqn}, ...
	'Interpreter', 'latex', 'FontSize', 12, 'Location', 'best');

hold off;
end
