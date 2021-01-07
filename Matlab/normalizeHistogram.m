function [normImage] = normalizeHistogram(rawImage, refImage)
%Normalizes the histograms and optionally performs histogram matching
%   Normalizes the histograms of each band (except the last, which contains
%   the DEM) of the rawImage. If a refImage is provided, then the
%   histograms of the rawImage are adjusted to match those of the refImage.
%
%INPUTS
%   rawImage (M x N x B): raw image on which the histogram should be normed
%   refImage (M x N x B): normalized reference image that will be used to
%   match the histograms of the raw image. Optional, input "NaN" to simply
%   normalize rawImage.
%
%OUTPUTS
%   normImage (M x N x B): normalized and optionally matched image

% initialize the normalized image
normImage = zeros(size(rawImage));
normImage(:,:,end) = rawImage(:,:,end);

% go through all the bands (except the last, which contains the DEM)
for i = 1:size(rawImage,3)-1
    raw_uint8 = im2uint8(rawImage(:,:,i)); % get the raw image as a uint8
    
%     % adjust the image to remove top and bottom 1%
%     raw_uint8 = imadjust(raw_uint8, ...
%          stretchlim(raw_uint8(raw_uint8 ~= 0), ...
%                      [0.01 0.99]), [0,1], 1);
    
    % Compute the histogram, then CDF of the raw Image
    [counts_raw, ~] = imhist(raw_uint8,256);
    cdf_raw = cumsum(counts_raw,1) / sum(counts_raw,1);
    
    
    % check if there is a reference
    if all(isnan(refImage),'all')
        % if none, simply normalize the histogram
        raw_equ = cdf_raw(raw_uint8(:)+1);
    else % if there is one, perform histogram matching
        ref_uint8 = im2uint8(refImage(:,:,i)); % get the ref image as uint8
        
        % Compute the histogram, then CDF of the reference equalized image
        [counts_ref, ~] = imhist(ref_uint8, 256);
        cdf_ref = cumsum(counts_ref,1) / sum(counts_ref,1);

        % Build a look-up table between the two CDFs 
        [cdf_ref_unique, id_unique] = unique(cdf_ref);
        LUT = interp1(cdf_ref_unique, id_unique, cdf_raw(id_unique)); 
        % remove duplicates in the CDF in interp1 function
        LUT2 = interp1(id_unique, LUT, 0:255,'linear','extrap');

        % Apply the LUT to the raw image
        raw_equ = uint8(LUT2(raw_uint8(:)+1));
        raw_equ = im2double(raw_equ);
    end
    
    % Put the mapped pixels back into the image
    normImage(:,:,i) = reshape(raw_equ,size(raw_uint8));
end

end

