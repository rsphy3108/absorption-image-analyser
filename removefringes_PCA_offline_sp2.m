% removefringes_PCA_sp2.m
% Removes fringes using the method that is described in the follwing article
% "Optimized fringe removal algorithm for absorption images"
% Appl. Phys. Lett. 113, 144103 (2018); https://doi.org/10.1063/1.5040669
% Linxiao Niu, Xinxin Guo, Yuan Zhan1, Xuzong Chen, W. M. Liu, and Xiaoji Zhou1


load configdata
load maindata

pp1 = p1 - fmp1 + 1;
pp2 = fmp2 - p2 + 1;

no_of_components = 25; %Number of PCA components

A_fm = A(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
C_fm = C(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
A_mean = mean2(A_fm-C_fm);
As = A_fm - C_fm - A_mean; %Scaled image

fmxdim = size(A_fm,2);
fmydim = size(A_fm,1);


%% Collect backround images

A_reshaped = make_edge_vector(As,pp1,pp2);
num_images = length(ref_img_array1)+1;  % number of reference images

%Make a matrix of edge vectors of all the reference images
refimg_matrix = zeros(fmydim,fmxdim,num_images);
refimg_edge_matrix = zeros(size(A_reshaped,1),num_images);

refimgb = B(fmp1(2):fmp2(2),fmp1(1):fmp2(1)) - C_fm - mean2(B(fmp1(2):fmp2(2),fmp1(1):fmp2(1))-C_fm);
refimg_matrix(:,:,1) = refimgb;
refimg_reshaped = make_edge_vector(refimgb,pp1,pp2);
refimg_edge_matrix(:,1) = refimg_reshaped;
jj = 1;    
for ii = ref_img_array1
    jj = jj + 1;
    filename_refb = ['b' filename_chopped num2str(ii) '.asc'];
    refimgb = loadascii([dir_path filename_refb]);
    refimgb = rot90(refimgb,numrotations_sp2);
    
    filename_refc = ['c' filename_chopped num2str(ii) '.asc'];
    refimgc = loadascii([dir_path filename_refc]);
    refimgc = rot90(refimgc,numrotations_sp2);
    
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