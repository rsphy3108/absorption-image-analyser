
refindex_sp1 = 1:1:20;
frPath_sp1 ='C:\Users\rahul.v.sawant\Desktop\DU Work\Imaging\absorption-image-analyser-master\old_data\';
frPath_sp2 ='C:\Users\rahul.v.sawant\Desktop\DU Work\Imaging\absorption-image-analyser-master\old_data\';

%fn =[frPath_sp2 'pca_components'];
%if ~exist(fn, 'dir')
%    mkdir(fn)
%end

filename_chopped = 'Rb85_27Sep2018_';
numrotations_sp1 = 1; 
no_of_components = 50;

filename_refa = ['a' filename_chopped '13' '.asc'];
filename_refb = ['b' filename_chopped '13' '.asc'];
filename_refc = ['c' filename_chopped '13' '.asc'];

p1 = [100 210];
p2 = [110 240];
edgewidth = 40;
p3 = p1 - edgewidth;
p4 = p2 + edgewidth;

A = loadascii([frPath_sp2 filename_refa]);
A = rot90(A,numrotations_sp1);
B = loadascii([frPath_sp2 filename_refb]);
B = rot90(B,numrotations_sp1);
C = loadascii([frPath_sp2 filename_refc]);
C = rot90(C,numrotations_sp1);
B = B - C;
A = A - C;
Ab = log(B./A);

A_mean = mean2(A);
As = A - A_mean; %Scaled image

%A = A(p1(1):p2(1),p1(2):p2(2));
%A = A(p3(1):p4(1),p3(2):p4(2));

%A = A(p3(1):p1(1),p3(2):p4(2));
%A = A(p1(1):p2(1),p3(2):p1(2));
%A = A(p1(1):p2(1),p2(2):p4(2));
%A = A(p2(1):p4(1),p3(2):p4(2));

xdim = size(A(p3(1):p4(1),p3(2):p4(2)),2);
ydim = size(A(p3(1):p4(1),p3(2):p4(2)),1);

A_reshaped = make_edge_vector(As,p1,p2,edgewidth);
num_images = length(refindex_sp1)+1;  % number of reference images

%Make a matrix of edge vectors of all the reference images
refimg_matrix = zeros(size(A(p3(1):p4(1),p3(2):p4(2)),1),size(A(p3(1):p4(1),p3(2):p4(2)),2),num_images);
refimg_edge_matrix = zeros(size(A_reshaped,1),num_images);

refimgb = B - mean2(B);
refimg_matrix(:,:,1) = refimgb(p3(1):p4(1),p3(2):p4(2));
refimg_reshaped = make_edge_vector(refimgb,p1,p2,edgewidth);
refimg_edge_matrix(:,1) = refimg_reshaped;
    
for ii = 2:1:num_images
    filename_ref = [filename_chopped num2str(refindex_sp1(ii-1)) '.asc'];
    refimgb = loadascii([frPath_sp1 'b' filename_ref]);
    refimgb = rot90(refimgb,numrotations_sp1);
    refimgc = loadascii([frPath_sp1 'c' filename_ref]);
    refimgc = rot90(refimgc,numrotations_sp1);
    refimgb = refimgb - mean2(refimgb) - refimgc;
    refimg_matrix(:,:,ii) = refimgb(p3(1):p4(1),p3(2):p4(2));
    refimg_reshaped = make_edge_vector(refimgb,p1,p2,edgewidth);
    refimg_edge_matrix(:,ii) = refimg_reshaped;
    clear refimgb refimgc refimg_reshaped
end

% %Extract the principal components%
edge_vec_covariance = refimg_edge_matrix*refimg_edge_matrix';
[pca_mat,pca_eigenvalue] = eigs(edge_vec_covariance,no_of_components);
clear edge_vec_covariance
% 

%Find the coefficient matrix for the superposition of ref image vectors%
coeff_matrix = zeros(num_images,num_images);
parfor ii = 1:1:no_of_components
    coeff_matrix(:,ii) = mldivide(refimg_edge_matrix,pca_mat(:,ii));  
end
clear refimg_edge_matrix
%
 %Form images corresponding to the principal components%
pca_img_matrix = zeros(size(A(p3(1):p4(1),p3(2):p4(2)),1),size(A(p3(1):p4(1),p3(2):p4(2)),2),no_of_components);
parfor ii = 1:1:no_of_components
    for jj = 1:1:num_images
        pca_img_matrix(:,:,ii) = pca_img_matrix(:,:,ii) + coeff_matrix(jj,ii)*refimg_matrix(:,:,jj);
    end
end
clear refimg_matrix
%
 %Make the ideal background image;
B_ideal = zeros(ydim,xdim);
for ii = 1:1:no_of_components
    w0 = A_reshaped'*pca_mat(:,ii);
    B_ideal = B_ideal + w0*pca_img_matrix(:,:,ii);
end
B_ideal = B_ideal + A_mean;
Ab_ideal = log(B_ideal./A(p3(1):p4(1),p3(2):p4(2)));
 

Ab = Ab(p3(1):p4(1),p3(2):p4(2));
Ab_ideal = Ab_ideal;
clims = [-0.05 0.05];
subplot(2,2,1), imagesc(Ab,clims)
colorbar
subplot(2,2,2), imagesc(Ab_ideal,clims)
colorbar



function vec_reshaped = make_edge_vector(Img,p1,p2,width)

p3 = p1 - width;
p4 = p2 + width;

%This function takes the image array and create a vector from the edge area.
img1 = Img(p3(1):p1(1),p3(2):p4(2));
img2 = Img(p1(1):p2(1),p3(2):p1(2));
img3 = Img(p1(1):p2(1),p2(2):p4(2));
img4 = Img(p2(1):p4(1),p3(2):p4(2));

xdim1 = size(img1,2);
ydim1 = size(img1,1);
xdim2 = size(img2,2);
ydim2 = size(img2,1);

vec1 = double(reshape(img1,xdim1*ydim1,1));
vec2 = double(reshape(img2,xdim2*ydim2,1));
vec3 = double(reshape(img3,xdim2*ydim2,1));
vec4 = double(reshape(img4,xdim1*ydim1,1));
vec_reshaped = cat(1,vec1,vec2,vec3,vec4);
end
