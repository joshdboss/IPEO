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
[l8_ndwi_456, l8_ndsi_456, ~] = ...
    getIndices(NaN, red_l8_456, NIR_l8_456, SWIR_l8_456);

% plot the images
plotIndices(l8_ndwi_456, l8_ndsi_456, NaN, refmat_l8_456);


%% Essai 2 avec 9 images, chacune ayant 1 bande (de 1 à 9) ================
% Image names. individual bands now
file_l8_1 = 'Images/2020-10-20-L8_B01.tiff'; % band 1
file_l8_2 = 'Images/2020-10-20-L8_B02.tiff'; % band 2
file_l8_3 = 'Images/2020-10-20-L8_B03.tiff'; % band 3
file_l8_4 = 'Images/2020-10-20-L8_B04.tiff'; % band 4
file_l8_5 = 'Images/2020-10-20-L8_B05.tiff'; % band 5
file_l8_6 = 'Images/2020-10-20-L8_B06.tiff'; % band 6
file_l8_7 = 'Images/2020-10-20-L8_B07.tiff'; % band 7
file_l8_8 = 'Images/2020-10-20-L8_B08.tiff'; % band 8
file_l8_9 = 'Images/2020-10-20-L8_B09.tiff'; % band 9

% read landsat images
[im_l8_1, refmat_l8_1] = loadImage(file_l8_1);
[im_l8_2, refmat_l8_2] = loadImage(file_l8_2);
[im_l8_3, refmat_l8_3] = loadImage(file_l8_3); % Green band
[im_l8_4, refmat_l8_4] = loadImage(file_l8_4); % Red band
[im_l8_5, refmat_l8_5] = loadImage(file_l8_5); % NIR band
[im_l8_6, refmat_l8_6] = loadImage(file_l8_6); % SWIR band
[im_l8_7, refmat_l8_7] = loadImage(file_l8_7);
[im_l8_8, refmat_l8_8] = loadImage(file_l8_8);
[im_l8_9, refmat_l8_9] = loadImage(file_l8_9);

% get the relevant indices. No green band is available, so not sent
[l8_ndwi, l8_ndsi, l8_mndwi] = ...
    getIndices(im_l8_3, im_l8_4, im_l8_5, im_l8_6);

% plot the images
plotIndices(l8_ndwi, l8_ndsi, l8_mndwi, refmat_l8_1);