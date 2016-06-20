for i=1:length(files)
img =mri(:,:,i);
dmri(:,:,i)=img.*(img>150);
end
%% 3D Isosurface rendering
figure
colormap(gray)
Ds = smooth3(seg_img(:,:,1:48));
hiso = patch(isosurface(Ds,5),...
   'FaceColor',[1,.75,.65],...
   'EdgeColor','none');
   isonormals(Ds,hiso)
hcap = patch(isocaps(Ds,10),...
'FaceColor','interp',...
'EdgeColor','none');
view(35,30) 
axis tight 
daspect([1,1,.4])
lightangle(45,45);
lighting gouraud
hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;