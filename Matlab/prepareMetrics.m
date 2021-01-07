function [imageMetrics] = prepareMetrics(rawImage, refMat)
%Takes a raw image (bands 3-6 and DEM) and extracts the desired metrics
%   Given a raw, pansharpened image with bands 3 to 6 and the DEM, extract
%   the relevant indices that will allow proper lake identification. These
%   are the NDWI, NDSI, MNDWI, bands 4 and 5 as well as the terrain slope.
%   These indices were found to have the best results for supervised ML.
%
%INPUTS
%   rawImage (M x N x 6): A pansharpened image with the histograms matched
%   containing blue, green, red, nir and swir bands as well as the DEM
%   refMat: Reference matrix of the image.
%
%OUTPUTS
%   imageMetrics (M x N x 6): The relevant indices to allow proper lake
%   identification. Contains the NDWI, NDSI, MNDWI of the image as well as
%   bands 4 and 5 and finally the terrain slope.


% % Step 1. Increase contrast in the image bands
% % Pre-allocate matrix of the new band values for speed
% % Excludes the last index, since we are not adjusting DEM values
% adjusted_bands = zeros(size(rawImage(:,:,1:end-1))); 
% gamma = 1;
% for i = 1:size(rawImage,3)-1
%     current_band = rawImage(:,:,i);
%     % remove top and bottom 1%
%     adjusted_bands(:,:,i) = imadjust(current_band, ...
%         stretchlim(current_band(current_band ~= 0), ...
%                     [0.01 0.99]), [0,1], gamma);
% end

% Step 1. Isolate the bands for verbosity
green_band = rawImage(:,:,2);
red_band = rawImage(:,:,3);
nir_band = rawImage(:,:,4);
swir_band = rawImage(:,:,5);


% Step 2. Get the water and snow indices from the bands
[ndwi, ndsi, mndwi] = ...
    getIndices(green_band, red_band, nir_band, swir_band);


% Step 3. Filter the DEM
sigma = 2;
h3 = fspecial('gaussian', 3, sigma);
filtered_DEM = imfilter(rawImage(:,:,end),h3);


% Step 4. Get the slope
[aspect,slope,gradN,gradE] = gradientm(filtered_DEM, refMat);


% Step 5. Assemble the matrix of the relevant image data to return
imageMetrics(:,:,1) = ndwi;
imageMetrics(:,:,2) = ndsi;
imageMetrics(:,:,3) = mndwi;
imageMetrics(:,:,4) = slope;

end

