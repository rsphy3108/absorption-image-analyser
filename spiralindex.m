function [r,c] = spiralindex(n)
r = 0; c = 0; run = 0;
for ii=1:n
run = run+1;
dr=-1; dc= 0;
for jj=1:run, r = [r; r(end)+dr]; c = [c; c(end)+dc]; end
dr= 0; dc= 1;
for jj=1:run, r = [r; r(end)+dr]; c = [c; c(end)+dc]; end
run = run+1;
dr= 1; dc= 0;
for jj=1:run, r = [r; r(end)+dr]; c = [c; c(end)+dc]; end
dr= 0; dc=-1;
for jj=1:run, r = [r; r(end)+dr]; c = [c; c(end)+dc]; end
end
dr=-1; dc= 0;
for jj=1:run, r = [r; r(end)+dr]; c = [c; c(end)+dc]; end