function [sizes, count] = postprocess_data(event_sizes)

  [sizes, ~, idx] = unique(event_sizes);
  count = accumarray(idx, 1);
end
