% Image processing for Earth Observation
% Project - Glacier retreat in the Himalayas and implications for local populations
% Author(s): Loïc Brouet

clc
clear 
close all

%% essai 1 : avec 1 image ayant bandes 4,5,6

%% Read Landsat image

% read L8 bands 4,5,6
file_l8_1 = '2020-10-20-L8_B456.tiff'; % have band 4,5 and 6 (here 1,2,3)

info = geotiffinfo(file_l8_1);
refmat = info.RefMatrix; % this matrix contains the information on the location and resolution of the top-left pixel

[l8_mat, ~, ~] = geotiffread(file_l8_1);

%% Transform data range and type
l8_mat = im2double(l8_mat); % convert image to double precision

%% NDWI index

% NDWI = (NIR - SWIR) / (NIR + SWIR) 
Im_ndwi = (l8_mat(:,:,2)-l8_mat(:,:,3))./(l8_mat(:,:,2)+l8_mat(:,:,3));

%% NDSI index

% NDSI = (SWIR - R) / (SWIR + R) 
Im_ndsi = (l8_mat(:,:,3)-l8_mat(:,:,1))./(l8_mat(:,:,3)+l8_mat(:,:,1));


%% Show the images
figure()
subplot(1,2,1);
mapshow(Im_ndwi, refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDWI');

subplot(1,2,2);
mapshow(Im_ndsi, refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDSI');

%% Apply normalization to [0,1] and replot the images
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));

figure
subplot(1,2,1);
mapshow(imnorm(Im_ndwi), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDWI');

subplot(1,2,2);
mapshow(imnorm(Im_ndsi), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDSI');

%% essai 2 avec 9 images, chacune ayant 1 bande (de 1 à 9)

%% Read Landsat image

% read all L8 bands
file_l8_1 = '2020-10-20-L8_B01.tiff'; % band 1
file_l8_2 = '2020-10-20-L8_B02.tiff'; % band 2
file_l8_3 = '2020-10-20-L8_B03.tiff'; % band 3
file_l8_4 = '2020-10-20-L8_B04.tiff'; % band 4
file_l8_5 = '2020-10-20-L8_B05.tiff'; % band 5
file_l8_6 = '2020-10-20-L8_B06.tiff'; % band 6
file_l8_7 = '2020-10-20-L8_B07.tiff'; % band 7
file_l8_8 = '2020-10-20-L8_B08.tiff'; % band 8
file_l8_9 = '2020-10-20-L8_B09.tiff'; % band 9
info = geotiffinfo(file_l8_1);
refmat = info.RefMatrix; % this matrix contains the information on the location and resolution of the top-left pixel

[l8_mat_1, ~, ~] = geotiffread(file_l8_1);
[l8_mat_2, ~, ~] = geotiffread(file_l8_2);
[l8_mat_3, ~, ~] = geotiffread(file_l8_3);
[l8_mat_4, ~, ~] = geotiffread(file_l8_4);
[l8_mat_5, ~, ~] = geotiffread(file_l8_5);
[l8_mat_6, ~, ~] = geotiffread(file_l8_6);
[l8_mat_7, ~, ~] = geotiffread(file_l8_7);
[l8_mat_8, ~, ~] = geotiffread(file_l8_8);
[l8_mat_9, ~, ~] = geotiffread(file_l8_9);

%% Transform data range and type
l8_mat_1 = im2double(l8_mat_1); % convert image to double precision
l8_mat_2 = im2double(l8_mat_2);
l8_mat_3 = im2double(l8_mat_3);
l8_mat_4 = im2double(l8_mat_4);
l8_mat_5 = im2double(l8_mat_5);
l8_mat_6 = im2double(l8_mat_6);
l8_mat_7 = im2double(l8_mat_7);
l8_mat_8 = im2double(l8_mat_8);
l8_mat_9 = im2double(l8_mat_9);
%% NDWI index

% NDWI = (NIR - SWIR) / (NIR + SWIR) 
Im_ndwi = (l8_mat_5(:,:)-l8_mat_6(:,:))./(l8_mat_5(:,:)+l8_mat_6(:,:));

%% NDSI index

% NDSI = (SWIR - R) / (SWIR + R) 
Im_ndsi = (l8_mat_6(:,:)-l8_mat_4(:,:))./(l8_mat_6(:,:)+l8_mat_4(:,:));

%% MNDWI index

% MNDWI = (G - SWIR) / (G + SWIR) 
Im_mndwi = (l8_mat_3(:,:)-l8_mat_6(:,:))./(l8_mat_3(:,:)+l8_mat_6(:,:));
%% Show the images
figure()
subplot(1,3,1);
mapshow(Im_ndwi, refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDWI');

subplot(1,3,2);
mapshow(Im_ndsi, refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDSI');

subplot(1,3,3);
mapshow(Im_mndwi, refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('MNDWI');

%% Apply normalization to [0,1] and replot the images
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));

figure
subplot(1,3,1);
mapshow(imnorm(Im_ndwi), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDWI');

subplot(1,3,2);
mapshow(imnorm(Im_ndsi), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('NDSI');

figure
subplot(1,3,3);
mapshow(imnorm(Im_mndwi), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('MNDWI');
