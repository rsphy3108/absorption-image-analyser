function mask = nonmaxsupp_quarterblock(im,n)
[h w] = size(im); mask = false([h w]); m = floor((n+1)/2);
hh = floor(h/m); % hh x ww = number of m x m blocks,
ww = floor(w/m); % starting from (m,m) offset
%% vectorised code to compute local maxima of m?by?m blocks
val = im(1:hh*m,1:ww*m);
[val,R] = max(reshape(val,[m hh*ww*m]),[],1);
val = reshape(reshape(val,[hh ww*m])',[m ww hh]);
R = reshape(reshape(R ,[hh ww*m])',[m ww*hh]); % row indices &
[val,C] = max(val,[],1); % column indices of local maxima
R = reshape(R(sub2ind([m ww*hh],C(:)',1:ww*hh)),[ww hh])';
val = squeeze(val)'; C = squeeze(C)';
%% compare each candidate to its (2n+1)x(2n+1) neighborhood
mask0 = nonmaxsupp3x3(val); % local maxima of block max image
for I = find(mask0)'
[ii,jj] = ind2sub([hh ww],I);
r = (ii-1)*m + R(ii,jj);
c = (jj-1)*m + C(ii,jj);
if r<=n || c<=n || r>h-n || c>w-n, continue; end % out of bound
% compare to full (2n+1)x(2n+1) block for code simplicity
if sumsqr(im(r+(-n:n),c+(-n:n))>=val(ii,jj))==1,
mask(r,c) = 1; % a new (2n+1)x(2n+1)?maximum is found
end
end