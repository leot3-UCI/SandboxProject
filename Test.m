%% For testing purposes so I don't fuck up the main

clear all; close all;
clc;

%% Image To Text Art Converter (Advanced Version)
% BME 60B Sandbox Project
% Members: Leo Tian, Khendra Beth Hernandez, Jericho Celeste, Isabel Bueno

keepRunning = true;

while keepRunning

    %% ===== USER INPUTS =====

    % Image file input with validation
    validFile = false;
    while ~validFile
        imageFile = input(['Enter image filename (include extension):\n' ...
            'Options:\n' ...
            'AHHHDog.jpg\n' ...
            'Pibble.png\n'], 's');
        if exist(imageFile, 'file')
            validFile = true;
        else
            fprintf('File not found. Try again.\n');
        end
    end

    % Mode selection
    modeChoice = input(['Choose mode:\n' ...
        '1 = Normal ASCII\n' ...
        '2 = Inverted ASCII\n' ...
        '3 = High-detail ASCII\n' ...
        '4 = Edge-detected ASCII\n']);

    while ~(modeChoice >= 1 && modeChoice <= 4 && modeChoice == floor(modeChoice))
        modeChoice = input('Enter a valid option (1–4): ');
    end

    % Character sets
    baseSet = '@#S%?*+;:,. ';
    highDetailSet = '@$B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvuxrjft/\|()1{}[]?-_+~<>i!lI;:,"^`''. ';

    if modeChoice == 1
        charSet = baseSet;
    elseif modeChoice == 2
        charSet = fliplr(baseSet);
    elseif modeChoice == 3
        charSet = highDetailSet;
    else
        charSet = baseSet;
    end

    % Scale input with validation
    scaleChoice = input('Enter image size (1–10): ');
    while scaleChoice < 1 || scaleChoice > 10 || scaleChoice ~= floor(scaleChoice)
        scaleChoice = input('Enter a whole number between 1 and 10: ');
    end
    scaleIndex = scaleChoice / 50;

    % Contrast range input
    brightnessRange = input('Enter brightness range as [low high] (e.g., [0.2 0.9]): ');
    if length(brightnessRange) ~= 2
        brightnessRange = [0.2 0.9];
        fprintf('Invalid input. Using default contrast.\n');
    end

    %% ===== LOAD IMAGE =====
    [img, grayImg] = loadAndConvertImage(imageFile);

    %% ===== PREVIEW LOOP =====
    satisfied = 'n';

    while satisfied ~= 'y'

        if modeChoice == 4
            processedImg = createEdgeImage(grayImg);
            resizeImg = reduceResolution(processedImg, scaleIndex);
            adjustBrightness = resizeImg;
        else
            resizeImg = reduceResolution(grayImg, scaleIndex);
            adjustBrightness = adjustImageContrast(resizeImg, brightnessRange);
        end

        showProcessingSteps(img, grayImg, resizeImg, adjustBrightness);

        satisfied = lower(input('Use these settings? (y/n): ', 's'));

        while ~(satisfied == 'y' || satisfied == 'n')
            satisfied = lower(input('Enter y or n: ', 's'));
        end

        if satisfied == 'n'
            scaleChoice = input('Enter new image size (1–10): ');
            while scaleChoice < 1 || scaleChoice > 10
                scaleChoice = input('Enter a valid size (1–10): ');
            end
            scaleIndex = scaleChoice / 50;
        end
    end

    %% ===== ASCII CONVERSION =====
    asciiLines = imageToAscii(adjustBrightness, charSet);

    %% ===== PRINT =====
    printAsciiArt(asciiLines);

    %% ===== SAVE OPTION =====
    saveChoice = lower(input('Save ASCII art to a file? (y/n): ', 's'));

    if saveChoice == 'y'
        outputFile = input('Enter output file name (e.g., art.txt): ', 's');
        saveAsciiArt(asciiLines, outputFile);
        fprintf('Saved to %s\n', outputFile);
    end

    %% ===== REPEAT =====
    again = lower(input('Convert another image? (y/n): ', 's'));

    while ~(again == 'y' || again == 'n')
        again = lower(input('Enter y or n: ', 's'));
    end

    if again == 'n'
        keepRunning = false;
    end
end

fprintf('\nProgram finished.\n');


%% ===== FUNCTIONS =====

function [img, grayImg] = loadAndConvertImage(imageFile)
    try
        img = imread(imageFile);
    catch
        error('Error loading image file.');
    end

    if ndims(img) == 3
        grayImg = rgb2gray(img);
    else
        grayImg = img;
    end

    grayImg = double(grayImg) / 255;
end

function resizeImg = reduceResolution(grayImg, scaleIndex)
    newRows = max(1, round(scaleIndex * 0.5 * size(grayImg, 1)));
    newCols = max(1, round(scaleIndex * size(grayImg, 2)));
    resizeImg = imresize(grayImg, [newRows, newCols]);
end

function adjustedImg = adjustImageContrast(inputImg, brightnessRange)
    adjustedImg = imadjust(inputImg, brightnessRange, []);
end

function edgeImg = createEdgeImage(grayImg)
    edgeImg = edge(grayImg, 'Canny');
    edgeImg = double(edgeImg);
end

function showProcessingSteps(img, grayImg, resizeImg, adjustedImg)
    figure;

    subplot(1,4,1);
    imshow(img);
    title('Original');

    subplot(1,4,2);
    imshow(grayImg);
    title('Grayscale');

    subplot(1,4,3);
    imshow(resizeImg);
    title('Resized');

    subplot(1,4,4);
    imshow(adjustedImg);
    title('Processed');
end

function asciiLines = imageToAscii(adjustedImg, charSet)
    [rows, cols] = size(adjustedImg);
    numChars = length(charSet);

    asciiLines = strings(rows, 1);

    for i = 1:rows
        lineChars = char(zeros(1, cols));

        for j = 1:cols
            pixelVal = adjustedImg(i, j);
            charIdx = round(pixelVal * (numChars - 1)) + 1;
            charIdx = max(1, min(numChars, charIdx));
            lineChars(j) = charSet(charIdx);
        end

        asciiLines(i) = string(lineChars);
    end
end

function printAsciiArt(asciiLines)
    for i = 1:length(asciiLines)
        fprintf('%s\n', asciiLines(i));
    end
end

function saveAsciiArt(asciiLines, outputFile)
    fid = fopen(outputFile, 'w');
    for i = 1:length(asciiLines)
        fprintf(fid, '%s\n', asciiLines(i));
    end
    fclose(fid);
end