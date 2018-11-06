function mask = nonmaxsupp3x3(im)
[h w] = size(im); mask = false([h w]); % binary output image
skip = false(h,2); cur = 1; next = 2; % scanline masks
for c=2:w-1
r = 2;
while r<h
if skip(r,cur), r=r+1; continue; end % skip current pixel
if im(r,c)<=im(r+1,c) % compare to pixel on the left
r=r+1;
while r<h && im(r,c)<=im(r+1,c), r=r+1; end % rising
if r==h, break; end % reach scanline's local maximum
else % compare to pixel on the right
if im(r,c)<=im(r-1,c), r=r+1; continue; end
end
skip(r+1,cur) = 1; % skip next pixel in the scanline
% compare to 3 future then 3 past neighbors
if im(r,c)<=im(r-1,c+1), r=r+1; continue; end
skip(r-1,next) = 1; % skip future neighbors only
if im(r,c)<=im(r ,c+1), r=r+1; continue; end
skip(r ,next) = 1;
if im(r,c)<=im(r+1,c+1), r=r+1; continue; end
skip(r+1,next) = 1;
if im(r,c)<=im(r-1,c-1), r=r+1; continue; end
if im(r,c)<=im(r ,c-1), r=r+1; continue; end
if im(r,c)<=im(r+1,c-1), r=r+1; continue; end
mask(r,c) = 1; r=r+1; % a new local maximum is found
end
tmp = cur; cur = next; next = tmp; % swap mask indices
skip(:,next) = 0; % reset next scanline mask
end
