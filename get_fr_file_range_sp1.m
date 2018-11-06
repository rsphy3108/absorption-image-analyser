load configdata;

ref_files_sp1 = get(handles.edit_FRfiles_sp1,'String');
refnums_sp1 = textscan(ref_files_sp1, '%s','delimiter',',');

refnums_sp1 = refnums_sp1{1};

for count = 1:length(refnums_sp1)
    ranges_sp1{count} = textscan(refnums_sp1{count}, '%s','delimiter','-');
end

for count = 1:length(ranges_sp1)    
    lower(count) = round(str2num(ranges_sp1{count}{1}{1}));    
    if length(ranges_sp1{count}{1}) == 2        
        upper(count) = round(str2num(ranges_sp1{count}{1}{2}));        
    else        
        upper(count) = 0;        
    end    
end

refindex_sp1 = [];

for count = 1:length(ranges_sp1)
    if upper(count) ~= 0
        refindex_sp1(length(refindex_sp1)+1:length(refindex_sp1)+(upper(count)-lower(count))+1) = lower(count):1:upper(count);
    else
        refindex_sp1(length(refindex_sp1)+1) = lower(count);
    end
end

save('configdata','refindex_sp1','-append');