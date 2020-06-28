%% SCRIPT
% = RESIZE AT THE START

%%

clear; close all; clc;

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
X = imread(FullName);

% figure(1);
% subplot(2, 3, 1);
% imshow(X)
% title('Original');

clear FileName PathName FullName msg

%%

Z = imresize(X,[48,48]);

figure(1);
subplot(2, 3, 1);
imshow(Z)
title('48x48 Resized');

%% Contrast Stretching

A = imadjust(Z,stretchlim(Z),[]);

figure(1);
subplot(2, 3, 2);
imshow(A)
title('Contrast Stretched');

%% Adaptive Histogram Equalization

I = rgb2gray(A);
figure(1);
subplot(2, 3, 3);
imshow(I)
title('Non Histogram Equalized');

figure(2);
imhist(I)
title('Histogram Before Equalization');

J = adapthisteq(I);

figure(1);
subplot(2, 3, 4);
imshow(J)
title('Histogram Equalized');

figure(3);
imhist(J)
title('Histogram After Equalization');

%%

IndexedMap = ([[0,0,0]; [105,105,105]; [211,211,211]; [255,255,0]; [255,255,255]])/255;
% 0-black, 105-dimgrey, 211-lightgrey, 226-yellow, 255-white

%%

I(I<=53) = 0;
I(I>=54 & I<=162) = 1;
I(I>=163 & I<=219) = 2;
I(I>=220 & I<=241) = 3;
I(I>=242) = 4;

figure(1);
subplot(2, 3, 5);
imshow(I,IndexedMap)
title('Non Histogram Equalized');

%%

J(J<=53) = 0;
J(J>=54 & J<=162) = 1;
J(J>=163 & J<=219) = 2;
J(J>=220 & J<=241) = 3;
J(J>=242) = 4;

figure(1);
subplot(2, 3, 6);
imshow(J,IndexedMap)
title('Histogram Equalized');
