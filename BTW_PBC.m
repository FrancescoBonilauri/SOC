% function [n_active_sites , z] = BTW_PBC (L, N, steps, wait,z,event_size)
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

if ~exist('n_active_sites','var'); n_active_sites = zeros(steps,1);
elseif size(n_active_sites,2) ~= 1; error("The number of active sites vector doesn't match"); end

t = 0;
active_sites_idx = [];
n_active_sites = zeros(wait + steps,1);

% Nearest neightbors
nn_l=circshift(reshape(1:L^2,L,L),-1,1);
nn_r=circshift(reshape(1:L^2,L,L),1,1);
nn_u=circshift(reshape(1:L^2,L,L),-1,2);
nn_d=circshift(reshape(1:L^2,L,L),1,2);

active_sites_idx = find(z>z_c); % Find which sites start active

% Simulation
% Relaxation loop
while ~isempty(active_sites_idx) && t < steps + wait
	t = t + 1;
	n_active_sites(t) = size(active_sites_idx,1);

	% Topple
	z(active_sites_idx) = z(active_sites_idx) - q;

	% Sites to the (l/r/u/d) of an active site
	l_as = nn_l(active_sites_idx);
	r_as = nn_r(active_sites_idx);
	u_as = nn_u(active_sites_idx);
	d_as = nn_d(active_sites_idx);

	% Increment
	z(l_as) = z(l_as) + 1;
	z(r_as) = z(r_as) + 1;
	z(u_as) = z(u_as) + 1;
	z(d_as) = z(d_as) + 1;

	active_sites_idx = find(z>z_c);		% Find newly activated sites
end


% end
n_active_sites = n_active_sites(wait+1:t);
mean_active_sites = mean(n_active_sites);

mean_active_sites(isnan(mean_active_sites)) = 0;

function lattice = random_lattice(L, N)

% Randomly assign each grain to a site
site_assignments = randi([1, L^2], N, 1);
[site_assignments, ~, idx] = unique(site_assignments);
grains = accumarray(idx, 1);

lattice = zeros(L);
lattice(site_assignments) = lattice(site_assignments) + grains;
end