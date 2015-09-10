% preadjust.m
% this script allows contrast preadjustment for automatic image analysis
%    sprintf('M:/prime working folder/Yan Yu MATLAB Project/Skrabalak software/');
path=...
    sprintf('G:/Skrabalak software/');

%%% display image for analysis
% image file
% image file to be analysed
% image_file=sprintf('%sImage_files/test_image1', path);
nano_info.image_file=sprintf('%s_image', nano_info.file_prefix);
image_path=sprintf('%s/Image_files/', path);

% transfer image from stored format to image array format
im_input=sprintf('%s%s', image_path, nano_info.image_file);
nano_im=imread(im_input, 'jpg');
% display image as figure
figure(1);
set(gcf, 'Units', 'inches', 'Position', [0.25 0.25 9 9]);
set(gcf, 'PaperOrientation', 'portrait');
set(gcf, 'PaperPosition', [-0.25 1 9 9]);
x_im=nano_im(:,:,1);
x_im=imadjust(x_im, [0.1 0.7], [0 1]);
x_im=imsharpen(x_im, 'Radius', 15, 'Amount', 3.0);
nano_info.cal_const=0.1176;
imshow(x_im);
fprintf('\npause here\n');
pause;
fprintf('continue\n');
%%% image analysis
% identify object profiles in image 
level=graythresh(x_im);
% create binary image
testx=im2bw(x_im, level);
% invert binary image
itestx=~testx;
% remove object profiles below size threshold
rem_thresh=round(too_small/(nano_info.cal_const^2));
itestx=bwareaopen(itestx, rem_thresh);
% perform morphological closing operation to smooth object boundaries
itestx=bwmorph(itestx, 'close');
% fills holes in object profiles
itestx=imfill(itestx, 'holes');
h=imshow(itestx);

% imcontrast(h);
