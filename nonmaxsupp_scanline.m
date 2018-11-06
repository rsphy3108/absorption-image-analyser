function mask = nonmaxsupp_scanline(im,n)
[h w] = size(im); mask = false([h w]); % binary output image
scanline = zeros(h,1); skip = false(h,1); % scanline mask
[dr,dc] = spiralindex(n); % index neighborhood in a spiral path
I = find(dc~=0); dr = dr(I); dc = dc(I); % skip current line
for c=n+1:w-n
scanline = im(:,c); skip(:) = false; % current scanline
resp = [0; diff(sign(diff(scanline))); 0]; % discrete Hessian
peaks = find(resp(n+1:end-n)==-2) + n; % peak indices
for ii=1:length(peaks)
r = peaks(ii);
if skip(r), continue; end % skip current pixel
curPix = scanline(r); whoops = false;
for jj=r+1:r+n, if resp(jj)~=0, break; end; end; %downhill
for jj=jj:r+n
if curPix <= scanline(jj), whoops=true; break; end
skip(jj) = 1; % skip future pixels if < current one
end
if whoops, continue; end % skip to next scanline peak
for jj=r-1:-1:r-n, if resp(jj)~=0, break; end; end;
for jj=jj:-1:r-n
if curPix <= scanline(jj), whoops=true; break; end
end
if whoops, continue; end % skip to next scanline peak
% if reach here, current pixel is a (2n+1)?maximum
for jj=1:length(I) % visit neighborhood in spiral order
if im(r,c)<=im(r+dr(jj),c+dc(jj)), break; end
end
if jj>=length(I) && im(r,c)>im(r+dr(jj),c+dc(jj))
mask(r,c) = 1; % a new (2n+1)x(2n+1)?maximum is found
end
end
end

