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


%% Preprocess the data ====================================================
% Zone 1 2020
refImagePixelSize = (refImageMatrix.CellExtentInWorldX ...
    + refImageMatrix.CellExtentInWorldY)/2;
refImageData = preprocess(refImage, refImagePixelSize);

% Zone 1 2014
zone1_2014PixelSize = (zone1_2014Matrix.CellExtentInWorldX ...
    + zone1_2014Matrix.CellExtentInWorldY)/2;
zone1_2014ImageData = preprocess(zone1_2014Image, zone1_2014PixelSize);


%% Histogram matching =====================================================
% If we have time and ML results not good for other images, perform
% histogram matching between other images and the reference image


%% Machine learning =======================================================
% Load labelled data. note that traceROI must be called separately before.
% Call it using traceROI(refImage(:,:,2:4)) after the data been loaded
load('Data/zone1/labelled_data/index_more_complete.mat');
load('Data/zone1/labelled_data/labels_more_complete.mat');

% Train the model

% Classify the images
refImageClassMap = supervisedLearning(refImageData, index, labels);

% There are multiple classes in the labelled data to help the model to work
% better. However, only the lakes (label 1) are of interest
% Therefore, discard the other classes.
refImageLakes = refImageClassMap == 1;

% Remove lake pixels with a sloper that's too high. Removed
% refImageLakes = slope(refImageLakes) < 10;


% % Alternatively, manually get the lakes on the image. Removed
% lakes = findLakes(refImageData(:,:,1), [0.05,0.75], ...
%     refImageData(:,:,2), [-1, 2], refImageData(:,:,3), [-1, 2], ...
%     refImageData(:,:,end), [-1, 0.01]);

    
%% Post-processing ========================================================

refImageProcessedLakes = postprocess(refImageLakes);


%% Plot everything ========================================================

% plot the images
%plotIndices(ndwi, ndsi, mndwi, refmat{3});

% plot the lakes on the given map
% plotOverlay(im_adj(:,:,2:4), classMap==1, refmat{3}, 0.75, ...
%     'Original image (B 3-5)')
% 
% plotOverlay(im_adj(:,:,2:4), Im_cr, refmat{3}, 0.75, ...
%     'Morphology')

plotOverlay(refImage(:,:,2:4), refImageProcessedLakes, refImageMatrix, ...
    0.75, 'Zone 1 (2020)')


% %% Plot other stuff
% figure
% set(gcf,'Position',[100 -100 900 600])
% for i = 1:4
%     subplot(2,2,i);
%     mapshow(im(:,:,i), refmat{3})
%     axis equal tight
%     xlabel('Easting [m]')
%     ylabel('Northing [m]')
%     title(sprintf('Original Image. Band %d', i));
% end
% 
% figure
% set(gcf,'Position',[100 -100 900 600])
% for i = 1:4
%     subplot(2,2,i);
%     mapshow(im_adj(:,:,i), refmat{3})
%     axis equal tight
%     xlabel('Easting [m]')
%     ylabel('Northing [m]')
%     title(sprintf('Adjusted Image. Band %d', i));
% end
% 
% figure
% set(gcf,'Position',[100 -100 900 600])
% for i = 1:4
%     subplot(2,2,i);
%     mapshow(imnorm(l8_mat_hp7(:,:,i)), refmat{3})
%     axis equal tight
%     xlabel('Easting [m]')
%     ylabel('Northing [m]')
%     title(sprintf('Filtered Image. Band %d', i));
% end
