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
im(:,:,5) = im_DEM;


%% Preprocess the data ====================================================

% get the relevant indices
[ndwi, ndsi, mndwi] = ...
    getIndices(im(:,:,1), im(:,:,2), ...
    im(:,:,3), im(:,:,4));

% normalize the indices
norm_ndwi = imnorm(ndwi);
norm_ndsi = imnorm(ndsi);
norm_mndwi = imnorm(mndwi);

% get the data into a single "image"
img_data(:,:,1) = ndwi;
img_data(:,:,2) = ndsi;
img_data(:,:,3) = mndwi;
img_data(:,:,4) = abs(gradient(im(:,:,5)));


%% Supervised machine learning ============================================
% load labelled data. note that traceROI must have been called separately
% before. call it using traceROI(im(:,:,1:3)) after the data been loaded
load('Data/essai3/labelled_data/index_DEM.mat');
load('Data/essai3/labelled_data/labels_DEM.mat');

classMap = supervisedLearning(img_data, index, labels);


%% Classify the image =====================================================

% get the lakes on the image
lakes = findLakes(ndwi, [0.05,0.75], ...
    ndsi, [-1, 2], mndwi, [-1, 2], ...
    1, [-1, 2]);
    %imnorm(abs(gradient(im(:,:,5)))), [-1, 0.01]);


%% Plot everything ========================================================

% plot the images
plotIndices(ndwi, ndsi, mndwi, refmat{3});

% plot the lakes on the given map
plotOverlay(im(:,:,1:3), classMap, refmat{3}, 0.75, ...
    'Original image (B 3-5)')