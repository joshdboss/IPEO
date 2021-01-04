% MAIN Script for IPEO project
%% HEADER
% MAIN - main script for IPEO project
% Project title:
% Glacier retreat in the Himalayas and implications for local populations
% Authors: Loïc Brouet, Joshua Cayetano-Emond
% SCIPER NUMBER: xxxxxxx, 309043
% Date: 2020-12-15


%% General settings =======================================================
clc;
clear;
close all;

% plotting settings to be more visible
set(groot,'DefaultAxesFontSize',14)
set(groot,'DefaultLineLineWidth',1.5)
set(groot,'defaultfigureposition',[400 100 1000 400])


%% Define variables =======================================================


%% Define functions =======================================================



%% Essai 1 : avec 1 image ayant bandes 4,5,6 ==============================
% Image. has band 4,5 and 6 (here 1,2,3)
file_l8_456 = 'Images/2020-10-20-L8_B456.tiff';

[im_l8_456, refmat_l8_456] = loadImage(file_l8_456); % read landsat image
% split the image into its bands for verbosity
red_l8_456 = im_l8_456(:,:,1);
NIR_l8_456 = im_l8_456(:,:,2);
SWIR_l8_456 = im_l8_456(:,:,3);

% get the relevant indices. No green band is available, so not sent
[ndwi_l8_456, ndsi_l8_456, ~] = ...
    getIndices(NaN, red_l8_456, NIR_l8_456, SWIR_l8_456);

% plot the images
plotIndices(ndwi_l8_456, ndsi_l8_456, NaN, refmat_l8_456);

% get the lakes on the image
lakes_l8_456 = findLakes(ndwi_l8_456, [0.05,0.75], ...
    ndsi_l8_456, [-1, 2], 1, [-1, 2], 1, [-1, 2]);

% plot the lakes on the given map
CMap = [0, 0, 0;  1, 0, 0]; % define the colormap
plotOverlay(im_l8_456, lakes_l8_456, refmat_l8_456, CMap, ...
    1, 'Original image (B 4-6) with lakes superimposed')
   

%% Essai 2 avec 9 images, chacune ayant 1 bande (de 1 à 9) ================
% loop through all bands
for i = 1:9
    fileName = sprintf('Images/2020-10-20-L8_B%02d.tiff',i);
    [im_l8_indiv(:,:,i), refmat_l8_indiv{i}] = loadImage(fileName);
end

% Green -> band 3
% Red -> band 4
% NIR -> band 5
% SWIR -> band 6

% get the relevant indices. No green band is available, so not sent
[ndwi_l8_indiv, ndsi_l8_indiv, mndwi_l8_indiv] = ...
    getIndices(im_l8_indiv(:,:,3), im_l8_indiv(:,:,4), ...
    im_l8_indiv(:,:,5), im_l8_indiv(:,:,6));

% plot the images
plotIndices(ndwi_l8_indiv, ndsi_l8_indiv, mndwi_l8_indiv, ...
    refmat_l8_indiv{1});

% get the lakes on the image
lakes_l8_indiv = findLakes(ndwi_l8_indiv, [0.05,0.75], ...
    ndsi_l8_indiv, [-1, 2], mndwi_l8_indiv, [-1, 2], 1, [-1, 2]);

% plot the lakes on the given map
CMap = [0, 0, 0;  1, 0, 0]; % define the colormap
plotOverlay(im_l8_indiv(:,:,3:5), lakes_l8_indiv, refmat_l8_indiv{1}, ...
    CMap, 1, 'Original image (B 3-5) with lakes superimposed')

% %% WIP: figure out how to combine images with different georeferences
% 
% figure
% mapshow(im_l8_456, refmat_l8_456)
% 
% figure
% mapshow(im_l8_indiv(:,:,3:5), refmat_l8_indiv{1})