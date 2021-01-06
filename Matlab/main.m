% MAIN Script for IPEO project
%% HEADER
% MAIN - main script for IPEO project
% Project title:
% Glacier retreat in the Himalayas and implications for local populations
% Authors: Loïc Brouet, Joshua Cayetano-Emond
% SCIPER NUMBER: 266712, 309043
% Date: 2020-12-15


%% General settings =======================================================
clc;
clear;
%close all;

% plotting settings to be more visible
set(groot,'DefaultAxesFontSize',14)
set(groot,'DefaultLineLineWidth',1.5)
set(groot,'defaultfigureposition',[400 100 1000 400])


%% Define variables =======================================================
pixelSize = 19; % pixel size in meters

% Location of the labelled data
indices_file = 'Data/zone1/index_justlakes.mat';
labels_file = 'Data/zone1/labels_justlakes.mat';

% File names for the reference image.
% The reference image is ALWAYS the first element in the imagData variable
imgData(1).blue_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B02.tiff';
imgData(1).green_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B03.tiff';
imgData(1).red_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B04.tiff';
imgData(1).nir_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B08A.tiff';
imgData(1).swir_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B11.tiff';
imgData(1).DEM_file = 'Data/zone1/2020/DEM_WGS84/DEM_raw.tiff';
imgData(1).name = 'Zone 1 (2020)';

imgData(2).blue_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B02.tiff';
imgData(2).green_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B03.tiff';
imgData(2).red_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B04.tiff';
imgData(2).nir_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B05.tiff';
imgData(2).swir_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B06.tiff';
imgData(2).DEM_file = 'Data/zone1/2014/DEM_WGS84/DEM_raw.tiff';
imgData(2).name = 'Zone 1 (2014)';

% 
% imgData(3).band3_file = 'Data/zone2/2020-10-22-L8_B03.tiff';
% imgData(3).bands456_file = 'Data/zone2/2020-10-22-L8_B456.tiff';
% imgData(3).DEM_file = 'Data/zone2/DEMzone2/DEM_raw.tiff';
% imgData(3).name = 'Zone 2 (2020)';


%% Define functions =======================================================
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));

% %% Label data =============================================================
% % Label the data on the given region
% % This section is commented since the labelROI function is quite buggy
% % and labelling should be done beforehand.
% % Uncomment and run this section after having run the "Define variables"
% % section to manual label the data. Do not forget to save the "index" and
% % "labels" variables!
% [refImage, ~] = loadImage(imgData(1).blue_file, ...
%                   imgData(1).green_file, ...
%                   imgData(1).red_file, ...
%                   imgData(1).nir_file, ...
%                   imgData(1).swir_file, ...
%                   imgData(1).DEM_file);
% traceROI(refImage(:,:,[3,2,1]));


%% Load labelled data =====================================================
% Data must have already been labelled. See above section to manually label
% the data.
fprintf('Loading the labelled data.\n');
load(indices_file);
load(labels_file);


%% Loop through all images and find the lakes! ============================

for i = 1:length(imgData)
    fprintf('WORKING ON IMAGE %s\n', imgData(i).name);
    
    % Load the image
    fprintf('Loading image bands and DEM.\n');
    [imgData(i).rawImage, imgData(i).refInfo, imgData(i).refMatrix] = ...
        loadImage(imgData(i).blue_file, ...
                  imgData(i).green_file, ...
                  imgData(i).red_file, ...
                  imgData(i).nir_file, ...
                  imgData(i).swir_file, ...
                  imgData(i).DEM_file);
    fprintf('Bands and DEM loaded.\n');
    
    % Preprocess the data
    fprintf('Preprocessing the data.\n');
    imgData(i).preprocessedData = preprocess(imgData(i).rawImage, ...
        imgData(i).refInfo);
    fprintf('Data preprocessed.\n');
    
    % for images that are not the reference image
    if i ~= 1
        % perform histogram matching
    end
    
    % prepare the machine learning data with the reference image
    if i == 1
        fprintf('Preparing machine learning data on reference image.\n');
        [data_train_sc, label_train, data_valid_sc, label_valid, ...
            dataMax, dataMin] = prepareML(imgData(i).preprocessedData, ...
            index, labels);
        fprintf('Data prepared.\n');
        
        
        % compute the accuracy on training data
        fprintf('Computing training accuracy.\n');
        [~, train_acc] = classifyML(data_train_sc, label_train, false, ...
            data_train_sc, label_train, dataMax, dataMin);
        fprintf('Training accuracy is of %.3f %%.\n', train_acc * 100);
        
        % compute the accuracy on validation data
        fprintf('Computing validation accuracy.\n');
        [~, val_acc] = classifyML(data_valid_sc, label_valid, false, ...
            data_train_sc, label_train, dataMax, dataMin);
        fprintf('Validation accuracy is of %.3f %%.\n', val_acc * 100);
    end
    
    % Classify the images
    fprintf('Classifying the image.\n');
    [imgData(i).classMap, ~] = classifyML(imgData(i).preprocessedData, ...
        NaN, true, data_train_sc, label_train, dataMax, dataMin);
    fprintf('Image classified.\n');
    
    % There are multiple classes in the labelled data to help the model
    % work better. However, only the lakes (label 1) are of interest
    % Therefore, discard the other classes.
    imgData(i).lakes = imgData(i).classMap == 1;
    
    % Post process the data
    fprintf('Post-processing the image classification.\n');
    imgData(i).processedLakes = postprocess(imgData(i).lakes);
    fprintf('Image classified.\n');
    
    % Get interesting data on the lakes
    imgData(i).numLakes = length(regionprops(imgData(i).processedLakes));
    imgData(i).lakeArea = ...
        sum(cat(1, regionprops(imgData(i).processedLakes).Area)) ...
        * pixelSize ^ 2;
    imgData(i).averageLakeArea = imgData(i).lakeArea / imgData(i).numLakes;
        
    % Plot everything
    plotOverlay(imgData(i).rawImage(:,:,[3,2,1]), ...
        imgData(i).processedLakes, imgData(i).refMatrix, ...
        0.75, imgData(i).name)
    

    fprintf('DONE WITH IMAGE %s\n', imgData(i).name)

end

