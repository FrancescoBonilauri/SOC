% Pieces of code not currently used

% % IMPLEMENTATION WITH SPARSE MATRIX
% neighbors = [nn_l(active_sites); nn_r(active_sites); nn_u(active_sites); nn_d(active_sites)];
% [neighbors, ~, idx] = unique(neighbors);
% grains = accumarray(idx, 1);
% [x, y] = ind2sub([L_b,L_b],neighbors);
% delta = sparse(x,y,grains,L_b,L_b);
% z_inner = z_inner + delta(2:L+1,2:L+1);



% % IMPLEMENTATION SEARCHING ONLY MODIFIED SITES
% j = find(delta(2:L+1,2:L+1));
% active_sites = j(z(j)>z_c);