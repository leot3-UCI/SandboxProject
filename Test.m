%% For testing purposes so I don't fuck up the main

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

subplot(1,4,1);
imshow(img);
title('Original Image');

% Show the grayscale image
subplot(1,4,2);
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
subplot(1,4,3);
imshow(resizeImg);
title('Reduced Resolution Image');

%% Part 3
% Adjust brightness/contrast to make the text art clearer

adjustBrightness = imadjust(resizeImg, [0.2 0.9], []);

% Character set from darkest to lightest
% Dark pixels will map to dense characters, bright pixels to lighter ones
charImg = '@#S%?*+;:,. ';
numChars = length(charImg);

% Show the contrast-adjusted image
subplot(1,4,4);
imshow(adjustBrightness);
title('Contrast-Adjusted Image for Text Mapping');
