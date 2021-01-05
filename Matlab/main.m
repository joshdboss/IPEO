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
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));


%% Load data ==============================================================
% Image. has band 3, 4, 5 and 6 as well as DEM
file_3 = 'Data/essai3/2020-10-20-L8_B03.tiff';
file_456 = 'Data/essai3/2020-10-20-L8_B456.tiff';
file_DEM = 'Data/essai3/DEM/DEM_raw.tiff';

% read landsat image
[im(:,:,1), refmat{1}] = loadImage(file_3);
[im(:,:,2:4), refmat{2}] = loadImage(file_456);
[im_DEM, refmat{3}] = loadImage(file_DEM);
% resize image to be of same size as DEM. quite naive, probably better way
% to do this in the future...
im = imresize(im, size(im_DEM));


%% Preprocess the data ====================================================

% increase contrast
im_adj = zeros(size(im)); %pre-allocate matrix for speed
gamma = 1;
for i = 1:size(im,3)
    im_band = im(:,:,i);
    im_adj(:,:,i) = imadjust(im_band, stretchlim(im_band(im_band ~= 0), ...
                    [0.01 0.99]), [0,1], gamma); % adjusted red
end
im_adj(:,:,5) = im_DEM;

% get the relevant indices
[ndwi, ndsi, mndwi] = ...
    getIndices(im_adj(:,:,1), im_adj(:,:,2), ...
    im_adj(:,:,3), im_adj(:,:,4));

% get the data into a single "image"
img_data(:,:,1) = ndwi;
img_data(:,:,2) = ndsi;
img_data(:,:,3) = mndwi;
img_data(:,:,4) = abs(gradient(im_adj(:,:,5)));


%% Supervised machine learning ============================================
% load labelled data. note that traceROI must have been called separately
% before. call it using traceROI(im(:,:,2:4)) after the data been loaded
load('Data/essai3/labelled_data/index_more_complete.mat');
load('Data/essai3/labelled_data/labels_more_complete.mat');

classMap = supervisedLearning(img_data, index, labels);


%% Classify the image =====================================================

% manually get the lakes on the image
lakes = findLakes(ndwi, [0.05,0.75], ...
    ndsi, [-1, 2], mndwi, [-1, 2], ...
    1, [-1, 2]);
    %imnorm(abs(gradient(im(:,:,5)))), [-1, 0.01]);


%% Plot everything ========================================================

% plot the images
plotIndices(ndwi, ndsi, mndwi, refmat{3});

% plot the lakes on the given map
plotOverlay(im_adj(:,:,2:4), classMap, refmat{3}, 0.75, ...
    'Original image (B 3-5)')