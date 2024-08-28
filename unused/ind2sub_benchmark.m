n = 1e7;  % Large number of elements
m = 10000; % Number of rows in the matrix
linear_idx = randi([1, m*m], n, 1); % Generate random linear indices

% Method 1: Using ind2sub
tic;
[row_sub, col_sub] = ind2sub([m, m], linear_idx);
time_ind2sub = toc;

% Method 2: Using modular arithmetic
tic;
row = mod(linear_idx-1, m) + 1;
col = (linear_idx - row) / m + 1;
time_modular = toc;

fprintf('Time using ind2sub: %.5f seconds\n', time_ind2sub);
fprintf('Time using modular arithmetic: %.5f seconds\n', time_modular);
