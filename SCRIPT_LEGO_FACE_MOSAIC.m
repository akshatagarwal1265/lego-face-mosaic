%% Requisites
%  = Input Pic Must Have >= K Unique Colors (K= No. of Pre-Selected Colors)
%  = Input Face must have Yellowish Background.

%% Initialization
clear; close all; clc;

%% ========== Part 1: Load Image ==========================================

%  Getting Acceptable Image File from User Via Dialog Box
[FileName,PathName]=uigetfile({'*.jpg;*.jpeg;*.png','Acceptable Types'},...
    'Select the "jpg", "jpeg" or "png" file to be used:');
FullName=fullfile(PathName,FileName);
if isequal(FileName,0)
    msg = '***** Selection Cancelled *****';
    error(msg);
else
    disp(FullName)
end

%  Load an image
A = imread(FullName);

clear FileName PathName FullName msg

%% ========== Part 2: Pre-Process Image ===================================

%  OPTIONAL
A = imsharpen(A);

%% ========== Part 3: Preparation for K-Means =============================
%  We use K-Means to compress an image. To do this, we will first run 
%  K-Means on the colors of the pixels in the image and then we will
%  map each pixel onto its closest centroid.

A = double(A);

%  Divide by 255 so that all values are in the range 0 - 1
%  A -> normalized double image matrix
A = A / 255;

%  Size of the image
img_size = size(A);

%  Reshape the image into an Nx3 matrix where N = number of pixels.
%  Each row will contain the Red, Green and Blue pixel values.
%  This gives us our dataset matrix X that we will use K-Means on.
X = reshape(A, img_size(1) * img_size(2), 3);

%  Run our K-Means algorithm on this data
%  We can try different values of max_iters here
%  K is the number of colors to be used
%  max_iters is the maximum number of iterations
K = 5; 
max_iters = 10;

%% ========== Part 4: Initialization of Centroids =========================

%  2 approaches have been used:

%  Approach 1 - Close to pre-selected Color (initial_centroids_colors)
%  Below is a method to initialize the centroids as close as possible to
%  the pre-selected K colors.
%  For this we find the pixel in the image closest to each Pre-Selected
%  color and assign it as a centroid, also keeping in mind that no 2
%  initialized centroids should be the same.

%  First we get the array of pre-selected colors and normalize it
initial_centroids_colors = double(colorsUsed(K))/255;

%  Unique rows are taken so that no 2 pre-selected colors pick up the same
%  point as the closest pixel. Hence avoid duplicate centroids.
X_copy = unique(X,'rows');

for ii = 1:K
    %  Find distance of each image pixel to the (ii)th pre-selected color
    distances = (initial_centroids_colors(ii,:)-X_copy).^2;
    
    %  Find the index of the closest pixel to the (ii)th pre-selected color
    [~,nearestColorId] = min(sum(distances,2));
    
    %  Assign the closest pixel as the (ii)th centroid
    initial_centroids_colors(ii,:) = X_copy(nearestColorId,:);
    
    %  This closest pixel is made [3,3,3] to make it spatially far away
    %  (since the rest of the points are in the range 0-1), so that it does
    %  not get selected again. Hence avoiding duplicate centroids.
    X_copy(nearestColorId,:) = [3,3,3];
end

clear X_copy distances nearestColorId

%  Approach 2 - Randomized (initial_centroids_random)
initial_centroids_random = kMeansInitCentroids(X, K);

%% ========== Part 5: Sub-Plot the Original Image =========================
%  We are going to give the user an array of 6 options to chose from. 1
%  would be the result of 'Approach 1' initialization of centroids and 5
%  would be the result of 'Approach 2' initialization of centroids.

%  Display the original image 1st
figure(1);
subplot(2, 4, 1);
imagesc(A);
title('Original');

%% ========== Part 6: K-Means Image Compression ===========================
%  In this part, we will use the clusters of K-Means to compress an image.
%  To do this, we find the closest centroid for each point. After that we
%  assign each point to the cluster of its closest centroid. After this we
%  assign the mean of all the points in each cluster as the cluster
%  centroid.

%  Giving the user an array of 6 options.
for ii = 1:6

    %  Run K-Means - 1 time Approach1, 5 times Approach2
    if ii == 1
        [centroids, idx] = runkMeans(X, initial_centroids_colors, max_iters);
    else
        %  Refresh the random Centroids for the next use.
        initial_centroids_random = kMeansInitCentroids(X, K);
        
        [centroids, idx] = runkMeans(X, initial_centroids_random, max_iters);
    end

    [centroids,~] = mapCentroidsToColors(centroids, K);

    %  We can now recover the image from the indices (idx) by considering
    %  it as the indexed image with the centroids (normalized) as the
    %  colormap
    
    %  IndexedImage is a class 'double' array and idx has range 1-K, Hence
    %  acting as an Indexed Image
    IndexedImage = reshape(idx, img_size(1), img_size(2), 1);
    
    %  centroids -> normalized pre-selected colors assigned as centroids,
    %  Hence acting as the Indexed Image Colormap
    IndexedMap = centroids;
    
    %  This reduces the size of the compressed image to 48x48 pizels (Which
    %  is the size of the LEGO board)
    %  The returned IndexedImage is class 'uint8'
    [IndexedImage,IndexedMap] = imresize(IndexedImage,IndexedMap,[48,48],'Colormap','original');
    
    X_recovered = uint8(ind2rgb(IndexedImage,IndexedMap)*255);

    %  Display options as sub-plots
    figure(1);
    subplot(2, 4, ii+2);
    
    X_recovered=uint8(X_recovered);
    
    imshow(X_recovered);
    
    if ii==1
        title(sprintf('COLORS INIT'));
        imwrite(X_recovered,'SAMPLE_OUTPUT_IM_COLORS.png');
    else
        title(sprintf('RANDOM INIT'));
        imwrite(X_recovered,sprintf('SAMPLE_OUTPUT_IM_RANDOM_%d.png',(ii-1)));
    end

end