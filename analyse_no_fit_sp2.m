% analyse_and_fit_sp2.m
% Analyses image data and calls other relevant routines for species 1.

load configdata.mat
load maindata.mat
load offlineconfigdata

%% Analysis

p1 = p1_sp2;
p2 = p2_sp2;
A = A(p1(2):p2(2),p1(1):p2(1));
B = B(p1(2):p2(2),p1(1):p2(1));
C = C(p1(2):p2(2),p1(1):p2(1));
at_zwidth = at_zwidth_sp2;
at_xwidth = at_xwidth_sp2;



% If fringe removal is being used, this goes first.
% if useFR_sp2 == 1
%     removefringes_sp2;
% end

A = A - C;    % subtract background
B = B - C;
clear C;

epsilon = min(A(A > 0));     % Checking for and correcting zeros
A(A <= 0) = epsilon;
B(B <= 0) = epsilon;
clear epsilon;

% Choose which type of imaging we are doing
switch analysis_type_sp2
    
    case 'Classic'
        
        A = log(B./A);
        
    case 'px-by-px'
        
        A_meas = log(B./A); % Measured OD
        
        A_mod = real(log((1 - exp(-OD_sat_sp2))./(exp(-A_meas) - exp(-OD_sat_sp2))));
        A_actual = A_mod + (1 - exp(-A_mod)).*B./Isat_eff_sp2;  % See Robert Wild's thesis for details
        A = real(A_actual);
        
    case 'High Intensity'
        
        A = log(B./A) + (B - A)/Isat_eff_sp2;   % See Robert Wild's thesis for details
        
    case 'Faraday'
        
        A = A - B;
        
end


if(manual_cntr_sp2==1)
    %Gaussian filtering
    A_temp = imgaussfilt(A, smoth_sigma);
    maximum = max(max(A_temp));
    [z, x] = find(A_temp==maximum);
else
    z = ctr_z_sp2;
    x = ctr_x_sp2;
end    

if(z-at_zwidth/2 < 1)
    zmin = 1;
else
    zmin = z-round(at_zwidth/2);
end

if(z+at_zwidth/2 > size(A,1))
    zmax = size(A,1);
else
    zmax = z+round(at_zwidth/2);
end

if(x-at_xwidth/2 < 1)
    xmin = 1;
else
    xmin =x-round(at_xwidth/2);
end

if(x+at_xwidth/2 > size(A,2))
    xmax = size(A,2);
else
    xmax = x+round(at_xwidth/2);
end

A_temp = A;
A_temp(zmin:zmax,xmin:xmax) = 0;
A_bg = A_temp;
A_at = A(zmin:zmax,xmin:xmax);
bg_mean = sum(sum(A_bg))/(numel(A_bg)-numel(A_at));
at_sum = sum(sum(A_at - bg_mean));

% A_temp = imgaussfilt(A, smoth_sigma);
% maximum = max(max(A_temp));
% [z, x] = find(A_temp==maximum);
% A_temp = A;
% if(z-bg_zwidth/2 < 1 || z+bg_zwidth/2 > size(A,1)|| x-bg_xwidth/2 < 1 || x+bg_xwidth/2 > size(A,2))
%     at_sum = 0;
% else
%     A_temp = A;
%     A_temp(z-at_zwidth/2:z+at_zwidth/2,x-at_xwidth/2:x+at_xwidth/2) = 0;
%     A_bg = A_temp(z-bg_zwidth/2:z+bg_zwidth/2,x-bg_xwidth/2:x+bg_xwidth/2);
%     A_at = A(z-at_zwidth/2:z+at_zwidth/2,x-at_xwidth/2:x+at_xwidth/2);
%     bg_mean = sum(sum(A_bg))/(numel(A_bg)-numel(A_at));
%     at_sum = sum(sum(A_at - bg_mean));
% end
%disp(at_sum)
clear x z %temporary variables, not needed any more;

find_at_no_sum_sp2;




