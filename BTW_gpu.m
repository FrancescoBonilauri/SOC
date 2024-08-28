%Initialization

% Parameters
L = 20;                                      % Size of lattice
q = gpuArray(4);                                       % Coordination number
z_c = q - 1;                                 % Critical height
steps = 10000;

% Creating the lattice (with absorbing boundaries)
L_b = L + 2;                                 % Length with abs. boundaries
z = randi([0 z_c-1],L,"gpuArray");          % Lattice on GPU

active_sites = gpuArray([]);                 % Active sites on GPU
events = gpuArray(0);                        % Initialize events count
added = gpuArray(0);                         % Initialize grains added count

% Nearest neighbors using GPU arrays
nn_l = circshift(reshape(gpuArray(1:L_b^2),L_b,L_b), -1, 1);
nn_r = circshift(reshape(gpuArray(1:L_b^2),L_b,L_b), 1, 1);
nn_u = circshift(reshape(gpuArray(1:L_b^2),L_b,L_b), -1, 2);
nn_d = circshift(reshape(gpuArray(1:L_b^2),L_b,L_b), 1, 2);

nn_l = nn_l(2:end-1, 2:end-1);
nn_r = nn_r(2:end-1, 2:end-1);
nn_u = nn_u(2:end-1, 2:end-1);
nn_d = nn_d(2:end-1, 2:end-1);

% Simulation
while events < steps
    
    % Drive loop
    event_size = gpuArray(0);
    while isempty(active_sites)
        i = randi(L^2, 'gpuArray');          % Random site on GPU
        
        if z(i) == z_c
            active_sites = i;                % Mark as active if needed
        end
        
        z(i) = z(i) + 1;                     % Drop one grain
        added = added + 1;
    end

    % Relaxation loop
    while ~isempty(active_sites)
        event_size = event_size + numel(active_sites); % Increment event size
        events = events + 1;

        z(active_sites) = z(active_sites) - q;        % Topple active site

        % Sites to the (l/r/u/d) of an active site
        l_as = nn_l(active_sites);
        r_as = nn_r(active_sites);
        u_as = nn_u(active_sites);
        d_as = nn_d(active_sites);

        % Increment using GPU arrays
        delta = gpuArray.zeros(L_b, L_b);    % Use GPU array for delta
        delta(l_as) = delta(l_as) + 1;
        delta(r_as) = delta(r_as) + 1;
        delta(u_as) = delta(u_as) + 1;
        delta(d_as) = delta(d_as) + 1;

        z = z + delta(2:L+1, 2:L+1);         % Update z on GPU

        % Find newly activated sites
        active_sites = find(z > z_c);        % Use GPU-compatible find function
    end

end

% After simulation ends, gather results from GPU if necessary
z_final = gather(z);                         % Move back to CPU if needed
