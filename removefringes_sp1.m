% removefringes_sp1.m
% Removes fringes using the method in Caspar F. Ockeloen's masters thesis
% from Amsterdam. See section 2.2 of the thesis.
% The idea is to find a linear superposition of background probe shots for
% each shot with atoms in it to make the "best" background image to
% subtract from the atoms.


load configdata
load maindata


%% Select ROI for mask

A_processed = handles.A_sp1;
O = handles.O;

% Draw box with mouse
t = waitforbuttonpress;    % wait for mouse button to be pressed

point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = round(point1(1,1:2));              % extract x and y
point2 = round(point2(1,1:2));
p1 = min(point1,point2);    % Do this so thing works no matter which way box is dragged
p2 = max(point1,point2);

% If you want to use a fixed ROI every time, you can define your own p1 and
% p2 points here.



%% Reload images files for re-processing

if handles.olddata == 0
    
    currentDate = date;
    currentYear = num2str(year(date));
    [monthNum currentMonth] = month(date);
    monthFullName = datestr(date,'mmmm');
    currentDay = num2str(day(date),'%02d');
    currentPath = [storagePath filesep currentYear filesep currentMonth filesep currentDay filesep];
    
else
    
    currentPath = pathname_olddata;    
    
end

% Rotation nonsense to get orientation right
A = loadascii([currentPath astorename_sp1]);
B = loadascii([currentPath bstorename_sp1]);
C = loadascii([currentPath cstorename_sp1]);

A = rot90(A,numrotations_sp1);
B = rot90(B,numrotations_sp1);
C = rot90(C,numrotations_sp1);

%points defining image area for fringe removal.
fmp1 = [p1(1)-xwidth_sp1 p1(2)-zwidth_sp1];
fmp2 = [p2(1)+xwidth_sp1 p2(2)+zwidth_sp1];


A_fm = A(fmp1(2):fmp2(2),fmp1(1):fmp2(1));

% Background mask
bgmask = ones(size(A_fm));
pp1 = p1 - fmp1 + 1;
pp2 = fmp2 - p2 + 1;
bgmask(pp1(2):pp2(2),pp1(1):pp2(1)) = 0;


fmxdim = size(A_fm,2);
fmydim = size(A_fm,1);

%% Collect backround images

underscoreIndex = find(frName_sp1 == '_');
filename_chopped = frName_sp1(1:underscoreIndex(2));

%% Collect backround images
num_images = length(refindex_sp1)+1;
refimg_matrix = zeros(fmydim,fmxdim,num_images);
refimg = B(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
refimg_matrix(:,:,1) = refimg;
jj = 1;
% Loop through reference images and store them in a matrix
for ii = 1:1:length(refindex_sp1);
    jj = jj + 1;
    filename_ref = [filename_chopped num2str(refindex_sp1(ii)) '.asc'];
    refimg = loadascii([frPath_sp1 filename_ref]);
    refimg = rot90(refimg,numrotations_sp1);           
    refimg_matrix(:,:,jj) = refimg(fmp1(2):fmp2(2),fmp1(1):fmp2(1)); 
end
ref_reshaped = double(reshape(refimg_matrix,fmxdim*fmydim,num_images));
A_reshaped = double(reshape(A_fm,fmxdim*fmydim,1));

optrefimages = zeros(size(A_fm));

% load([FRmask_pathname_sp1 FRmask_filename_sp1]);    % presumably the mask is saved as "bgmask" in the .mat file

mask_index = find(bgmask(:) == 1);

% Decompose B = ref_reshaped*ref_reshaped' using singular value or LU decomposition
[LL,UU,PP] = lu(ref_reshaped(mask_index,:)'*ref_reshaped(mask_index,:),'vector');       % LU decomposition

bb = ref_reshaped(mask_index,:)'*A_reshaped(mask_index,1);
lower.LT = true;
upper.UT = true;
cc = linsolve(UU,linsolve(LL,bb(PP,:),lower),upper);

% Compute optimised reference image
B_defringed = reshape(ref_reshaped*cc,[fmydim fmxdim]);
B_fm = B;
B_fm(fmp1(2):fmp2(2),fmp1(1):fmp2(1)) = B_defringed;
B = B_fm;

ana_sp1;

axes(handles.axes_2d_sp1);
title(['Absorption image of old data set (' filename_sp1 ')'],'Interpreter','none');