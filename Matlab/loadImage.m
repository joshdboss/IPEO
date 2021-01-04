function [Image, Reference] = loadImage(fileName)
%Loads an image in a given file and converts it to double
%   Loads a given .tiff raster file and converts the image into a double.
%   Outputs both the image and the reference information
%
%INPUTS
%   fileName (string) : Path to the image to be loaded
%
%OUTPUTS
%   Image (M x N x B) : Matrix containing the image of interest of
%   dimensions M x N pixels containing B bands
%   Reference : The reference information to be able to map everything

[im, Reference] = readgeoraster(fileName); % load the image
Image = im2double(im); % transform the image into a double precision number

end

