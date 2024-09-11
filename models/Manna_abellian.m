function [event_size,event_duration,z] = Manna_abellian (L, steps, wait,z)

arguments
	L (1,1) double = 50
	steps (1,1) double = 10e4
	wait (1,1) double = 10e3
	z (:,:) double = randi([0 3],L)
end

% Initialization

% Parameters
q = 2;
% Critical height
z_c = q - 1;
wait_tmp = wait;
% Creating the lattice (with absorbing boundaries)
L_b = L + 2;

% No termalization if lattice is passed down
if nargin>3; wait_tmp = 0; end

event_size = zeros(steps+wait_tmp,1);
event_duration = zeros(steps+wait_tmp,1);
active_sites = [];
events = 0;

% Nearest neightbors
nn_l=circshift(reshape(1:L_b^2,L_b,L_b),-1,1);
nn_r=circshift(reshape(1:L_b^2,L_b,L_b),1,1);
nn_u=circshift(reshape(1:L_b^2,L_b,L_b),-1,2);
nn_d=circshift(reshape(1:L_b^2,L_b,L_b),1,2);

nn_l=nn_l(2:end-1,2:end-1);
nn_r=nn_r(2:end-1,2:end-1);
nn_u=nn_u(2:end-1,2:end-1);
nn_d=nn_d(2:end-1,2:end-1);

% Simulation
while events < steps + wait_tmp

	%Drive loop
	count = 0;
	duration = 0;
	while isempty(active_sites) == true

		i = randi(L^2);					    	% Random site

		if z(i) == z_c							% Mark as (about to be) active if needed
			active_sites = i;
		end

		z(i) = z(i) + 1;							% Drop one grain
	end

	% Relaxation loop
	while isempty(active_sites) == false
		n_as = size(active_sites,1); % Number of active sites
		count = count + n_as;
		duration = duration +1;
		z(active_sites) = z(active_sites) - q;

		% Sites to the (l/r/u/d) of an active site
		nn = zeros(4,n_as);
		nn(1,:) = nn_l(active_sites);
		nn(2,:) = nn_r(active_sites);
		nn(3,:) = nn_u(active_sites);
		nn(4,:) = nn_d(active_sites);

		% Stocasticity
		% Generate random dice_roll indices
		dice_roll = randi([1 4], q*n_as,1);

		% Convert dice_roll indices to linear indices for matrix nn
		offsets = repelem((0:n_as-1) * size(nn, 1), q)';
		row_indices = dice_roll + offsets;
		% Get the selected elements in a vectorized manner
		nn = nn(row_indices);

		% Increment
		delta_flat = accumarray(nn,ones(n_as*q,1),[L_b^2 1]);
		delta = reshape(delta_flat,L_b,L_b);
		z = z + delta(2:L+1,2:L+1);

		% Find newly activated sites
		active_sites = find(z>z_c);

	end
	events = events + 1;
	event_size(events) = count;
	event_duration(events) = duration;
end

% Pruning thermalization
if wait_tmp ~= 0
	event_size = event_size(wait_tmp+1:end);
	event_duration = event_duration(wait_tmp+1:end);
end

end