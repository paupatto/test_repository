%Nano_analysis_auto.m
close all;
clc;
clear;

% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% users should change only this part. Do not change anything else 
% without consulting Paul Patton
% specify a file prefix that will be shared in common by an image file
% and the associated Matlab data file and excel spreadsheet.

% full path
% the full path that leads to the folders containing the analysis materials
path=...
   sprintf('M:/prime working folder/Yan Yu MATLAB Project/Skrabalak software/');
% path=...
%     sprintf('G:/Skrabalak software/');

% excel write
% write output to excel file no (0) yes (1)
excel_make=1;

% file prefix
% nano_info.file_prefix=sprintf('6-24-15_test1');
% nano_info.file_prefix=sprintf('EH_96I_B_1');
nano_info.file_prefix=sprintf('test_file');

% calibration
% calibration- length of scale bar in nanometers
nano_info.scalebar_length=100;

% image file
% image file to be analysed
% image_file=sprintf('%sImage_files/test_image1', path);
% nano_info.image_file=sprintf('%s_image', nano_info.file_prefix);
nano_info.image_file=sprintf('test_pattern1');
% image_path=sprintf('%s/Image_files/', path);
image_path=sprintf('');
% Matlab data file name
% datafile to be created or modified
nano_info.matdata_file=...
    sprintf('%s_matfile3', nano_info.file_prefix);
matdata_path=...
    sprintf('%s/Matdat_files/', path);

% Excel file name
% excel file to be created
nano_info.excel_file=...
    sprintf('%s_excelfile2', nano_info.file_prefix);
excel_path=sprintf('%sExcel_files/', path);

%offset
% how far should numbers be offset from marks in the display
nano_info.offset=-30;

% object profile removal threshold
% remove object profiles with a smaller number of connected pixels than the
% stated threshold given in nanometers (1 nm^2 is roughly 73 pixels)
nano_info.too_small=1;
% remove objects with area in nanometers larger than specified
% figure
% nano_info.too_big=144;
nano_info.too_big=100000;
% remove centroids that are too close to another centroid, distance in
% nanometers
nano_info.dist_crit=5;

% calibration- length of scale bar in nanometers
nano_info.scalebar_length=100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify a color to be used in graphs
gold=[1 0.8 0];

%%% display image for analysis
% transfer image from stored format to image array format
im_input=sprintf('%s%s', image_path, nano_info.image_file);
nano_im=imread(im_input, 'jpg');
% display image as figure
figure(1);
set(gcf, 'Units', 'inches', 'Position', [0.25 0.25 9 9]);
set(gcf, 'PaperOrientation', 'portrait');
set(gcf, 'PaperPosition', [-0.25 1 9 9]);
imshow(nano_im);
hold on;
fprintf('Nano_analysis_auto\n by Paul Patton 2015\n\n');

%%% calibration of image pixels per nanometer
nano_info=calibrate_image(nano_info);

%%% image analysis
% convert to greylevel image
x_im=nano_im(:,:,1);
% adjust contrast
x_im=imadjust(x_im, [0.1 0.7], [0 1]);
% sharpen
% x_im=imsharpen(x_im, 'Radius', 15, 'Amount', 3);
% determine threshold level for creating binary image
level=graythresh(x_im);
% create binary image
testx=im2bw(x_im, level);
% invert binary image
itestx=~testx;
% itestx=testx;
% remove object profiles below size threshold
rem_thresh=round(nano_info.too_small/(nano_info.cal_const^2));
itestx=bwareaopen(itestx, rem_thresh);
% perform morphological closing operation to smooth object boundaries
itestx=bwmorph(itestx, 'close');
% fills holes in object profiles
itestx=imfill(itestx, 'holes');
% segment image into bounded object profiles
[objs, num]=bwlabel(itestx,4);

%%% compute properties of identified profiles; centroid, area, and side
% length
[centroid, ct, obj_area, side_length]=profile_props(nano_info, num, objs);

% %%% distance prune
% ct2=0;
% keep_list=zeros(1,1);
% for xi=1:ct
%     dist_set=...
%         sqrt(((centroid(xi,1)-centroid(:,1)).^2)+...
%         ((centroid(xi,1)-centroid(:,1)).^2));
%         if~(0<sum((dist_set~=0)&(dist_set<nano_info.dist_crit)))
%             ct2=ct2+1;
%             keep_list(ct2)=xi;
%         end;
% end;
% % remove particles that are not on the keep list
% centroid=centroid(keep_list, 1:2);
% obj_area=obj_area(keep_list);
% side_length=side_length(keep_list);
% ct=ct2;

% plot and manual prune
[hp,ht]=plot_centroids(centroid, nano_info.offset, ct);
[nano_info, centroid, ct, obj_area, side_length]=...
    plot_and_prune(nano_info, centroid, ct, obj_area, side_length,...
    nano_info.offset, hp, ht);

% save results
% prepare variables
nano_particle=struct;
for xi=1:ct
    % create spaces for manual data
    nano_particle(xi).m_coord(1)=NaN;
    nano_particle(xi).m_coord(2)=NaN;
    nano_particle(xi).m_sides(1)=NaN;
    nano_particle(xi).m_sides(2)=NaN;
    % store automatic data
    % mode of analysis manual (1), automatic (2)
    nano_particle(xi).anal=2;
    nano_particle(xi).cent=[centroid(xi,1) centroid(xi,2)];
    nano_particle(xi).area=obj_area(xi);
    nano_particle(xi).side_length=side_length(xi);
end;
nano_info.cnt=ct;

%%% save data to matlab data file
% save data and report success
mat_output=sprintf('%s%s', matdata_path, nano_info.matdata_file);
ex_output=sprintf('%s%s', excel_path, nano_info.excel_file);
% clear data that would clutter matlab datafile
clear cnt matdata_path excel_path image_path im_input exists path;
% clear centroid obj_area side_length;
save(mat_output);
fprintf('\n%s has been saved\n', nano_info.matdata_file);

%%% save data to excel spreadsheet
if excel_make==1
     excel_out(nano_info, nano_particle, ex_output);
    fprintf('\n%s has been saved\n', nano_info.excel_file);
end;

