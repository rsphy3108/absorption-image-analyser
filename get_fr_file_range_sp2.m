load configdata;

ref_files_sp2 = get(handles.edit_FRfiles_sp2,'String');
refnums_sp2 = textscan(ref_files_sp2, '%s','delimiter',',');

refnums_sp2 = refnums_sp2{1};

for count = 1:length(refnums_sp2)
    ranges_sp2{count} = textscan(refnums_sp2{count}, '%s','delimiter','-');
end

for count = 1:length(ranges_sp2)    
    lower(count) = round(str2num(ranges_sp2{count}{1}{1}));    
    if length(ranges_sp2{count}{1}) == 2        
        upper(count) = round(str2num(ranges_sp2{count}{1}{2}));        
    else        
        upper(count) = 0;        
    end    
end

refindex_sp2 = [];

for count = 1:length(ranges_sp2)
    if upper(count) ~= 0
        refindex_sp2(length(refindex_sp2)+1:length(refindex_sp2)+(upper(count)-lower(count))+1) = lower(count):1:upper(count);
    else
        refindex_sp2(length(refindex_sp2)+1) = lower(count);
    end
end

save('configdata','refindex_sp2','-append');