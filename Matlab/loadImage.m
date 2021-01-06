function [Image, ImageRef] = loadImage(fileName_band3, ...
    fileName_bands456, fileName_band8, fileNameDEM)
%Loads an image from the given band files and DEM and pansharpens
%   Loads the given .tiff raster files and stacks the images properly into
%   an image variable for the 4 bands of interest as well as a DEM variable
%   and uses band 8 to perform pansharpening
%   Also outputs the reference information
%
%INPUTS
%   fileName_band3 (string) : Path to the image for band 3
%   fileName_bands456 (string) : Path to the image for bands 4 to 6
%   fileName_bands8 (string) : Path to the image for band 8
%   fileNameDEM (string) : Path to the DEM image
%
%OUTPUTS
%   Image (Mimg x Nimg x 5) : Matrix containing the image of interest of
%   dimensions Mimg x Nimg pixels containing 4 bands + DEM
%   ImageRef : The image mapping reference information

% load the 4 bands
% reference information is not saved, since we will be using the reference
% information for band 8 which has the highest resolution
[bands_3456(:,:,1), ~] = readgeoraster(fileName_band3);
[bands_3456(:,:,2:4), ~] = readgeoraster(fileName_bands456);

% load the DEM
% reference information not saved again
% TEMPORARILY UNTIL WE HAVE BAND 8: USES REFERENCE FROM DEM
% TO SWITCH WHEN IMPLEMENTED PROPERLY
[DEM, ImageRef] = readgeoraster(fileNameDEM);

% loads the pansharpening band
% For now it just assigns it to the DEM.
% TO SWITCH WHEN BAND 8 AND PANSHARPENING PROPERLY IMPLEMENTED
%[band_8, ImageRef] = readgeoraster(fileName_band8);
band_8 = DEM;

% Transform all images into a double precision number
bands_3456 = im2double(bands_3456);
DEM = im2double(DEM);
band_8 = im2double(band_8);

% Performs the pansharpening. For now uses naive resizing
bands_3456 = imresize(bands_3456, size(DEM));

% concatenates the bands and DEM to get the final image
Image = cat(3,bands_3456,DEM);

end

