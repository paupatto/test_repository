% find_centroid.m
function find_centroid
gold=[1 0.8 0];
load objs_holder;
image_file=sprintf('EH_96I_B_1testimage');
nano_im=imread(image_file, 'jpg');
imshow(nano_im);
hold on;
centroid=zeros(num,2);
for xi=1:100
    fprintf('working %i of %i done\n', xi, num);
    [yval, xval]=find(objs==xi);
    centroid(xi, 1)=mean(xval);
    centroid(xi, 2)=mean(yval);
    if xi==7
        xcol=[0 0 1];
    else
        xcol=[0 1 0];
    end;
    plot(xval, yval, '.', 'MarkerSize', 1,...
    'MarkerFaceColor', xcol, 'MarkerEdgeColor', xcol);
    plot(centroid(xi,1), centroid(xi,2), '.', 'MarkerSize', 10,...
    'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    pause;
end;
end

