%% Image To Text Art Converter
% BME 60B Sandbox Project
% Members: Leo Tian, Khendra Beth Hernandez, Jericho Celeste, Isabel Bueno

clc; clear; close all;

%% Part 1
% Convert the image of the dog to grayscale

% Read the image
img = imread('AHHHDog.jpg');

% Convert to grayscale
grayImg = rgb2gray(img);

% Normalize the brightness so every pixel is a brightness between 0-1 for
% easier mapping latter
grayImg = double(grayImg) / 255;

% Show the original image
figure;

subplot(1,3,1);
imshow(img);
title('Original Image');

% Show the grayscale image
subplot(1,3,2);
imshow(grayImg);
title('Grayscale Image');

%% Part 2
% Reduce the resolution of the image

% Define a scale index to shrink the image
% (smaller the number = lower the resolution)
scaleIndex = 0.2; % reduce the image to 20% its original size, to optimize detail 

% Resize the grayscale image
resizeImg = imresize(grayImg, [scaleIndex * 0.5 * size(grayImg,1), scaleIndex * size(grayImg,2)]);

% Show the resized image
subplot(1,3,3);
imshow(resizeImg);
title('Reduced Resolution Image');

%% Part 3
adjustBrightness = imadjust(resizeImg, [0.2, 0.9], [ ]);
imshow(adjustBrightness)

% establish characters used to draw the dog
charImg =  ' |\/-'; %characters to be used 
numChars = length(charImg);

% Pixels below threshold will be printed as spaces, clean up background
gradientThreshold = 0.1; 

[Gx, Gy] = imgradientxy(adjustBrightness, 'sobel'); % change detector;  looks for gradients and distinguishes item from
% background

% magnitude and direction of the gradients
[Gmag, Gdir] = imgradient(Gx, Gy);

% Normalize the magnitude to 0-1 for thresholding
GmagNorm = Gmag / max(Gmag(:));

%% Part 4
% Print out text art
