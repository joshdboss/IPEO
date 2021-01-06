function [processedLakeMap] = postprocess(rawLakeMap)
%Performs post-processing operations on the lake map obtained
%   Performs some post-processing on the binary lake map obtained.
%   As of now, includes morphology to fill gaps in lakes that are due to
%   artefacts in the ML process and removing lakes that are too small.
%
%INPUTS
%   rawLakeMap (M x N): Binary map of where the lakes are located
%
%OUTPUTS
%   processedLakeMap (M x N): New binary map of the lakes after processing
%   has been performed.

% Step 1. Perform morphology to fill gaps in lakes.
%   A non-reconstructive closing morpology filter is used. Reconstructive
%   might be better and preserve shape better, however it has been found to
%   not be as efficient/correct.

% Define the shape for the morphology. Disk as lakes do not have a prefered
% shape. Could be verified in a future project
SE = strel('disk',3); % 'diamond' 'square'
% Morphology works best with uint8
im_uint8 = uint8(255 * mat2gray(rawLakeMap));

% Performing Erosion. Not used
%Im_e = imerode(im_uint8,SE);
% Performing Dilation
Im_d = imdilate(im_uint8,SE);

% Reconstructive closing. Not used
% Im_cr = imcomplement(imreconstruct(imcomplement(Im_d), ...
%  imcomplement(im_uint8)));
% Non-reconstructive closing
Im_cl = imclose(im_uint8,SE);


% Step 2. Remove lakes that are too small.
% Articles were using 4 pixels with a 30m size.
% We have a 19m resolution, so will go a bit higher
minimum_lake_size = 7;
processedLakeMap = bwareaopen(Im_cl,minimum_lake_size);

end

