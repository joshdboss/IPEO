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
imgData(1).zone = 1;
imgData(1).year = 2020;

% Zone 1 2014. Landsat
imgData(2).blue_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B02.tiff';
imgData(2).green_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B03.tiff';
imgData(2).red_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B04.tiff';
imgData(2).nir_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B05.tiff';
imgData(2).swir_file = 'Data/zone1/2014/L8_WGS84/2014-10-04-L8_B06.tiff';
imgData(2).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(2).zone = 1;
imgData(2).year = 2014;

% Zone 1 2015. Landsat
imgData(3).blue_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B02.tiff';
imgData(3).green_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B03.tiff';
imgData(3).red_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B04.tiff';
imgData(3).nir_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B05.tiff';
imgData(3).swir_file = 'Data/zone1/2015/L8_WGS84/2015-10-07-L8_B06.tiff';
imgData(3).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(3).zone = 1;
imgData(3).year = 2015;

% Zone 1 2016. Landsat
imgData(4).blue_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B02.tiff';
imgData(4).green_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B03.tiff';
imgData(4).red_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B04.tiff';
imgData(4).nir_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B05.tiff';
imgData(4).swir_file = 'Data/zone1/2016/L8_WGS84/2016-10-18-L8_B06.tiff';
imgData(4).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(4).zone = 1;
imgData(4).year = 2016;

% Zone 1 2017. Sentinel
imgData(5).blue_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B02.tiff';
imgData(5).green_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B03.tiff';
imgData(5).red_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B04.tiff';
imgData(5).nir_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B08A.tiff';
imgData(5).swir_file = 'Data/zone1/2017/S2_WGS84/2017-10-10-S2_B11.tiff';
imgData(5).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(5).zone = 1;
imgData(5).year = 2017;

% Zone 1 2018. Sentinel
imgData(6).blue_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B02.tiff';
imgData(6).green_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B03.tiff';
imgData(6).red_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B04.tiff';
imgData(6).nir_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B08A.tiff';
imgData(6).swir_file = 'Data/zone1/2018/S2_WGS84/2018-10-05-S2_B11.tiff';
imgData(6).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(6).zone = 1;
imgData(6).year = 2018;

% Zone 1 2019. Sentinel
imgData(7).blue_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B02.tiff';
imgData(7).green_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B03.tiff';
imgData(7).red_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B04.tiff';
imgData(7).nir_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B08A.tiff';
imgData(7).swir_file = 'Data/zone1/2019/S2_WGS84/2019-10-10-S2_B11.tiff';
imgData(7).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(7).name = 'Zone 1 (2019)';
imgData(7).zone = 1;
imgData(7).year = 2019;

% Zone 2 2015
imgData(8).blue_file = 'Data/zone2/2015/2015-10-09-L8_B02.tiff';
imgData(8).green_file = 'Data/zone2/2015/2015-10-09-L8_B03.tiff';
imgData(8).red_file = 'Data/zone2/2015/2015-10-09-L8_B04.tiff';
imgData(8).nir_file = 'Data/zone2/2015/2015-10-09-L8_B05.tiff';
imgData(8).swir_file = 'Data/zone2/2015/2015-10-09-L8_B06.tiff';
imgData(8).DEM_file = 'Data/zone2/DEM/DEM_raw.tiff';
imgData(8).zone = 2;
imgData(8).year = 2015;

% Zone 2 2020
imgData(9).blue_file = 'Data/zone2/2020/2020-10-11-S2_B02.tiff';
imgData(9).green_file = 'Data/zone2/2020/2020-10-11-S2_B03.tiff';
imgData(9).red_file = 'Data/zone2/2020/2020-10-11-S2_B04.tiff';
imgData(9).nir_file = 'Data/zone2/2020/2020-10-11-S2_B08A.tiff';
imgData(9).swir_file = 'Data/zone2/2020/2020-10-11-S2_B11.tiff';
imgData(9).DEM_file = 'Data/zone2/DEM/DEM_raw.tiff';
imgData(9).zone = 2;
imgData(9).year = 2020;

% Zone 1 2013
imgData(10).blue_file = 'Data/zone1/2013/L8_WGS84/2013-10-10-L8-B02.tiff';
imgData(10).green_file = 'Data/zone1/2013/L8_WGS84/2013-10-10-L8-B03.tiff';
imgData(10).red_file = 'Data/zone1/2013/L8_WGS84/2013-10-10-L8-B04.tiff';
imgData(10).nir_file = 'Data/zone1/2013/L8_WGS84/2013-10-10-L8-B05.tiff';
imgData(10).swir_file = 'Data/zone1/2013/L8_WGS84/2013-10-10-L8-B06.tiff';
imgData(10).DEM_file = 'Data/zone1/DEM_2015/DEM_raw.tiff';
imgData(10).zone = 1;
imgData(10).year = 2013;


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
    fprintf('========== STARTING TO WORK ON ZONE %d (%d)\n', ...
        imgData(i).zone, imgData(i).year);
    
    % Load the image
    fprintf('--- Zone %d (%d): Loading image bands and DEM.\n', ...
        imgData(i).zone, imgData(i).year);
    [imgData(i).rawImage, imgData(i).refInfo, imgData(i).refMatrix] = ...
        loadImage(imgData(i).blue_file, ...
                  imgData(i).green_file, ...
                  imgData(i).red_file, ...
                  imgData(i).nir_file, ...
                  imgData(i).swir_file, ...
                  imgData(i).DEM_file);
    fprintf('--- Zone %d (%d): Bands and DEM loaded.\n', ...
        imgData(i).zone, imgData(i).year);
    
    % for the reference image
    if i == 1
        % normalize histograms
        fprintf('--- Zone %d (%d): Normalizing the histograms.\n', ...
            imgData(i).zone, imgData(i).year);
        imgData(i).normImage = normalizeHistogram(imgData(i).rawImage, NaN);
        fprintf('--- Zone %d (%d): Histograms normalized.\n', ...
            imgData(i).zone, imgData(i).year);
    else
        % for the others, perform histogram matching with reference image
        fprintf('--- Zone %d (%d): Matching the histograms.\n', ...
            imgData(i).zone, imgData(i).year);
        imgData(i).normImage = normalizeHistogram(imgData(i).rawImage, ...
            imgData(1).normImage);
        fprintf('--- Zone %d (%d): Histograms matched.\n', ...
            imgData(i).zone, imgData(i).year);
    end
    
    % Extract the metrics
    fprintf('--- Zone %d (%d): Extracting the metrics.\n', ...
        imgData(i).zone, imgData(i).year);
    imgData(i).imageMetrics = prepareMetrics(imgData(i).normImage, ...
        imgData(i).refInfo);
    fprintf('--- Zone %d (%d): Metrics extracted.\n', ...
        imgData(i).zone, imgData(i).year);
    
    % prepare the machine learning data with the reference image
    if i == 1
        fprintf('--- Zone %d (%d): Preparing machine learning data on reference image.\n', ...
            imgData(i).zone, imgData(i).year);
        [data_train_sc, label_train, data_valid_sc, label_valid, ...
            dataMax, dataMin] = prepareML(imgData(i).imageMetrics, ...
            index, labels);
        fprintf('--- Zone %d (%d): Data prepared.\n', ...
            imgData(i).zone, imgData(i).year);
        
        % compute the accuracy on training data
        fprintf('--- Zone %d (%d): Computing training accuracy.\n', ...
            imgData(i).zone, imgData(i).year);
        [~, train_acc, lake_train_precision, lake_train_recall] = ...
            classifyML(data_train_sc, label_train, false, data_train_sc, ...
            label_train, dataMax, dataMin);
        fprintf('--- Zone %d (%d): Training accuracy is of %.3f %%.\n', ...
            imgData(i).zone, imgData(i).year, train_acc * 100);
        fprintf('--- Zone %d (%d): Training lake precision is of %.3f %%.\n', ...
            imgData(i).zone, imgData(i).year, lake_train_precision * 100);
        fprintf('--- Zone %d (%d): Training lake recall is of %.3f %%.\n', ...
            imgData(i).zone, imgData(i).year, lake_train_recall * 100);
        
        % compute the accuracy and statistics on validation data
        fprintf('--- Zone %d (%d): Computing validation accuracy.\n', ...
            imgData(i).zone, imgData(i).year);
        [~, val_acc, lake_val_precision, lake_val_recall] = ...
            classifyML(data_valid_sc, label_valid, false, data_train_sc, ...
            label_train, dataMax, dataMin);
        fprintf('--- Zone %d (%d): Validation accuracy is of %.3f %%.\n', ...
            imgData(i).zone, imgData(i).year, val_acc * 100);
        fprintf('--- Zone %d (%d): Validation lake precision is of %.3f %%.\n', ...
            imgData(i).zone, imgData(i).year, lake_val_precision * 100);
        fprintf('--- Zone %d (%d): Validation lake recall is of %.3f %%.\n', ...
            imgData(i).zone, imgData(i).year, lake_val_recall * 100);
    end
    
    % Classify the images
    fprintf('--- Zone %d (%d): Classifying the image.\n', ...
        imgData(i).zone, imgData(i).year);
    [imgData(i).classMap, ~] = classifyML(imgData(i).imageMetrics, ...
        NaN, true, data_train_sc, label_train, dataMax, dataMin);
    fprintf('--- Zone %d (%d): Image classified.\n', ...
        imgData(i).zone, imgData(i).year);
    
    % There are multiple classes in the labelled data to help the model
    % work better. However, only the lakes (label 1) are of interest
    % Therefore, discard the other classes.
    imgData(i).lakes = imgData(i).classMap == 1;
    
    % Post process the data
    fprintf('--- Zone %d (%d): Post-processing the image classification.\n', ...
        imgData(i).zone, imgData(i).year);
    imgData(i).processedLakes = postprocess(imgData(i).lakes);
    fprintf('--- Zone %d (%d): Image classified.\n', ...
        imgData(i).zone, imgData(i).year);
    
    % Get interesting data on the lakes
    imgData(i).numLakes = length(regionprops(imgData(i).processedLakes));
    imgData(i).lakeArea = ...
        sum(cat(1, regionprops(imgData(i).processedLakes).Area)) ...
        * pixelSize ^ 2;
    imgData(i).averageLakeArea = imgData(i).lakeArea / imgData(i).numLakes;
    fprintf('--- Zone %d (%d): Number of lakes: %d.\n', ...
        imgData(i).zone, imgData(i).year, imgData(i).numLakes);
    fprintf('--- Zone %d (%d): Total lake area: %.1f m^2.\n', ...
        imgData(i).zone, imgData(i).year, imgData(i).lakeArea);
    fprintf('--- Zone %d (%d): Average lake area: %.3f m^2.\n', ...
        imgData(i).zone, imgData(i).year, imgData(i).averageLakeArea);
        
    % Plot everything
    plotOverlay(imgData(i).normImage(:,:,[3,2,1]), ...
        imgData(i).processedLakes, imgData(i).refMatrix, ...
        0.75, sprintf('Zone %d (%d)', imgData(i).zone, imgData(i).year))
    

    fprintf('========== DONE WITH ZONE %d (%d)\n', ...
        imgData(i).zone, imgData(i).year)

end


%% Generate area comparison graphs
uniqueZones = unique(cat(1,imgData.zone))';

for zoneName = uniqueZones
    data = imgData(cat(1,imgData.zone) == zoneName); % scenes in right zone
    years = cat(1,data.year); % years for each of the scenes
    
    % lake information
    numLakes = cat(1,data.numLakes);
    lakeAreas = cat(1,data.lakeArea);
    averageLakeArea = cat(1,data.averageLakeArea);
    
    % sort everything according to chronological order
    [years, idx] = sort(years);
    numLakes = numLakes(idx);
    lakeAreas = lakeAreas(idx);
    averageLakeArea = averageLakeArea(idx);

    figure
    subplot(2,1,1)
    plot(years,numLakes);
    title(sprintf('Evolution of the lakes in zone %d', zoneName))
    ylabel('Total number of lakes');
    subplot(2,1,2)
    yyaxis left
    plot(years,lakeAreas);
    ylabel('Total lake area');
    yyaxis right
    plot(years,averageLakeArea);
    ylabel('Average lake area');
    xlabel('Year');

end