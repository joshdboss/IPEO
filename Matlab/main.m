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
% Load any relevant variables here


%% Define functions =======================================================
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));


%% Load data ==============================================================
% Reference labelled image - Zone 1 in 2020
refImageFile3 = 'Data/zone1/2020-10-20-L8_B03.tiff';
refImageFile456 = 'Data/zone1/2020-10-20-L8_B456.tiff';
refImageFileDEM = 'Data/zone1/DEM/DEM_raw.tiff';
[refImage, refImageMatrix] = loadImage(refImageFile3, refImageFile456, ...
    1, refImageFileDEM);

% Older image - Zone 1 in 2014
zone1_2014ImageFile3 = 'Data/zone1/2014-10-04-L8_B03.tiff';
zone1_2014ImageFile456 = 'Data/zone1/2014-10-04-L8_B456.tiff';
% Get the image. Uses same DEM as it doesn't exactly change much...
[zone1_2014Image, zone1_2014Matrix] = loadImage(zone1_2014ImageFile3, ...
    zone1_2014ImageFile456, 1, refImageFileDEM);

% Zone 2 in 2020
zone2_2020ImageFile3 = 'Data/zone2/2020-10-22-L8_B03.tiff';
zone2_2020ImageFile456 = 'Data/zone2/2020-10-22-L8_B456.tiff';
zone2_2020ImageFileDEM = 'Data/zone2/DEMzone2/DEM_raw.tiff';
[zone2_2020Image, zone2_2020Matrix] = loadImage(zone2_2020ImageFile3, ...
    zone2_2020ImageFile456, 1, zone2_2020ImageFileDEM);


%% Preprocess the data ====================================================
% Zone 1 2020
refImagePixelSize = (refImageMatrix.CellExtentInWorldX ...
    + refImageMatrix.CellExtentInWorldY)/2;
refImageData = preprocess(refImage, refImagePixelSize);

% Zone 1 2014
zone1_2014PixelSize = (zone1_2014Matrix.CellExtentInWorldX ...
    + zone1_2014Matrix.CellExtentInWorldY)/2;
zone1_2014ImageData = preprocess(zone1_2014Image, zone1_2014PixelSize);

% Zone 2 2020
zone2_2020PixelSize = (zone2_2020Matrix.CellExtentInWorldX ...
    + zone2_2020Matrix.CellExtentInWorldY)/2;
zone2_2020ImageData = preprocess(zone2_2020Image, zone2_2020PixelSize);


%% Histogram matching =====================================================
% If we have time and ML results not good for other images, perform
% histogram matching between other images and the reference image


%% Machine learning =======================================================
% Load labelled data. note that traceROI must be called separately before.
% Call it using traceROI(refImage(:,:,2:4)) after the data been loaded
load('Data/zone1/labelled_data/index_more_complete.mat');
load('Data/zone1/labelled_data/labels_more_complete.mat');

% Prepare the data
[data_train_sc, label_train, data_valid_sc, label_valid, dataMax, dataMin] = ...
    prepareML(refImageData, index, labels);

% Classify the images
refImageClassMap = classifyML(refImageData, data_train_sc, label_train, ...
    dataMax, dataMin);
zone1_2014ClassMap = classifyML(zone1_2014ImageData, data_train_sc, ...
    label_train, dataMax, dataMin);
zone2_2020ClassMap = classifyML(zone2_2020ImageData, data_train_sc, ...
    label_train, dataMax, dataMin);

% There are multiple classes in the labelled data to help the model to work
% better. However, only the lakes (label 1) are of interest
% Therefore, discard the other classes.
refImageLakes = refImageClassMap == 1;
zone1_2014Lakes = zone1_2014ClassMap == 1;
zone2_2020Lakes = zone2_2020ClassMap == 1;

% Remove lake pixels with a sloper that's too high. Removed
% refImageLakes = slope(refImageLakes) < 10;


% % Alternatively, manually get the lakes on the image. Removed
% lakes = findLakes(refImageData(:,:,1), [0.05,0.75], ...
%     refImageData(:,:,2), [-1, 2], refImageData(:,:,3), [-1, 2], ...
%     refImageData(:,:,end), [-1, 0.01]);

    
%% Post-processing ========================================================

refImageProcessedLakes = postprocess(refImageLakes);
zone1_2014ProcessedLakes = postprocess(zone1_2014Lakes);
zone2_2020ProcessedLakes = postprocess(zone2_2020Lakes);


%% Plot everything ========================================================

plotOverlay(refImage(:,:,2:4), refImageProcessedLakes, refImageMatrix, ...
    0.75, 'Zone 1 (2020)')
plotOverlay(zone1_2014Image(:,:,2:4), zone1_2014ProcessedLakes, zone1_2014Matrix, ...
    0.75, 'Zone 1 (2014)')
plotOverlay(zone2_2020Image(:,:,2:4), zone2_2020ProcessedLakes, zone2_2020Matrix, ...
    0.75, 'Zone 2 (2020)')