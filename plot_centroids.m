function [hp,ht] = plot_centroids(centroid, offset, ct)
%%% plot results
    gold=[1 0.8 0];
    xcol=gold;
    hp=zeros(ct,1);
    ht=zeros(ct,1);
    for xi=1:ct
        hp(xi)=plot(centroid(xi,1), centroid(xi,2), '.', 'MarkerSize', 10,...
            'MarkerFaceColor', gold, 'MarkerEdgeColor', gold);
        numlab=sprintf('%i', xi);
        ht(xi)=text(centroid(xi,1)+offset, centroid(xi,2)+offset, numlab,...
            'FontName', 'Arial', 'FontSize', 9, 'Color', 'r');
    end;
end

