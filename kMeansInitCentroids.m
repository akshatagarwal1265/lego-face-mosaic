function centroids = kMeansInitCentroids(X, K)
%  KMEANSINITCENTROIDS This function initializes K centroids that are to be 
%  used in K-Means on the dataset X
%  centroids = KMEANSINITCENTROIDS(X, K) returns K initial centroids to be
%  used with the K-Means on the dataset X

%  When using K-Means, its important to initialize the centroids randomly.
%  Also note that all the initially assigned centroids should be unique.

%  Unique points are taken to avoid duplicate centroids.
X = unique(X,'rows');

if(size(X,1)<K)
    error('***** Number of unique colors less than %d *****',K);
end

randidx = randperm(size(X,1));
centroids = X(randidx(1:K),:);
        
end