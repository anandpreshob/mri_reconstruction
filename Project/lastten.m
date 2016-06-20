img =mri(:,:,48);
img=img.*(img>100);
seedmask1=seed(125,159,img,100,120);
seedmask2=seed(136,157,img,100,200);
seedmask=seedmask1+seedmask2;
% se=strel('square',3);
% seedmask=imdilate(seedmask,se);
% seg_img(:,:,i)=img.*(seedmask>1);