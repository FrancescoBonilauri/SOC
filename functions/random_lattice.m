function lattice = random_lattice(L, N)

%Randomly assign each grain to a site
site_assignments = randi([1, L^2], N, 1);
[site_assignments, ~, idx] = unique(site_assignments);
grains = accumarray(idx, 1);

lattice = zeros(L);
lattice(site_assignments) = lattice(site_assignments) + grains;
end