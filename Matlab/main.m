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


%% Start of analysis ==============================
% Image. has band 4,5 and 6 (here 1,2,3)
file_3 = 'Images/essai3/2020-10-20-L8_B03.tiff';
file_456 = 'Images/essai3/2020-10-20-L8_B456.tiff';
file_DEM = 'Images/essai3/2020-10-20-00_00_2020-10-20-23_59_DEM_MAPZEN_DEM_(Raw).tiff';

% read landsat image
[im(:,:,1), refmat{1}] = loadImage(file_3);
[im(:,:,2:4), refmat{2}] = loadImage(file_456);
[im_DEM, refmat{3}] = loadImage(file_DEM);
% resize image to be of same size as DEM. quite naive, probably better way
% to do this in the future...
im = imresize(im, size(im_DEM));
im(:,:,5) = im_DEM;

% get the relevant indices
[ndwi, ndsi, mndwi] = ...
    getIndices(im(:,:,1), im(:,:,2), ...
    im(:,:,3), im(:,:,4));

% plot the images
plotIndices(ndwi, ndsi, mndwi, ...
    refmat{3});

% get the lakes on the image
lakes = findLakes(ndwi, [0.05,0.75], ...
    ndsi, [-1, 2], mndwi, [-1, 2], ...
    imnorm(abs(gradient(im(:,:,5)))), [-1, 0.01]);

% plot the lakes on the given map
CMap = [0, 0, 0;  1, 0, 0]; % define the colormap
plotOverlay(im(:,:,1:3), lakes, refmat{3}, ...
    CMap, 1, 'Original image (B 3-5)')