function [nano_info, centroid, ct, obj_area, side_length]= ...
    plot_and_prune(nano_info, centroid, ct, obj_area, side_length, offset, hp, ht)
% this function plots and indexes all centroids identified and allows the
% user to manually remove erroneous identifications
gold=[1 0.8 0];
nx1=0;
while nx1==0
    %%% Manual pruning
    xt=0;
    removal=zeros(1,1);
    keep_list=1:ct;
    while xt==0;
        prune=...
            input('\ndo you want to prune bad identifications? (0) no, (1) yes\n');
        ctr=0;
        if prune==1
            xt=0;
            fprintf('Enter the nanoparticle index you would like to remove\n');
            fprintf('when you are finished, enter 0\n');
            while xt==0;
                ctr=ctr+1;
                removal(ctr)=input('\nindex:');
                if removal(ctr)==0
                    ctr=ctr-1;
                    xt=1;
                end;
            end;
        elseif prune==0
            xt=1;
            nx1=1;
        else
            insult_user;
            fprintf('enter 0 or 1 only');
        end;
    end;
    % remove plotted centroids and numbers
    if (ctr>0)&&(prune==1)
        for xi=1:ct
            delete(hp(xi));
            delete(ht(xi));
        end;
        % generate keep list
        for xi=1:size(removal,2)
            keep_list=keep_list(keep_list~=removal(xi));
        end;
        % remove particles that are not on the keep list
        centroid=centroid(keep_list, 1:2);
        obj_area=obj_area(keep_list);
        side_length=side_length(keep_list);
        ct=ct-size(removal,2)+1;
    end;
    [hp, ht]=plot_centroids(centroid, offset, ct);
end;
end

