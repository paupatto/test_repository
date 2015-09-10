% gather calibration measurement from image
function [nano_info]=calibrate_image(nano_info)
    fprintf('Image calibration\n');
    fprintf('Position the image and then enter when ready\n');
    pause;
    fprintf('click on both ends of the calibration scalebar\n');
    check=0;
    cal_x=zeros(1,2);
    cal_y=zeros(1,2);
    while check==0;
        for xi=1:2
            [cal_x(xi), cal_y(xi)]=ginput(1);
            plot(cal_x(xi), cal_y(xi), 'x', 'MarkerSize', 10,...
                'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g',...
            'LineWidth',2);
        end;
        acc=input('accept calibration - no(0), yes(1)');
        if acc==1
            check=1;
        elseif acc==0
            fprintf('\nredo calibration\n');
        else
            insult_user;
            fprintf('\nenter 0 or 1\n');
        end;
    end;
    % compute calibration constant nm per pixel
    dist_pix=(sqrt(((cal_x(2)-cal_x(1))^2)+((cal_y(2)-cal_y(1))^2)));
    nano_info.cal_const=nano_info.scalebar_length/dist_pix;
end