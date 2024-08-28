function [avalanche_sizes] = consolidate_temp_data (avalanche_sizes,path,timestamp)
list = dir(path+"temp_"+timestamp+"_*.mat");
for i = 1:numel(list)
	sprintf("Consolidated and deleted %s",list(i).name)
	tmp = load(path+list(i).name);
	avalanche_sizes = [avalanche_sizes; tmp.event_size];
	delete(path+list(i).name);
end	

end
