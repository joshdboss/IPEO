% Image processing for Earth Observation
% Project - Glacier retreat in the Himalayas and implications for local populations
% Author(s): Loïc Brouet

clc
clear 
close all


%% Read Landsat image

% read all L8 bands
file_l8 = '2020_08_30_Sentinel2.tiff'; 

info = geotiffinfo(file_l8);