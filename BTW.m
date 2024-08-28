% function [event_size,z] = BTW (L, steps, wait,z,event_size)
% 
%     arguments
%         L (1,1) double = 50
%         steps (1,1) double = 10e4
%         wait (1,1) double = 10e3
%     end

%Initialization
model = "BTW";
%Parameters
%rng(0, 'twister');							% Sets the seed and uses Mersenne Twister.
q = 4;
z_c = q - 1;										% Critical height
wait_tmp = wait;
%Creating the lattice (with absorbing boundaries)
L_b = L + 2;										% Length with abs. boundaries

% Create the lattice if it wasn't passed down as a variable
if ~exist('z','var'); z = randi([0 z_c],L);
elseif numel(z) ~= L^2; error("Lattice dimensions don't match");
else; wait_tmp = 0;
end

% % MOVED CONCATENATION TO PARENT SCRIPT
% previous_events = 0;
% if ~exist('event_size','var'); event_size = zeros(steps,1);
% elseif size(event_size,2) ~= 1; error("Event size vector doesn't match");
% else; previous_events = numel(event_size); event_size = [event_size; zeros(steps,1)];
% end
event_size = zeros(steps,1);


active_sites = [];
events = 0;

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
while events < steps + wait_tmp

    %Drive loop
    count = 0;
    while isempty(active_sites) == true
       
		i = randi(L^2);					    		% Random site

        if z(i) == z_c							% Mark as (about to be) active if needed
			active_sites = i;
        end

		z(i) = z(i) + 1;							% Drop one grain
    end

    %Relaxation loop
    while isempty(active_sites) == false
        count = count + numel(active_sites);
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

    end
	events = events + 1;
    event_size(events) = count;
end

% end

if wait_tmp ~= 0; event_size = event_size(wait_tmp+1:end); end
