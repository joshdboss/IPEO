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
% Location of the labelled data
indices_file = 'Data/zone1/labelled_data/index_more_complete.mat';
labels_file = 'Data/zone1/labelled_data/labels_more_complete.mat';

% File names for the reference image.
% The reference image is ALWAYS the first element in the imagData variable
imgData(1).band3_file = 'Data/zone1/2020-10-20-L8_B03.tiff';
imgData(1).bands456_file = 'Data/zone1/2020-10-20-L8_B456.tiff';
imgData(1).DEM_file = 'Data/zone1/DEM/DEM_raw.tiff';
imgData(1).name = 'Zone 1 (2020)';

imgData(2).band3_file = 'Data/zone1/2014-10-04-L8_B03.tiff';
imgData(2).bands456_file = 'Data/zone1/2014-10-04-L8_B456.tiff';
imgData(2).DEM_file = 'Data/zone1/DEM/DEM_raw.tiff'; % DEM doesn't change
imgData(2).name = 'Zone 1 (2014)';

imgData(3).band3_file = 'Data/zone2/2020-10-22-L8_B03.tiff';
imgData(3).bands456_file = 'Data/zone2/2020-10-22-L8_B456.tiff';
imgData(3).DEM_file = 'Data/zone2/DEMzone2/DEM_raw.tiff';
imgData(3).name = 'Zone 2 (2020)';


%% Define functions =======================================================
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));


% %% Label data =============================================================
% % Label the data on the given region
% % This section is commented since the labelROI function is quite buggy
% % and labelling should be done beforehand.
% % Uncomment and run this section after having run the "Define variables"
% % section to manual label the data. Do not forget to save the "index" and
% % "labels" variables!
% [refImage, ~] = loadImage(refImageFile3, refImageFile456, ...
%     1, refImageFileDEM);
% traceROI(refImage(:,:,2:4));


%% Load labelled data =====================================================
% Data must have already been labelled. See above section to manually label
% the data.
load(indices_file);
load(labels_file);


%% Loop through all images and find the lakes! ============================

for i = 1:length(imgData)
    % Load the image
    [imgData(i).rawImage, imgData(i).refMatrix] = ...
        loadImage(imgData(i).band3_file, imgData(i).bands456_file, ...
        1, imgData(i).DEM_file);
    
    % Preprocess the data
    imgData(i).PixelSize = (imgData(i).refMatrix.CellExtentInWorldX ...
    + imgData(i).refMatrix.CellExtentInWorldY)/2; % get the pixel size
    imgData(i).preprocessedData = preprocess(imgData(i).rawImage, ...
        imgData(i).PixelSize);
    
    % for images that are not the reference image
    if i ~= 1
        % perform histogram matching
    end
    
    % prepare the machine learning data with the reference image
    if i == 1
        [data_train_sc, label_train, data_valid_sc, label_valid, ...
            dataMax, dataMin] = prepareML(imgData(i).preprocessedData, ...
            index, labels);
    end
    
    % Classify the images
    imgData(i).classMap = classifyML(imgData(i).preprocessedData, ...
        data_train_sc, label_train, dataMax, dataMin);
    
    % There are multiple classes in the labelled data to help the model
    % work better. However, only the lakes (label 1) are of interest
    % Therefore, discard the other classes.
    imgData(i).lakes = imgData(i).classMap == 1;
    
    % Post process the data
    imgData(i).processedLakes = postprocess(imgData(i).lakes);
        
    % Plot everything
    plotOverlay(imgData(i).rawImage(:,:,2:4), imgData(i).processedLakes,...
        imgData(i).refMatrix, 0.75, imgData(i).name)

end