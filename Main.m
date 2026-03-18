clear all; close all;
clc;

%% Image To Text Art Converter
% BME 60B Sandbox Project
% Members: Leo Tian, Khendra Beth Hernandez, Jericho Celeste, Isabel Bueno

keepRunning = true; % to keep the program running until user terminates

while keepRunning

    % User Inputs
    % Image file input
    validFile = false;
    while ~validFile
        % prompt user for which image file they want to use
        imageFile = input(['Enter image filename (include extension):\n' ...
            'Options:\n' ...
            '- SuprisedCat.jpg\n' ...
            '- AHHHDog.jpg\n' ...
            '- Pibble.png\n'], 's');
        if exist(imageFile, 'file')
            validFile = true;
        else
            % to make sure the user put in the proper file
            fprintf('File not found. Try again.\n');
        end
    end

    % Select mode
    modeChoice = input(['Choose mode:\n' ...
        '1 = Normal ASCII\n' ...
        '2 = Inverted ASCII\n' ...
        '3 = High-detail ASCII\n' ...
        '4 = Edge-detected ASCII\n']);

    while ~(modeChoice >= 1 && modeChoice <= 4 && modeChoice == floor(modeChoice))
        modeChoice = input('Enter a valid option (1–4): ');
    end

    % Character sets
    baseSet = '@#S%?*+;:,. '; % basic set
    highDetailSet = '@$B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvuxrjft/\|()1{}[]?-_+~<>i!lI;:,"^`''. '; % complex set

    % to determine which character set to go with based on mode
    if modeChoice == 1
        charSet = baseSet;
    elseif modeChoice == 2
        charSet = fliplr(baseSet);
    elseif modeChoice == 3
        charSet = highDetailSet;
    else
        charSet = baseSet;
    end

    % User customizes size of image
    scaleChoice = input('Enter image size (1–10): ');
    while scaleChoice < 1 || scaleChoice > 10 || scaleChoice ~= floor(scaleChoice)
        % if the user didn't put in a number that's valid
        scaleChoice = input('Enter a whole number between 1 and 10: ');
    end
    scaleIndex = scaleChoice / 50; % used to adjust scale accordingly. 
    % didn't go with this earlier since 1-10 is a much easier to understand
    % from a user perspective

    % User customizes brightness range
    brightnessRange = input('Enter brightness range as [low high] (e.g., [0.2 0.9]): ');
    
    % verify that the range from the user is valid 
    while ~(isnumeric(brightnessRange) && numel(brightnessRange) == 2 && ...
            brightnessRange(1) >= 0 && brightnessRange(2) <= 1 && ...
            brightnessRange(1) < brightnessRange(2))
    
        % if the user doesn't input a valid range
        brightnessRange = input('Enter a valid range like [0.2 0.9] with 0 ≤ low < high ≤ 1: ');
    end

    % load the image
    [img, grayImg] = loadAndConvertImage(imageFile);

    % set the parameters for the preview
    satisfied = 'n';

    while satisfied ~= 'y'

        if modeChoice == 4
            % for the edge detected function
            processedImg = createEdgeImage(grayImg);
            resizeImg = reduceResolution(processedImg, scaleIndex);
            adjustBrightness = resizeImg;
        else
            resizeImg = reduceResolution(grayImg, scaleIndex);
            adjustBrightness = adjustImageContrast(resizeImg, brightnessRange);
        end
        % to show all the processing steps to help the user determine if
        % they want to proceed or not
        showProcessingSteps(img, grayImg, resizeImg, adjustBrightness);

        % prompt the user if they want to use the current settings
        satisfied = lower(strtrim(input('Use these settings? (y/n): ', 's')));

        % makes sure the user's input is valid
        while ~(strcmp(satisfied, 'y') || strcmp(satisfied, 'n'))
            satisfied = lower(strtrim(input('Enter y or n: ', 's')));
        end
        
        if strcmp(satisfied, 'n')
            % give the user an opportunity to choose new settings if they
            % don't like the current ones after the set is displayed
            fprintf('Adjust settings:\n');
            fprintf('1 = Change size\n');
            fprintf('2 = Change contrast\n');
            fprintf('3 = Change both\n');
            
            % prompt the user for their prefered option
            choice = input('Select option (1–3): ');
        
            % if the user doesn't input a valid choise
            while ~(choice == 1 || choice == 2 || choice == 3)
                choice = input('Enter 1, 2, or 3: ');
            end
        
            % Change size
            if choice == 1 || choice == 3
                scaleChoice = input('Enter new image size (1–10): ');
                % make sure the user inputs a valid option
                while ~(isscalar(scaleChoice) && scaleChoice >= 1 && scaleChoice <= 10 && scaleChoice == floor(scaleChoice))
                    scaleChoice = input('Enter a valid whole number (1–10): ');
                end
                % scaled by default to 0.2, multiplied by 10 to match
                % user's prefered input from 0-10, easier to read this way,
                % back end isn't shown as clearly to user but doesn't
                % matter anyway
                scaleIndex = scaleChoice / 50;
            end
        
            % Change contrast
            if choice == 2 || choice == 3
                % set up a new brightness range
                brightnessRange = input('Enter new brightness range [low high]: ');
                % make sure the user puts in a valid range
                while ~(isnumeric(brightnessRange) && numel(brightnessRange) == 2 && ...
                        brightnessRange(1) >= 0 && brightnessRange(2) <= 1 && ...
                        brightnessRange(1) < brightnessRange(2))
                    brightnessRange = input('Enter a valid range like [0.2 0.9]: ');
                end
            end
        end
    end

    % ASCII converston
    asciiLines = imageToAscii(adjustBrightness, charSet);

    % print out the lines
    printAsciiArt(asciiLines);

    % give the user the option to save their artwork
    saveChoice = lower(strtrim(input('Save ASCII art to a file? (y/n): ', 's')));
    
    % verifies that the user inputs a valid input (y/n)
    while ~(strcmp(saveChoice, 'y') || strcmp(saveChoice, 'n'))
        % makes sure that inputing "y " as opposed to "y" doesn't break the
        % code
        saveChoice = lower(strtrim(input('Enter y or n: ', 's')));
    end

    % if the use chooses to save their art, it gets saved
    % strcmp is used in case user puts in 'y ' instead of 'y'
    if strcmp(saveChoice, 'y')
        outputFile = input('Enter output file name (e.g., art.txt): ', 's');
        saveAsciiArt(asciiLines, outputFile);
        fprintf('Saved to %s\n', outputFile);
    end

    % repeat for another image if the user wants to 
    again = lower(strtrim(input('Convert another image? (y/n): ', 's')));

    % makes sure the user puts in a valid input
    while ~(again == 'y' || again == 'n')
        again = lower(input('Enter y or n: ', 's'));
    end

    if again == 'n'
        keepRunning = false;
    end
end

% finish the program
fprintf('\nProgram finished.\n');


% Functions

function [img, grayImg] = loadAndConvertImage(imageFile)
% Loads the selected image file into MATLAB.
% If the image is a color image, it converts it to grayscale.
% Then it normalizes the grayscale image so all pixel values are between 0 and 1.
% Outputs:
%   img     = original image
%   grayImg = grayscale, normalized image

    try
        % attempt to read the image file chosen by the user
        img = imread(imageFile);
    catch
        % stop the program if the image cannot be loaded
        error('Error loading image file.');
    end

    % if the image has 3 dimensions, then it is an RGB image
    if ndims(img) == 3
        % convert RGB image to grayscale
        grayImg = rgb2gray(img);
    else
        % if it is already grayscale, keep it as is
        grayImg = img;
    end

    % normalize pixel intensities from 0-255 to 0-1
    grayImg = double(grayImg) / 255;
end

function resizeImg = reduceResolution(grayImg, scaleIndex)
% Reduces the size of the image before converting it to ASCII.
% The height is scaled down a little more than the width to account for
% the fact that text characters are taller than they are wide.
% Outputs:
%   resizeImg = smaller version of the input image

    % calculate the new number of rows using the scale factor
    newRows = max(1, round(scaleIndex * 0.5 * size(grayImg, 1)));

    % calculate the new number of columns using the scale factor
    newCols = max(1, round(scaleIndex * size(grayImg, 2)));

    % resize the grayscale image to the new dimensions
    resizeImg = imresize(grayImg, [newRows, newCols]);
end

function adjustedImg = adjustImageContrast(inputImg, brightnessRange)
% Adjusts the contrast of the image to make the ASCII art clearer.
% The brightnessRange input controls which pixel intensities get stretched.
% Outputs:
%   adjustedImg = contrast-adjusted image

    % use imadjust to remap the image brightness values
    adjustedImg = imadjust(inputImg, brightnessRange, []);
end

function edgeImg = createEdgeImage(grayImg)
% Creates an edge-detected version of the grayscale image.
% This is used for the edge-detected ASCII mode so the output emphasizes
% outlines and boundaries rather than overall brightness.
% Outputs:
%   edgeImg = binary edge image converted to double format

    % detect edges in the image using the Canny edge detector
    edgeImg = edge(grayImg, 'Canny');

    % convert logical output to double so it can be processed like an image
    edgeImg = double(edgeImg);
end

function showProcessingSteps(img, grayImg, resizeImg, adjustedImg)
% Displays the different stages of image processing in one figure window.
% This helps the user preview how the image changes before it is converted
% into ASCII art.
% The displayed steps are:
%   1. original image
%   2. grayscale image
%   3. resized image
%   4. processed image

    % open a new figure window
    figure;

    % show the original image
    subplot(1,4,1);
    imshow(img);
    title('Original');

    % show the grayscale image
    subplot(1,4,2);
    imshow(grayImg);
    title('Grayscale');

    % show the resized image
    subplot(1,4,3);
    imshow(resizeImg);
    title('Resized');

    % show the final processed image that will be mapped to ASCII
    subplot(1,4,4);
    imshow(adjustedImg);
    title('Processed');
end

function asciiLines = imageToAscii(adjustedImg, charSet)
% Converts the processed image into ASCII art.
% Each pixel is mapped to a character based on its brightness.
% Darker pixels map to denser characters, while lighter pixels map to
% simpler characters.
% Outputs:
%   asciiLines = string array where each element is one row of ASCII art

    % get the number of rows and columns in the processed image
    [rows, cols] = size(adjustedImg);

    % count how many characters are available in the selected character set
    numChars = length(charSet);

    % create an empty string array to store each row of ASCII art
    asciiLines = strings(rows, 1);

    % loop through each row of the image
    for i = 1:rows
        % create a character array for one line of ASCII output
        lineChars = char(zeros(1, cols));

        % loop through each column in the current row
        for j = 1:cols
            % get the brightness of the current pixel
            pixelVal = adjustedImg(i, j);

            % map the pixel brightness to a character index
            charIdx = round(pixelVal * (numChars - 1)) + 1;

            % make sure the index stays within valid bounds
            charIdx = max(1, min(numChars, charIdx));

            % assign the matching character to this position in the row
            lineChars(j) = charSet(charIdx);
        end

        % store the completed ASCII row in the output string array
        asciiLines(i) = string(lineChars);
    end
end

function printAsciiArt(asciiLines)
% Prints the completed ASCII art to the command window.
% Each element of asciiLines is printed on its own line.

    % loop through every row of ASCII art
    for i = 1:length(asciiLines)
        % print one line at a time
        fprintf('%s\n', asciiLines(i));
    end
end

function saveAsciiArt(asciiLines, outputFile)
% Saves the ASCII art to a text file chosen by the user.
% Each row of ASCII art is written to the file on a new line.
% Inputs:
%   asciiLines = string array containing the ASCII art
%   outputFile = name of the output text file

    % open the output file in write mode
    fid = fopen(outputFile, 'w');

    % loop through each row of ASCII art
    for i = 1:length(asciiLines)
        % write one line of ASCII art to the file
        fprintf(fid, '%s\n', asciiLines(i));
    end

    % close the file after writing is complete
    fclose(fid);
end