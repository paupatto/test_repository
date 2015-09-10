%distance_line2.m
% given a line defined by its slope and intercept and a point on that line,
% this script finds two points that are at a specified distance from from
% the point along the line.  The special cases of a vertical and a
% horizontal line are included.

function out_pt=...
    distance_line(slope, x_intercept, y_intercept, dist, x_coord, y_coord)
if slope==0
    %%% horizontal line
    out_pt(1,1:2)=[x_coord+dist y_intercept];
    out_pt(2,1:2)=[x_coord-dist y_intercept];
elseif isinf(slope)
    %%% vertical line
    out_pt(1,1:2)=[x_intercept y_coord+dist];
    out_pt(2,1:2)=[x_intercept y_coord-dist];
else
    if y_coord~=0,
        %%% any other orientation
        rho1=polcor_vec(x_intercept-x_coord, 0-y_coord);
        rho2=rho1+180;
        if rho2>360
            rho2=rho2-360;
        end;
        [out_pt(1,1) out_pt(1,2)]=cartcor_vec(dist, rho1);
        [out_pt(2,1) out_pt(2,2)]=cartcor_vec(dist, rho2);
        out_pt=out_pt+[x_coord y_coord; x_coord y_coord];
    else
        %%% any other orientation
        rho1=polcor_vec(((1-y_intercept)/slope)-x_coord, 1-y_coord);
        rho2=rho1+180;
        if rho2>360
            rho2=rho2-360;
        end;
        [out_pt(1,1) out_pt(1,2)]=cartcor_vec(dist, rho1);
        [out_pt(2,1) out_pt(2,2)]=cartcor_vec(dist, rho2);
        out_pt=out_pt+[x_coord y_coord; x_coord y_coord];
    end;
end;
end
