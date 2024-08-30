function [avalanche_sizes,avalanche_duration] = consolidate_temp_data (avalanche_sizes,avalanche_duration,path,timestamp)
list = dir(path+"temp_"+timestamp+"_*.mat");
for i = 1:numel(list)
	tmp = load(path+list(i).name);
	avalanche_sizes = [avalanche_sizes; tmp.event_size];
	avalanche_duration = [avalanche_duration; tmp.event_duration];

	delete(path+list(i).name);

	sprintf("Consolidated and deleted %s",list(i).name)

end	

end
