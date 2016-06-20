function seedmask=seed(x,y,img,rmin,rmax)
seedmask=zeros(size(img));
seedmask(x,y)=64;
seedintensity=img(x,y);
seedrangemin=seedintensity-rmin;
if seedrangemin < 0
seedrangemin = 0;
end
seedrangemax=seedintensity+rmax;
if seedrangemax > 666
seedrangemax = 666;
end
oldseeds = 1;
newseeds = 0;
while newseeds ~= oldseeds;
oldseeds = newseeds;
newseeds = 0;
for i = 2:253
for j = 2:253
if seedmask(i,j) > 0
intens=img((i-1),j);
if (intens >= seedrangemin) & (intens <= seedrangemax)
newseeds = newseeds + 1;
seedmask((i-1),j) = 64;
end
intens=img((i+1),j);
if (intens >= seedrangemin) & (intens <= seedrangemax)
newseeds = newseeds + 1;
seedmask((i+1),j) = 64;
end
intens=img(i,(j-1));
if (intens >= seedrangemin) & (intens <= seedrangemax)
newseeds = newseeds + 1;
seedmask(i,(j-1)) = 64;
end
intens=img(i,(j+1));
if (intens >= seedrangemin) & (intens <= seedrangemax)
newseeds = newseeds + 1;
seedmask(i,(j+1)) = 64;
end
end
end
end
end