% function [event_size,z] = Manna (L, steps, wait,z,event_size)
% 
%     arguments
%         L (1,1) double = 50
%         steps (1,1) double = 10e4
%         wait (1,1) double = 10e3
%     end

%Initialization

%Parameters
%rng(0, 'twister');							% Sets the seed and uses Mersenne Twister.
q = 4;
z_c = q - 1;										% Critical height

%Creating the lattice (with absorbing boundaries)
L_b = L + 2;										% Length with abs. boundaries

% Create the lattice if it wasn't passed down as a variable
if ~exist('z','var'); z = randi([0 z_c],L);
elseif numel(z) ~= L^2; error("Lattice dimensions don't match"); end

if ~exist('event_size','var'); event_size = zeros(steps,1);
elseif size(event_size,2) ~= 1; error("Event size vector doesn't match"); end


active_sites = [];
events = 0;
added = 0;

%Nearest neightbors
nn_l=circshift(reshape(1:L_b^2,L_b,L_b),-1,1);
nn_r=circshift(reshape(1:L_b^2,L_b,L_b),1,1);
nn_u=circshift(reshape(1:L_b^2,L_b,L_b),-1,2);
nn_d=circshift(reshape(1:L_b^2,L_b,L_b),1,2);

nn_l=nn_l(2:end-1,2:end-1);
nn_r=nn_r(2:end-1,2:end-1);
nn_u=nn_u(2:end-1,2:end-1);
nn_d=nn_d(2:end-1,2:end-1);

%Simulation
while events < steps + wait

    %Drive loop
    count = 0;
    while isempty(active_sites) == true
       
		i = randi(L^2);					    		% Random site

        if z(i) == z_c							% Mark as (about to be) active if needed
			active_sites = i;
        end

		z(i) = z(i) + 1;							% Drop one grain
        added = added + 1;
    end

    %Relaxation loop
    while isempty(active_sites) == false
		n_as = size(active_sites,1); % Number of active sites
        count = count + n_as;
		z(active_sites) = z(active_sites) - q;

        % Sites to the (l/r/u/d) of an active site
		nn = zeros(4,n_as);
		nn(1,:) = nn_l(active_sites);
        nn(2,:) = nn_r(active_sites);
        nn(3,:) = nn_u(active_sites);
        nn(4,:) = nn_d(active_sites);

		% Stocasticity
		dice_roll = randi([1 4], q, n_as);
		for k = 1:n_as
		nn(:,k) = nn(dice_roll(:,k),k);
		end

        % Increment
        delta = zeros(L_b,L_b);
        delta(nn(1,:)) = delta(nn(1,:)) + 1;
        delta(nn(2,:)) = delta(nn(2,:)) + 1;
        delta(nn(3,:)) = delta(nn(3,:)) + 1;
        delta(nn(4,:)) = delta(nn(4,:)) + 1;

        z = z + delta(2:L+1,2:L+1);
       
        active_sites = find(z>z_c);		% Find newly activated sites

    end
	events = events + 1;
    event_size(events) = count;
end

% end
event_size = event_size(wait+1:end);
