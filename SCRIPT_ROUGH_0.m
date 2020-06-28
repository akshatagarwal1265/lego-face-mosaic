%% 5 LEGO COLORS - RGB to Grayscale

clear; close all; clc;

% yellow = [255,255,0]; black = [0,0,0]; white = [255,255,255]; lightgrey = [211,211,211]; dimgrey = [105,105,105];

red = [255;0;255;211;105];
green = [255;0;255;211;105];
blue = [0;0;255;211;105];

a = uint8(cat(3,red,green,blue))
figure(1); subplot(1,2,1);
imshow(a)

b = rgb2gray(a)
figure(1); subplot(1,2,2);
imshow(b)
