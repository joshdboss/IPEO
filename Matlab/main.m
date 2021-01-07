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
% pixel size in meters. obtained from the reference matrix of the DEM
pixelSize = 19.57;

% Location of the labelled data
indices_file = 'Data/zone1/index_better.mat';
labels_file = 'Data/zone1/labels_better.mat';
    
% File names for the reference image.
% The reference image is ALWAYS the first element in the imagData variable
imgData(1).blue_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B02.tiff';
imgData(1).green_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B03.tiff';
imgData(1).red_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B04.tiff';
imgData(1).nir_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B08A.tiff';
imgData(1).swir_file = 'Data/zone1/2020/S2_WGS84/2020-10-29-S2_B11.tiff';
imgData(1).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(1).name = 'Zone 1 (2020)';

% 2014. Landsat
imgData(2).blue_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B02.tiff';
imgData(2).green_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B03.tiff';
imgData(2).red_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B04.tiff';
imgData(2).nir_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B05.tiff';
imgData(2).swir_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B06.tiff';
imgData(2).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(2).name = 'Zone 1 (2014)';

% 2015. Landsat
imgData(3).blue_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B02.tiff';
imgData(3).green_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B03.tiff';
imgData(3).red_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B04.tiff';
imgData(3).nir_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B05.tiff';
imgData(3).swir_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B06.tiff';
imgData(3).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(3).name = 'Zone 1 (2015)';

% 2016. Landsat
imgData(4).blue_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B02.tiff';
imgData(4).green_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B03.tiff';
imgData(4).red_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B04.tiff';
imgData(4).nir_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B05.tiff';
imgData(4).swir_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B06.tiff';
imgData(4).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(4).name = 'Zone 1 (2016)';

% 2017. Sentinel
imgData(5).blue_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B02.tiff';
imgData(5).green_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B03.tiff';
imgData(5).red_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B04.tiff';
imgData(5).nir_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B08A.tiff';
imgData(5).swir_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B11.tiff';
imgData(5).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(5).name = 'Zone 1 (2017)';

% 2018. Sentinel
imgData(6).blue_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B02.tiff';
imgData(6).green_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B03.tiff';
imgData(6).red_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B04.tiff';
imgData(6).nir_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B08A.tiff';
imgData(6).swir_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B11.tiff';
imgData(6).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(6).name = 'Zone 1 (2018)';

% 2019. Sentinel
imgData(7).blue_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B02.tiff';
imgData(7).green_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B03.tiff';
imgData(7).red_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B04.tiff';
imgData(7).nir_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B08A.tiff';
imgData(7).swir_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B11.tiff';
imgData(7).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(7).name = 'Zone 1 (2019)';


%% Define functions =======================================================
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));

% %% Label data ===========================================================
% % Label the data on the given region
% % This section is commented since the labelROI function is quite buggy
% % and labelling should be done beforehand.
% % Uncomment and run this section after having run the "Define variables"
% % section to manual label the data. Do not forget to save the "index" and
% % "labels" variables!
% [refImage, ~] = loadImage(imgData(1).blue_file, ...
%                   imgData(1).green_file, ...
%                   imgData(1).red_file, ...
%                   imgData(1).nir_file, ...
%                   imgData(1).swir_file, ...
%                   imgData(1).DEM_file);
% traceROI(refImage(:,:,[3,2,1]));


%% Load labelled data =====================================================
% Data must have already been labelled. See above section to manually label
% the data.
fprintf('Loading the labelled data.\n');
load(indices_file);
load(labels_file);


%% Loop through all images and find the lakes! ============================

for i = 1:length(imgData)
    fprintf('========== STARTING TO WORK ON IMAGE %s\n', imgData(i).name);
    
    % Load the image
    fprintf('--- %s: Loading image bands and DEM.\n', imgData(i).name);
    [imgData(i).rawImage, imgData(i).refInfo, imgData(i).refMatrix] = ...
        loadImage(imgData(i).blue_file, ...
                  imgData(i).green_file, ...
                  imgData(i).red_file, ...
                  imgData(i).nir_file, ...
                  imgData(i).swir_file, ...
                  imgData(i).DEM_file);
    fprintf('--- %s: Bands and DEM loaded.\n', imgData(i).name);
    
    % for the reference image
    if i == 1
        % normalize histograms
        fprintf('--- %s: Normalizing the histograms.\n', imgData(i).name);
        imgData(i).normImage = normalizeHistogram(imgData(i).rawImage, NaN);
        fprintf('--- %s: Histograms normalized.\n', imgData(i).name);
    else
        % for the others, perform histogram matching with reference image
        fprintf('--- %s: Matching the histograms.\n', imgData(i).name);
        imgData(i).normImage = normalizeHistogram(imgData(i).rawImage, ...
            imgData(1).normImage);
        fprintf('--- %s: Histograms matched.\n', imgData(i).name);
    end
    
    % Extract the metrics
    fprintf('--- %s: Extracting the metrics.\n', imgData(i).name);
    imgData(i).imageMetrics = prepareMetrics(imgData(i).normImage, ...
        imgData(i).refInfo);
    fprintf('--- %s: Metrics extracted.\n', imgData(i).name);
    
    
    % prepare the machine learning data with the reference image
    if i == 1
        fprintf('--- %s: Preparing machine learning data on reference image.\n', ...
            imgData(i).name);
        [data_train_sc, label_train, data_valid_sc, label_valid, ...
            dataMax, dataMin] = prepareML(imgData(i).imageMetrics, ...
            index, labels);
        fprintf('--- %s: Data prepared.\n', imgData(i).name);
        
        
        % compute the accuracy on training data
        fprintf('--- %s: Computing training accuracy.\n', imgData(i).name);
        [~, train_acc] = classifyML(data_train_sc, label_train, false, ...
            data_train_sc, label_train, dataMax, dataMin);
        fprintf('--- %s: Training accuracy is of %.3f %%.\n', ...
            imgData(i).name, train_acc * 100);
        
        % compute the accuracy on validation data
        fprintf('--- %s: Computing validation accuracy.\n', imgData(i).name);
        [~, val_acc] = classifyML(data_valid_sc, label_valid, false, ...
            data_train_sc, label_train, dataMax, dataMin);
        fprintf('--- %s: Validation accuracy is of %.3f %%.\n', ...
            imgData(i).name, val_acc * 100);
    end
    
    % Classify the images
    fprintf('--- %s: Classifying the image.\n', imgData(i).name);
    [imgData(i).classMap, ~] = classifyML(imgData(i).imageMetrics, ...
        NaN, true, data_train_sc, label_train, dataMax, dataMin);
    fprintf('--- %s: Image classified.\n', imgData(i).name);
    
    % There are multiple classes in the labelled data to help the model
    % work better. However, only the lakes (label 1) are of interest
    % Therefore, discard the other classes.
    imgData(i).lakes = imgData(i).classMap == 1;
    
    % Post process the data
    fprintf('--- %s: Post-processing the image classification.\n', ...
        imgData(i).name);
    imgData(i).processedLakes = postprocess(imgData(i).lakes);
    fprintf('--- %s: Image classified.\n', imgData(i).name);
    
    % Get interesting data on the lakes
    imgData(i).numLakes = length(regionprops(imgData(i).processedLakes));
    imgData(i).lakeArea = ...
        sum(cat(1, regionprops(imgData(i).processedLakes).Area)) ...
        * pixelSize ^ 2;
    imgData(i).averageLakeArea = imgData(i).lakeArea / imgData(i).numLakes;
    fprintf('--- %s: Number of lakes: %d.\n', ...
        imgData(i).name, imgData(i).numLakes);
    fprintf('--- %s: Total lake area: %.1f m^2.\n', ...
        imgData(i).name, imgData(i).lakeArea);
    fprintf('--- %s: Average lake area: %.3f m^2.\n', ...
        imgData(i).name, imgData(i).averageLakeArea);
        
    % Plot everything
    plotOverlay(imgData(i).normImage(:,:,[3,2,1]), ...
        imgData(i).processedLakes, imgData(i).refMatrix, ...
        0.75, imgData(i).name)
    

    fprintf('========== DONE WITH IMAGE %s\n', imgData(i).name)

end

