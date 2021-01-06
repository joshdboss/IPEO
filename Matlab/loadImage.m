function [Image, ImageRef, refMat] = ...
    loadImage(fileName_blue, ...
              fileName_green, ...
              fileName_red, ...
              fileName_nir, ...
              fileName_swir, ...
              fileNameDEM)
%Loads an image from the given band files and DEM and pansharpens
%   Loads the given .tiff raster files and stacks the images properly into
%   an image variable for the 5 bands of interest as well as a DEM variable
%   Also outputs the reference information
%
%INPUTS
%   fileName_band2 (string) : Path to the image for band 2
%   fileName_band3 (string) : Path to the image for band 3
%   fileName_bands456 (string) : Path to the image for bands 4 to 6
%   fileNameDEM (string) : Path to the DEM image
%
%OUTPUTS
%   Image (Mimg x Nimg x 5) : Matrix containing the image of interest of
%   dimensions Mimg x Nimg pixels containing 4 bands + DEM
%   ImageRef : The image mapping reference information
%   refMat : reference matrix of the image

% load the 4 bands
% reference information is not saved, since we will be using the reference
% information for DEM which has the highest resolution
[bands(:,:,1), ~] = readgeoraster(fileName_blue);
[bands(:,:,2), ~] = readgeoraster(fileName_green);
[bands(:,:,3), ~] = readgeoraster(fileName_red);
[bands(:,:,4), ~] = readgeoraster(fileName_nir);
[bands(:,:,5), ~] = readgeoraster(fileName_swir);

% load the DEM
[DEM, ImageRef] = readgeoraster(fileNameDEM);
refMat = geotiffinfo(fileNameDEM).RefMatrix;

% Transform all images into a double precision number
bands = im2double(bands);
DEM = im2double(DEM);

% Performs the pansharpening. For now uses naive resizing
bands = imresize(bands, size(DEM));

% concatenates the bands and DEM to get the final image
Image = cat(3,bands,DEM);

end

