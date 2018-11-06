% remove_fringes_offline_sp2.m
% Removes fringes using the method in Caspar F. Ockeloen's masters thesis
% from Amsterdam. See section 2.2 of the thesis.
% The idea is to find a linear superposition of background probe shots for
% each shot with atoms in it to make the "best" background image to
% subtract from the atoms.


load configdata
load maindata

A_fm = A(fmp1(2):fmp2(2),fmp1(1):fmp2(1));

pp1 = p1 - fmp1 + 1;
pp2 = fmp2 - p2 + 1;

% Background mask
bgmask = ones(size(A_fm));
bgmask(pp1(2):pp2(2),pp1(1):pp2(1)) = 0;

fmxdim = size(A_fm,2);
fmydim = size(A_fm,1);

%% Collect backround images
num_images = length(ref_img_array1)+1;
refimg_matrix = zeros(fmydim,fmxdim,num_images);
refimg = B(fmp1(2):fmp2(2),fmp1(1):fmp2(1));
refimg_matrix(:,:,1) = refimg;
jj = 1;
% Loop through reference images and store them in a matrix
for ii = ref_img_array1
    jj = jj + 1;
    filename_refb = ['b' filename_chopped num2str(ii) '.asc'];
    refimg = loadascii([dir_path filename_refb]);
    refimg = rot90(refimg,numrotations_sp2);  
    refimg_matrix(:,:,jj) = refimg(fmp1(2):fmp2(2),fmp1(1):fmp2(1));  
end

ref_reshaped = double(reshape(refimg_matrix,fmxdim*fmydim,num_images));
A_reshaped = double(reshape(A_fm,fmxdim*fmydim,1));

optrefimages = zeros(size(A_fm));

% load([FRmask_pathname_sp2 FRmask_filename_sp2]);    % presumably the mask is saved as "bgmask" in the .mat file

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
