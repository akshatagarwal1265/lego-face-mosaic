function [newCentroidsNorm, newCentroidsScaled] = mapCentroidsToColors(centroids, K)
%  MAPCENTROIDSTOCOLORS - In this part, we map the K centroids to the
%  pre-selected colors. This is done on the basis of the spatial distance
%  of the Centroid to the Color.
%  returns - newCentroidsNorm which has centroids mapped as colors but in
%  range (0-1), newCentroidsScaled which has centroids mapped as colors but
%  in range (0-255).

colorsScaled = colorsUsed(K);
colorsNorm = double(colorsScaled)/255;

newCentroidsNorm = centroids;
newCentroidsScaled = centroids;

for ii = 1:K
    distances = (colorsNorm(ii,:)-centroids).^2;
    [~,nearestColorId] = min(sum(distances,2));
    newCentroidsNorm(nearestColorId,:) = colorsNorm(ii,:);
    newCentroidsScaled(nearestColorId,:) = colorsScaled(ii,:);
    
    %  This centroid is made [3,3,3] to make it spatially far away (since
    %  the rest of the points are in the range 0-1), so that all the K
    %  pre-selected colors get assigned as K centroids.
    centroids(nearestColorId,:)=[3,3,3];
end

end