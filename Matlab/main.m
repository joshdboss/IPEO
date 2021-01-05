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


%% Define functions =======================================================
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));


%% Load data ==============================================================
% Image. has band 3, 4, 5 and 6 as well as DEM
file_3 = 'Data/essai3/2020-10-20-L8_B03.tiff';
file_456 = 'Data/essai3/2020-10-20-L8_B456.tiff';
file_DEM = 'Data/essai3/DEM/DEM_raw.tiff';

% read landsat image
[im(:,:,1), refmat{1}] = readgeoraster(file_3);
[im(:,:,2:4), refmat{2}] = readgeoraster(file_456);
[im_DEM, refmat{3}] = readgeoraster(file_DEM);
% resize image to be of same size as DEM. quite naive, probably better way
% to do this in the future... : faire panshapening
im = imresize(im, size(im_DEM));




%% Preprocess the data ====================================================

% increase contrast
im_adj = zeros(size(im)); %pre-allocate matrix for speed
gamma = 1;
for i = 1:size(im,3)
    im_band = im(:,:,i);
    im_adj(:,:,i) = imadjust(im_band, stretchlim(im_band(im_band ~= 0), ...
                    [0.01 0.99]), [0,1], gamma);
end

% filter the DEM and add it to the adjusted image
sigma = 2;
h3 = fspecial('gaussian', 3, sigma);
filtered_DEM = imfilter(im_DEM,h3);
im_adj(:,:,5) = filtered_DEM;

% put the images in a double
im = im2double(im);
im_adj = im2double(im_adj);

% get the slope using Horn's formula. Still doesn't get actual angle of
% slope since the height is not interpolated properly. Better than nothing
% I guess
% R = 19; % resolution of the DEM [m]
% G_filter = [[-1, 0, 1]; [-2, 0, 2]; [1, 0, 1]] / (8*R);
% H_filter = [[-1, -2, -1]; [0, 0, 0]; [1, 2, 1]] / (8*R);
% DEM_G = imfilter(im_DEM,G_filter);
% DEM_H = imfilter(im_DEM,H_filter);
% slope = sqrt(DEM_G.^2 + DEM_H.^2);
m_per_pixel = (refmat{3}.CellExtentInWorldX + refmat{3}.CellExtentInWorldY)/2;
pixels_per_degree = 111120 / m_per_pixel;
gridrv = [pixels_per_degree 0 0];
[aspect,slope,gradN,gradE] = gradientm(im_DEM, gridrv);

% get the relevant indices
[ndwi, ndsi, mndwi] = ...
    getIndices(im_adj(:,:,1), im_adj(:,:,2), ...
    im_adj(:,:,3), im_adj(:,:,4));

% get the data into a single "image" that will be used for ML
img_data(:,:,1) = ndwi;
img_data(:,:,2) = ndsi;
img_data(:,:,3) = mndwi;
img_data(:,:,4) = slope;
img_data(:,:,5:6) = im_adj(:,:,2:3);


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
    %imnorm(img_data(:,:,4)), [-1, 0.01]);

    
%% Morphology fill in gaps and remove small lakes =========================

SE = strel('disk',5); % 'diamond' 'square'
im_uint8 = uint8(255 * mat2gray(classMap == 1));

% Performing Erosion
Im_e = imerode(im_uint8,SE);
% Performing Dilation
Im_d = imdilate(im_uint8,SE);

% reconstructive closing
Im_cr = imcomplement(imreconstruct(imcomplement(Im_d), ...
 imcomplement(im_uint8)));

% remove lakes smaller than the threshold
minimum_lake_size = 4;
small_lakes_removed = bwareaopen(Im_cr,minimum_lake_size);


%% Plot everything ========================================================

% plot the images
plotIndices(ndwi, ndsi, mndwi, refmat{3});

% plot the lakes on the given map
% plotOverlay(im_adj(:,:,2:4), classMap==1, refmat{3}, 0.75, ...
%     'Original image (B 3-5)')
% 
% plotOverlay(im_adj(:,:,2:4), Im_cr, refmat{3}, 0.75, ...
%     'Morphology')

plotOverlay(im_adj(:,:,2:4), small_lakes_removed, refmat{3}, 0.75, ...
    'Small lakes removed')



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
figure
set(gcf,'Position',[100 -100 900 600])
for i = 1:4
    subplot(2,2,i);
    mapshow(im_adj(:,:,i), refmat{3})
    axis equal tight
    xlabel('Easting [m]')
    ylabel('Northing [m]')
    title(sprintf('Adjusted Image. Band %d', i));
end
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
