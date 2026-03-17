%% For testing purposes so I don't fuck up the main

clear all; close all;
clc;

%% Image To Text Art Converter
% BME 60B Sandbox Project
% Members: Leo Tian, Khendra Beth Hernandez, Jericho Celeste, Isabel Bueno

%% Main Script
% File name should eventually be Group5.m for submission

% User settings
imageFile = 'AHHHDog.jpg';
scaleIndex = 0.2;                 % overall size reduction factor
brightnessRange = [0.2 0.9];      % contrast adjustment range
charSet = '@#S%?*+;:,. ';         % darkest to lightest characters

% Load and preprocess image
[img, grayImg] = loadAndConvertImage(imageFile);

% Reduce resolution for text mapping
resizeImg = reduceResolution(grayImg, scaleIndex);

% Adjust contrast/brightness
adjustBrightness = adjustImageContrast(resizeImg, brightnessRange);

% Show all processing steps
showProcessingSteps(img, grayImg, resizeImg, adjustBrightness);

% Convert image to text art
asciiLines = imageToAscii(adjustBrightness, charSet);

% Print text art to command window
printAsciiArt(asciiLines);

fprintf('\nEnd of Art :)\n');


%% Local Functions

function [img, grayImg] = loadAndConvertImage(imageFile)
% Loads an image, converts it to grayscale, and normalizes intensity values

    img = imread(imageFile);

    % If image is RGB, convert to grayscale
    if ndims(img) == 3
        grayImg = rgb2gray(img);
    else
        grayImg = img; % otherwise the image is still just gray
    end

    % Normalize brightness to range 0-1 for later processing
    grayImg = double(grayImg) / 255;
end

function resizeImg = reduceResolution(grayImg, scaleIndex)
% Reduces image resolution for ASCII conversion
% Height is reduced a bit more to compensate for character aspect ratio
% since characters are taller than they are wide

    % make them shorter
    newRows = max(1, round(scaleIndex * 0.5 * size(grayImg, 1)));
    % makes them wider
    newCols = max(1, round(scaleIndex * size(grayImg, 2)));

    resizeImg = imresize(grayImg, [newRows, newCols]);
end

function adjustedImg = adjustImageContrast(inputImg, brightnessRange)
% Adjusts image contrast/brightness to make ASCII art clearer

    adjustedImg = imadjust(inputImg, brightnessRange, []);
end

function showProcessingSteps(img, grayImg, resizeImg, adjustedImg)
% Displays original and processed images in one figure window

    figure;

    subplot(1,4,1);
    imshow(img);
    title('Original Image'); % show the original image

    subplot(1,4,2);
    imshow(grayImg);
    title('Grayscale Image'); % show the grayscale image

    subplot(1,4,3);
    imshow(resizeImg);
    title('Reduced Resolution Image'); % show the reduced resolution image

    subplot(1,4,4);
    imshow(adjustedImg);
    title('Contrast-Adjusted Image'); % show the contrast adjusted image
end

function asciiLines = imageToAscii(adjustedImg, charSet)
% Converts each pixel of the adjusted image into an ASCII character
% Returns a string array where each entry is one printed line

    [rows, cols] = size(adjustedImg);
    numChars = length(charSet);

    asciiLines = strings(rows, 1);

    for i = 1:rows
        lineChars = char(zeros(1, cols));

        for j = 1:cols
            pixelVal = adjustedImg(i, j);

            % Map brightness to character index
            charIdx = round(pixelVal * (numChars - 1)) + 1;
            charIdx = max(1, min(numChars, charIdx));

            lineChars(j) = charSet(charIdx);
        end

        asciiLines(i) = string(lineChars);
    end
end

function printAsciiArt(asciiLines)
% Prints ASCII art line by line to the command window

    for i = 1:length(asciiLines)
        fprintf('%s\n', asciiLines(i));
    end
end