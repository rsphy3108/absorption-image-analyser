function v = findsta1(data)

% This function finds appropriate starting values for least square interation

data_temp = imgaussfilt(data, 2);

v = zeros(1,4);
sizeofdata = size(data);
mindata = min(data_temp);

v(1) = min(data);             % background (New 13/06/12)
[maxdata,v(3)] = max(data_temp);   % x centre
v(3) = mean(1:1:size(data,2));   % x centre
% if(mindata < 3  *maxdata)         
%     v(1) = min(data);             % background 
%     v(2) = maxdata-v(1);          % amplitude
% end


value_to_find = v(1) + v(2)*1/exp(1);
as = find(data >= value_to_find);
assize = size(as);
v(4) = (as(assize(2))-as(1))/2;    % sigmax
%v(4) = 3;    % sigmax