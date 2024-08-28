%Initialization
%Parameters
%rng(0, 'twister');      % Sets the seed and uses Mersenne Twister.
L = 20;                 % Size of lattice
q = 4;                  % Coordination number
z_c = q - 1;                % Critical height
steps = 1000000;


%Creating the lattice (with absorbing boundaries)
L_b = L + 2;            % Length with abs. boundary
z = randi([0 z_c-1],L_b);
as = [];                % Active sites indexes
as_r = [];
lin_as_r = [];
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
    while isempty(lin_as_r) == true
        x = randi([2, L+1]);
        y = randi([2, L+1]);    % Random site
        if z(x,y) == z_c    % Mark as active if needed
            %as = [x,y];
            as_r = [x,y] - 1;
            lin_as_r = sub2ind([L,L],as_r(:,1),as_r(:,2));
        end
        z(x,y) = z(x,y) + 1;

        added = added + 1;
    end

    %First topple
    % z(x,y) = z(x,y) - q;
    %
    % if z(x+1,y) == z_c; as(1,:) = [x+1,y]; end
    % if z(x-1,y) == z_c; as(end+1,:) = [x-1,y]; end
    % if z(x,y+1) == z_c; as(end+1,:) = [x,y+1]; end
    % if z(x,y-1) == z_c; as(end+1,:) = [x,y-1]; end
    %
    %
    % z(x+1,y) = z(x+1,y) + 1;
    % z(x-1,y) = z(x-1,y) + 1;
    % z(x,y+1) = z(x,y+1) + 1;
    % z(x,y-1) = z(x,y-1) + 1;
    %
    % events = events + 1;
    % event_size = event_size + 1;


    %Relaxation loop
    while isempty(lin_as_r) == false
        event_size = event_size + size(lin_as_r,1);
        events = events + 1;


        %lin_as = sub2ind([L_b,L_b],as(:,1),as(:,2));
        %lin_as_r = sub2ind([L,L],as_r(:,1),as_r(:,2));

        z_temp = z(2:L+1,2:L+1);

        z_temp(lin_as_r) = z_temp(lin_as_r)-q;

        % Sites to the (l/r/u/d) of an active site

        %MAYBE FASTER WITHOUT PREALLOCATING
        l_as = nn_l(lin_as_r);
        r_as = nn_r(lin_as_r);
        u_as = nn_u(lin_as_r);
        d_as = nn_d(lin_as_r);

        % Increment
        %SPARSE?
        delta = zeros(L_b,L_b);
        delta(l_as) = delta(l_as) + 1;
        delta(r_as) = delta(r_as) + 1;
        delta(u_as) = delta(u_as) + 1;
        delta(d_as) = delta(d_as) + 1;
        z(2:L+1,2:L+1) = z_temp;
        z = z + delta;
        z_temp = z(2:L+1,2:L+1);
        as_r = [];
        %BUG
        %[as_r(:,1), as_r(:,2)]

        lin_as_r = find(z_temp>z_c);

        % j = find(delta(2:L+1,2:L+1));
        % lin_as_r = j(z_temp(j)>z_c);



        %as = as_r +1;
        % = ind2sub([L_b,L_b],j(z(j)>z_c));

        % z(l_as) = z(l_as) + 1;
        % z(r_as) = z(r_as) + 1;
        % z(u_as) = z(u_as) + 1;
        % z(d_as) = z(d_as) + 1;

        % Check if they get activated
        %as = find(z(nonzeros(delta)) )
        %as_l = find(z(l_as) == z_c-1);

        break

    end

end

dropped = sum(z(1,:)+z(L+2,:)) + sum(z(2:L+1,1)+z(2:L+1,L+2))
not_dropped = sum(z(2:L+1,2:L+1),"all")
added
sum(z,"all")-added
max(event_size)



