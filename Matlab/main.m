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


<<<<<<< Updated upstream
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
=======
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
R = 19; % resolution of the DEM [m]
G_filter = [[-1, 0, 1]; [-2, 0, 2]; [1, 0, 1]] / (8*R);
H_filter = [[-1, -2, -1]; [0, 0, 0]; [1, 2, 1]] / (8*R);
DEM_G = imfilter(im_DEM,G_filter);
DEM_H = imfilter(im_DEM,H_filter);
slope = sqrt(DEM_G.^2 + DEM_H.^2);

% get the relevant indices
[ndwi, ndsi, mndwi] = ...
    getIndices(im_adj(:,:,1), im_adj(:,:,2), ...
    im_adj(:,:,3), im_adj(:,:,4));

% get the data into a single "image" that will be used for ML
img_data(:,:,1) = ndwi;
img_data(:,:,2) = ndsi;
img_data(:,:,3) = mndwi;
img_data(:,:,4) = slope;


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
%l = bwareaopen(Im_cr,minimum_lake_size);
removed = bwareaopen(Im_cr,minimum_lake_size);
%% Plot everything ========================================================

% plot the images
plotIndices(ndwi, ndsi, mndwi, refmat{3});

% plot the lakes on the given map
% plotOverlay(im_adj(:,:,2:4), classMap==1, refmat{3}, 0.75, ...
%     'Original image (B 3-5)')
% 
% plotOverlay(im_adj(:,:,2:4), Im_cr, refmat{3}, 0.75, ...
%     'Morphology')

plotOverlay(im_adj(:,:,2:4), removed, refmat{3}, 0.75, ...
    'Small lakes removed')


%%% Plot other stuff
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