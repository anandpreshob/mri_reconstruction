%Matlab Final Take Home Project
%Anand and Hemanth

clc
clear all
close all

%% Loading MRI slices
FileFolder=fullfile(pwd,'Project');
files=dir(fullfile(FileFolder,'*.dcm'));
fileNames={files.name};
mri=zeros(256,256,length(files));

%% Creating Montage view
for i=1: length(files)
    mri(:,:,i)=dicomread(fileNames{i});
end
new=reshape(mri,[256 256 1 length(files)]);
montage(new,'DisplayRange',[],'Size', [5 11])
title('Montage view of Slices')

%% Thresholding and Segmentation using Region Growing
for i=1:length(files)
img =mri(:,:,i);
img=img.*(img>150);
% Finding the starting seed
%imagesc(img),colormap(gray)
%[x,y]=ginput(1);
%x=round(x);y=round(y);
x=134;y=140;
% seed(x,y,img,rmin,rmax) is a user defined function for region growing
seedmask=seed(x,y,img,50,340);
se=strel('square',2);
seedmask=imdilate(seedmask,se);
seg_img(:,:,i)=img.*(seedmask>1);

%% Tumour segmentation
% Finding the seed for tumour
%imagesc(seg_img),colormap(gray)
%[x,y]=ginput(1);
%x=round(x);y=round(y);
x=174;y=153;
tumourmask=seed(x,y,img,100,150);
se=strel('square',2);
tumourmask=imopen(tumourmask,se);
tumour_img(:,:,i)=img.*(tumourmask>1);
end
%% Displaying Segmented Image and Tumor
figure
imagesc(seg_img(:,:,32)),colormap(gray),title('Segmented Brain image')
figure
imagesc(tumour_img(:,:,32)),colormap(gray),title('Tumor segemented image')
%% Contour Slice
figure
contourslice(seg_img,[],[],32),title('Contour of the segmented image')
%% 3D Isosurface rendering of Segmented brain tissue
figure
colormap(gray)
Ds = smooth3(seg_img(:,:,1:48));
hiso = patch(isosurface(Ds,5),'FaceColor','r','EdgeColor','none');
title('Segmented brain in 3D')
isonormals(Ds,hiso)
hcap = patch(isocaps(Ds,10),'FaceColor','interp','EdgeColor','none');
view(35,30) 
axis tight 
daspect([1,1,.4])
lightangle(45,30);
lighting gouraud
hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;
%% 3D Rendering of tumour tissue
figure
colormap(gray)
Ts= smooth3(tumour_img(:,:,32:47));
% Ds = smooth3(seg_img(:,:,1:48));
bs=isosurface(Ts,5);
hiso = patch(bs,'FaceColor',[1,.75,.65],'EdgeColor','none');
isonormals(Ts,hiso),title('Segmented tumor tissue')
hcap = patch(isocaps(Ts,10),'FaceColor','interp','EdgeColor','none');
view(35,30) 
axis tight 
daspect([1,1,.4])
lightangle(45,45);
lighting gouraud
hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;
%% Montage of the segmented brain image
figure
new_seg=reshape(seg_img,[256 256 1 length(files)]);
montage(new_seg,'DisplayRange',[],'Size', [5 11])
title('Montage of segmented images')
%% Montage of the tumor
figure
new_tum=reshape(tumour_img,[256 256 1 length(files)]);
montage(new_tum,'DisplayRange',[],'Size', [5 11])
title('Montage of segmented tumor')

%% References
% 1)http://www.mathworks.com/help/matlab/visualize/techniques-for-visualizing-scalar-volume-data.html?refresh=true
% 2)http://www.mathworks.com/videos/medical-image-processing-with-matlab-81890.html