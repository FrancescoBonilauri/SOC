% function [n_active_sites , z] = BTW_PBC (L, N, steps, wait,z,n_active_sites)
%
%     arguments
%         L (1,1) double = 50
%         steps (1,1) double = 10e4
%         wait (1,1) double = 10e3
%     end

% Initialization

% Parameters
%rng(0, 'twister');							% Sets the seed and uses Mersenne Twister.
q = 4;
z_c = q - 1;										% Critical height

% Create the lattice if it wasn't passed down as a variable
if ~exist('z','var') || sum(z,"all") ~= N; z = random_lattice(L, N);
elseif numel(z) ~= L^2; error("Lattice dimensions don't match"); end

% Nearest neightbors
nn_l=circshift(reshape(1:L^2,L,L),-1,1);
nn_r=circshift(reshape(1:L^2,L,L),1,1);
nn_u=circshift(reshape(1:L^2,L,L),-1,2);
nn_d=circshift(reshape(1:L^2,L,L),1,2);

active_sites_idx = find(z>z_c); % Find which sites start active
n_active_sites = zeros(steps+wait,1);

% Simulation
% Relaxation loop
t = 0;
while ~isempty(active_sites_idx) && t < steps + wait
	t = t + 1;
	n_active_sites(t) = size(active_sites_idx,1);

	% Topple
	z(active_sites_idx) = z(active_sites_idx) - q;

	% Sites to the (l/r/u/d) of an active site
	nn = zeros(4,n_active_sites(t));
	nn(1,:) = nn_l(active_sites_idx);
	nn(2,:) = nn_r(active_sites_idx);
	nn(3,:) = nn_u(active_sites_idx);
	nn(4,:) = nn_d(active_sites_idx);



	% Stocasticity
	% Generate random dice_roll indices
	dice_roll = randi([1 4], q, n_active_sites(t));

	% Convert dice_roll indices to linear indices for matrix nn
	row_indices = dice_roll + (0:n_active_sites(t)-1) * size(nn, 1);

	% Get the selected elements in a vectorized manner
	nn = nn(row_indices);

	% Reshape the resulting nn matrix into a column vector
	nn = reshape(nn, n_active_sites(t) * q, 1);

	delta_flat = accumarray(nn,ones(n_active_sites(t)*q,1),[L^2 1]);

	% Increment
	z = z + reshape(delta_flat,L,L);


	% Find newly activated sites
	active_sites_idx = find(z>z_c);
end


% end
n_active_sites = n_active_sites(wait+1:t);
mean_active_sites = mean(n_active_sites);

mean_active_sites(isnan(mean_active_sites)) = 0;