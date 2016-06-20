% Better 3D Imaging for the segemnted part of the brain
% We have approached in a different way of segmentation in this case
% As this method does not hold good for segmenting both brain and tumor
% tissue in all the slices, we have not used this in the main project code
clc
clear all
close all

%% Loading MRI slices
FileFolder=fullfile(pwd,'Project');
files=dir(fullfile(FileFolder,'*.dcm'));
fileNames={files.name};
mri=zeros(256,256,length(files));
for i=1: length(files)
    mri(:,:,i)=dicomread(fileNames{i});
end

%% Thresholding and Segmentation
%% Slices 1-9
for i=1:9
img =mri(:,:,i);
img=img.*(img>150);
x=117;y=170;
seedmask=seed(x,y,img,50,50);
seg_img(:,:,i)=img.*(seedmask>1);
end
%% Slices 10-13
for i=10:13
img =mri(:,:,i);
img=img.*(img>150);
x=117;y=170;
seedmask1=seed(x,y,img,50,50);
seedmask2=seed(145,187,img,50,50);
seedmask=seedmask1+seedmask2;
seg_img(:,:,i)=img.*(seedmask>1);
end
%% Slices 14-21
for i=14:21
img =mri(:,:,i);
img=img.*(img>150);
seedmask1=seed(117,170,img,50,50);
seedmask2=seed(145,187,img,50,50);
seedmask3=seed(155,133,img,50,50);
seedmask=(seedmask1+seedmask2+seedmask3)/3;
seg_img(:,:,i)=img.*(seedmask>1);
end
%% Slices 22-44
for i=22:44
img =mri(:,:,i);
img=img.*(img>150);
seedmask1=seed(135,98,img,50,50);
seedmask2=seed(108,122,img,50,50);
seedmask3=seed(150,133,img,50,50);
seedmask=(seedmask1+seedmask2+seedmask3)/3;
seg_img(:,:,i)=img.*(seedmask>1);
end
%% Slices 44-55
for i=44:55
img =mri(:,:,i);
img=img.*(img>100);
seedmask1=seed(125,159,img,100,120);
seedmask2=seed(136,157,img,100,100);
seedmask=seedmask1+seedmask2;
seg_img(:,:,i)=img.*(seedmask>1);
end

%% 3D Isosurface rendering
figure
colormap(gray)
Ds = smooth3(seg_img(:,:,1:48));
hiso = patch(isosurface(Ds,5),'FaceColor',[0.5 0.5 0.5],'EdgeColor','none');
isonormals(Ds,hiso)
hcap = patch(isocaps(Ds,10),'FaceColor','interp','EdgeColor','none');
view(35,30) 
axis tight 
daspect([1,1,.4])
lightangle(45,30);
lighting gouraud
hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0.4;
hiso.SpecularExponent = 50;