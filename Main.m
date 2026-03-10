%% Image To Text Art Converter
% BME 60B Sandbox Project
% Members: Leo Tian, Khendra Beth Hernandez, Jericho Celeste, Isabel Bueno

clc;
clear;
close all;

%% Part 1
% Convert the image of the dog to grayscale

% read image
img = imread('AHHHDog.jpg');

% convet to grayscale
grayImg = rgb2gray(img);

% Show original
figure;
subplot(1,2,1);
imshow(img);
title('Original Image');

% Show grayscale
subplot(1,2,2);
imshow(grayImg);
title('Grayscale Image');


%% Part 2
% Reduce the resolution of the image

%% Part 3
% Map brightness to character density

%% Part 4
% Print out text art