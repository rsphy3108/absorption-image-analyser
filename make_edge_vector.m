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