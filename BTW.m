%Initialization

%Parameters
%rng(0, 'twister');							% Sets the seed and uses Mersenne Twister.
L = 20;												% Size of lattice
q = 4;												% Coordination number
z_c = q - 1;										% Critical height
steps = 1000000;


%Creating the lattice (with absorbing boundaries)
L_b = L + 2;										% Length with abs. boundaries
z = randi([0 z_c-1],L);						% Lattice

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
while events < steps

    %Drive loop
    event_size = 0;
    while isempty(active_sites) == true
       
		i = randi(L^2);							% Random site

        if z(i) == z_c							% Mark as (about to be) active if needed
			active_sites = i;
        end

		z(i) = z(i) + 1;							% Drop one grain
        added = added + 1;
    end

    %Relaxation loop
    while isempty(active_sites) == false
        event_size = event_size + size(active_sites,1);
        events = events + 1;

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

        % % IMPLEMENTATION WITH SPARSE MATRIX
        % neighbors = [nn_l(active_sites); nn_r(active_sites); nn_u(active_sites); nn_d(active_sites)];
        % [neighbors, ~, idx] = unique(neighbors);
        % grains = accumarray(idx, 1);
        % [x, y] = ind2sub([L_b,L_b],neighbors);
        % delta = sparse(x,y,grains,L_b,L_b);
        % z_inner = z_inner + delta(2:L+1,2:L+1);

        
        active_sites = find(z>z_c);		% Find newly activated sites

		% % IMPLEMENTATION SEARCHING ONLY MODIFIED SITES
        % j = find(delta(2:L+1,2:L+1));
        % active_sites = j(z(j)>z_c);

        break

    end

end

not_dropped = sum(z,"all")
added