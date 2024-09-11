% Manually registered values of the critical exponent

x = [10,50,100,200];  % Common x data

% %size
% %Manna
% y = [1.45,1.27,1.25,1.25];  % Example y data with some noise

% %BTW
% y = [1.06,1.08,1.08,1.10];  % Example y data with some noise


%duration
% %Manna
% y = [1.37,1.51,1.47,1.42];  % Example y data with some noise
% 
%BTW
y = [1.05,1.12,1.15,1.15];  % Example y data with some noise

% Create the scatter plot for y vs 1/x
figure;
scatter(1 ./ x, y, 50, 'filled', 'MarkerFaceColor', [0.2, 0.5, 0.8], 'MarkerEdgeColor', 'k');
hold on;

% Perform linear regression (y = a * (1/x) + b)
X = [ones(length(x), 1), 1./x'];
b = X \ y';  % Regression coefficients [b(1) = intercept, b(2) = slope]

% Create the linear regression line
x_reg = linspace(min(1 ./ x), max(1 ./ x), 100);
y_reg = b(1) + b(2) * x_reg;

% Plot the linear regression line (dotted, different color)
plot(x_reg, y_reg, '--', 'LineWidth', 1.5, 'Color', [0.85, 0.33, 0.1]);

% Mark the intersection of the regression line with the y-axis (x=0)
y_intercept = b(1);
plot(0, y_intercept, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

% Axis labels with LaTeX interpreter
xlabel('$\frac{1}{x}$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$y$', 'Interpreter', 'latex', 'FontSize', 14);
title('Duration', 'Interpreter', 'latex', 'FontSize', 14);

% Add legend showing the y-intercept
legend(['y-intercept = ' num2str(y_intercept, '%.2f')], 'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 12);

% Fix y-axis to the left of the plot
ax = gca;
ax.YAxisLocation = 'left';

% Set axis properties for a clean look
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on', 'TickLabelInterpreter', 'latex');

% Highlight grid for aesthetics
grid on;
set(gca, 'GridAlpha', 0.2, 'MinorGridAlpha', 0.1);

% Adjust the limits to make the plot look well-centered
xlim([min(1 ./ x) - 0.02, max(1 ./ x) + 0.02]);  % Fine-tuning x-limits
ylim([min(y) - 0.1, max(y) + 0.1]);  % Fine-tuning y-limits

hold off;