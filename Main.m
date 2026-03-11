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
scaleIndex = 0.08; % reduce the image to 8% its original size

% Resize the grayscale image
resizeImg = imresize(grayImg, scaleIndex);

% Show the resized image
subplot(1,3,3);
imshow(resizeImg);
title('Reduced Resolution Image');

%% Part 3
% Map brightness to character density

%% Part 4
% Print out text art
