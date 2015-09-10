function [centroid, ct, obj_area, side_length]=...
    profile_props(nano_info, num, objs)
% this function finds the centroid, area, and side length of each
% nanoparticle profile identified
% allocate array variables
centroid=zeros(num,2);
ct=0;
obj_area=zeros(num,1);
side_length=zeros(num,1);
keep_list=zeros(1,1);
for xi=1:num
    fprintf('centroids %i of %i done\n', xi, num);
    % find particle centroids
    [yval, xval]=find(objs==xi);
    centroid(xi, 1)=mean(xval);
    centroid(xi, 2)=mean(yval);
    % area
    obj_area(xi)=bwarea(objs==xi)*(nano_info.cal_const^2);
    % side length
    side_length(xi)=sqrt(obj_area(xi));
    if obj_area(xi)<nano_info.too_big
        ct=ct+1;
        keep_list(ct)=xi;
    end;
end;
% remove particles that are larger than upper size limit
centroid=centroid(keep_list, 1:2);
obj_area=obj_area(keep_list);
side_length=side_length(keep_list);
end

