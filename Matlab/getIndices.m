function [NDWI, NDSI, MNDWI] = getIndices(G, R, NIR, SWIR)
%Gets the NDWI, NDSI and MNDWI indices given the proper bands
%   Finds the indices of interest given an image and its various bands.
%   Some bands can be omitted by being sent as "NaN" to the function and
%   the relevant indices will not be calculated.
%
%INPUTS
%   G (M x N) : The green band of the image
%   R (M x N) : The red band of the image
%   NIR (M x N) : The NIR band of the image
%   SWIR (M x N) : The SWIR band of the image
%
%OUTPUTS
%   NDWI (M x N): Matrix of the NDWI index of the image
%   NDSI (M x N): Matrix of the NDWI index of the image
%   MNDWI (M x N): Matrix of the NDWI index of the image

% get the indices
NDWI = (NIR - SWIR) ./ (NIR + SWIR);
NDSI = (SWIR - R) ./ (SWIR + R);
MNDWI = (G - SWIR) ./ (G + SWIR);

% remove NaNs from division by zero errors
NDWI(isnan(NDWI)) = 0;
NDSI(isnan(NDSI)) = 0;
MNDWI(isnan(MNDWI)) = 0;

end

