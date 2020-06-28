function centroids = computeCentroids(X, idx, K)
%  COMPUTECENTROIDS returns the new centroids by computing the means of the 
%  data points assigned to each centroid.
%  centroids = COMPUTECENTROIDS(X, idx, K) returns the new centroids by 
%  computing the means of the data points assigned to each centroid. It is
%  given a dataset X where each row is a single data point, a vector idx of
%  centroid assignments (i.e. each entry in range [1..K]) for each example,
%  and K, the number of centroids. Also returns a matrix centroids, where
%  each row of centroids is the mean of the data points assigned to it.

[~,n] = size(X);

centroids = zeros(K, n);

% Go over every centroid and compute mean of all points that belong to it.
% Concretely, the row vector centroids(i, :) contains the mean of the data
% points assigned to centroid i.

for ii = 1:K
    logicalArr = (idx==ii);
    centroids(ii,:) = sum(X(logicalArr,:),1)/sum(logicalArr);
end

end