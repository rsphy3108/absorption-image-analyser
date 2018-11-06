% removefringes_PCA_sp1.m
% Removes fringes using the method that is described in the follwing article
% "Optimized fringe removal algorithm for absorption images"
% Appl. Phys. Lett. 113, 144103 (2018); https://doi.org/10.1063/1.5040669
% Linxiao Niu, Xinxin Guo, Yuan Zhan1, Xuzong Chen, W. M. Liu, and Xiaoji Zhou1


load configdata
load maindata

no_of_components = 25; %Number of PCA components

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

%Points defining the edge region
fmp1 = [p1(1)-xwidth_sp1 p1(2)-zwidth_sp1];
fmp2 = [p2(1)+xwidth_sp1 p2(2)+zwidth_sp1];

pp1 = p1 - fmp1 + 1;
pp2 = fmp2 - p2 + 1;


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

A_fm = A(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
C_fm = C(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
A_mean = mean2(A_fm-C_fm);
As = A_fm - C_fm - A_mean; %Scaled image

fmxdim = size(A_fm,2);
fmydim = size(A_fm,1);

% if useROI_sp1 == 1 
%     A = A(ax_sp1(3):ax_sp1(4),ax_sp1(1):ax_sp1(2));
%     C = C(ax_sp1(3):ax_sp1(4),ax_sp1(1):ax_sp1(2));
%     bgmask = bgmask(ax_sp1(3):ax_sp1(4),ax_sp1(1):ax_sp1(2));
% end


%% Collect backround images

underscoreIndex = find(frName_sp1 == '_');
filename_chopped = frName_sp1(2:underscoreIndex(2));

A_reshaped = make_edge_vector(As,pp1,pp2);
num_images = length(refindex_sp1)+1;  % number of reference images

%Make a matrix of edge vectors of all the reference images
refimg_matrix = zeros(fmydim,fmxdim,num_images);
refimg_edge_matrix = zeros(size(A_reshaped,1),num_images);

refimgb = B(fmp1(2):fmp2(2),fmp1(1):fmp2(1)) - C_fm - mean2(B(fmp1(2):fmp2(2),fmp1(1):fmp2(1))-C_fm);
refimg_matrix(:,:,1) = refimgb;
refimg_reshaped = make_edge_vector(refimgb,pp1,pp2);
refimg_edge_matrix(:,1) = refimg_reshaped;
jj = 1;     
for ii = 2:1:num_images
    jj = jj + 1;
    filename_ref = [filename_chopped num2str(refindex_sp1(ii-1)) '.asc'];
    refimgb = loadascii([frPath_sp1 'b' filename_ref]);
    refimgb = rot90(refimgb,numrotations_sp1);
    refimgc = loadascii([frPath_sp1 'c' filename_ref]);
    refimgc = rot90(refimgc,numrotations_sp1);
    refimgb = refimgb(fmp1(2):fmp2(2),fmp1(1):fmp2(1)) - mean2(refimgb(fmp1(2):fmp2(2),fmp1(1):fmp2(1)) - refimgc(fmp1(2):fmp2(2),fmp1(1):fmp2(1))) - refimgc(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
    refimg_matrix(:,:,jj) = refimgb;
    refimg_reshaped = make_edge_vector(refimgb,pp1,pp2);
    refimg_edge_matrix(:,jj) = refimg_reshaped;
    clear refimgb refimgc refimg_reshaped
end

%% Extract the principal components
edge_vec_covariance = refimg_edge_matrix*refimg_edge_matrix';
[pca_mat,pca_eigenvalue] = eigs(edge_vec_covariance,no_of_components);
clear edge_vec_covariance
% 

%Find the coefficient matrix for the superposition of ref image vectors%
coeff_matrix = zeros(num_images,no_of_components);
for ii = 1:1:no_of_components
    coeff_matrix(:,ii) = mldivide(refimg_edge_matrix,pca_mat(:,ii));  
end
clear refimg_edge_matrix
%
 %Form images corresponding to the principal components%
pca_img_matrix = zeros(fmydim,fmxdim,no_of_components);

for ii = 1:1:no_of_components
    for jj = 1:1:num_images
        pca_img_matrix(:,:,ii) = pca_img_matrix(:,:,ii) + coeff_matrix(jj,ii)*refimg_matrix(:,:,jj);
    end
end
clear refimg_matrix

%% Make the ideal background image;
B_ideal = zeros(fmydim,fmxdim);
for ii = 1:1:no_of_components
    w0 = A_reshaped'*pca_mat(:,ii);
    B_ideal = B_ideal + w0*pca_img_matrix(:,:,ii);
end
B_ideal = B_ideal + A_mean + C_fm;

B_fm = B;
B_fm(fmp1(2):fmp2(2),fmp1(1):fmp2(1)) = B_ideal;
B = B_fm;

ana_sp1;

axes(handles.axes_2d_sp1);
title(['Absorption image of old data set (' filename_sp1 ')'],'Interpreter','none');

function vec_reshaped = make_edge_vector(Img,p1,p2)

p3 = [1 1];
p4 = [size(Img,1) size(Img,2)];
%This function takes the image array and create a vector from the edge area.
img1 = Img(p3(1):p1(1),p3(2):p4(2));
img2 = Img(p1(1):p2(1),p3(2):p1(2));
img3 = Img(p1(1):p2(1),p2(2):p4(2));
img4 = Img(p2(1):p4(1),p3(2):p4(2));

xdim1 = size(img1,2);
ydim1 = size(img1,1);

xdim2 = size(img2,2);
ydim2 = size(img2,1);

xdim3 = size(img3,2);
ydim3 = size(img3,1);

xdim4 = size(img4,2);
ydim4 = size(img4,1);

vec1 = double(reshape(img1,xdim1*ydim1,1));
vec2 = double(reshape(img2,xdim2*ydim2,1));
vec3 = double(reshape(img3,xdim3*ydim3,1));
vec4 = double(reshape(img4,xdim4*ydim4,1));
vec_reshaped = cat(1,vec1,vec2,vec3,vec4);
end