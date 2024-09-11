% Script to plot a graph of the evolution of the particole density in the
% BTW model

L = 50;
micro_steps = 10e4;
wait = 10e3;
z = randi([0 3],L);

%The way I measure time here is the same for the microscopic and
%macroscopic scales. It's focus it to parametrize an animation/graph of the
%evolution of the model and not to calculate estimates for the critical
%exponents


% Initialization

% Parameters
q = 4;
% Critical height
z_c = q - 1;
wait_tmp = wait;
% Creating the lattice (with absorbing boundaries)
L_b = L + 2;


active_sites = [];
n_particles = zeros(micro_steps+wait_tmp,1);

% Nearest neightbors
nn_l=circshift(reshape(1:L_b^2,L_b,L_b),-1,1);
nn_r=circshift(reshape(1:L_b^2,L_b,L_b),1,1);
nn_u=circshift(reshape(1:L_b^2,L_b,L_b),-1,2);
nn_d=circshift(reshape(1:L_b^2,L_b,L_b),1,2);

nn_l=nn_l(2:end-1,2:end-1);
nn_r=nn_r(2:end-1,2:end-1);
nn_u=nn_u(2:end-1,2:end-1);
nn_d=nn_d(2:end-1,2:end-1);

t=0;
% Simulation
while t < micro_steps + wait_tmp

	%Drive loop
	while isempty(active_sites) == true
		t = t + 1;
		i = randi(L^2);					    	% Random site

		if z(i) == z_c							% Mark as (about to be) active if needed
			active_sites = i;
		end

		z(i) = z(i) + 1;							% Drop one grain

		n_particles(t) = sum(z, "all");
	end

	% % Relaxation loop
	% while isempty(active_sites) == false
	% 	t = t + 1;
	% 	n_as = size(active_sites,1); % Number of active sites
	% 	z(active_sites) = z(active_sites) - q;
	% 
	% 	% Sites to the (l/r/u/d) of an active site
	% 	nn = zeros(4,n_as);
	% 	nn(1,:) = nn_l(active_sites);
	% 	nn(2,:) = nn_r(active_sites);
	% 	nn(3,:) = nn_u(active_sites);
	% 	nn(4,:) = nn_d(active_sites);
	% 
	% 		% Stocasticity
	% 	% Generate random dice_roll indices
	% 	dice_roll = randi([1 4], q*n_as,1);
	% 
	% 	% Convert dice_roll indices to linear indices for matrix nn
	% 	offsets = repelem((0:n_as-1) * size(nn, 1), q)';
	% 	row_indices = dice_roll + offsets;
	% 	% Get the selected elements in a vectorized manner
	% 	nn = nn(row_indices);
	% 
	% 	% Increment
	% 	delta_flat = accumarray(nn,ones(n_as*q,1),[L_b^2 1]);
	% 	delta = reshape(delta_flat,L_b,L_b);
	% 	z = z + delta(2:L+1,2:L+1);
	% 
	% 
	% 	% Find newly activated sites
	% 	active_sites = find(z>z_c);
	% 
	% 	n_particles(t) = sum(z, "all");
	% 
	% end

%Relaxation loop
	while isempty(active_sites) == false
		t = t + 1;
		n_as = size(active_sites,1); % Number of active sites
		z(active_sites) = z(active_sites) - q;

		% Sites to the (l/r/u/d) of an active site
		l_as = nn_l(active_sites);
		r_as = nn_r(active_sites);
		u_as = nn_u(active_sites);
		d_as = nn_d(active_sites);

		% Increment
		delta = zeros(L_b,L_b);
		delta(l_as) = delta(l_as) + 1;
		delta(r_as) = delta(r_as) + 1;
		delta(u_as) = delta(u_as) + 1;
		delta(d_as) = delta(d_as) + 1;

		z = z + delta(2:L+1,2:L+1);

		active_sites = find(z>z_c);		% Find newly activated sites
		n_particles(t) = sum(z, "all");

	end

end

% Pruning thermalization
if wait_tmp ~= 0;	n_particles =  n_particles(wait_tmp+1:end); end
%% 
% Create the plot
figure;
plot(n_particles/L^2, 1:numel(n_particles), 'LineWidth', 1.5);

% Set the labels and title with LaTeX interpreter
xlabel('Density of particles per site', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Time', 'Interpreter', 'latex', 'FontSize', 14);
%title('Particles Distribution Plot', 'Interpreter', 'latex', 'FontSize', 16);

% Compute the mean of the x-values
mean_value = mean(n_particles/L^2);

% Add a vertical line at the mean
hold on;
y_limits = ylim; % Get current y-axis limits
plot([mean_value, mean_value], y_limits, '--r', 'LineWidth', 1.5); % Vertical line
hold off;

set(gca, 'TickLabelInterpreter', 'latex');  % Use LaTeX interpreter for tick labels
set(gca, 'XMinorTick', 'on');
set(gca, 'FontSize', 14);              % Set font size for the axis labels
set(gca, 'LineWidth', 1.5);            % Thicker axis lines

% Add text to indicate the mean value
text(mean_value+0.004, y_limits(2)*0.9, sprintf('$%.3f$', mean_value), ...
    'Interpreter', 'latex', 'FontSize', 12, 'HorizontalAlignment', 'center', 'Color', 'red');

% Adjust grid and appearance
grid on;
set(gca, 'FontSize', 12);