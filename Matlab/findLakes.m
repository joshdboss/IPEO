function lakeMap = findLakes(NDWI, NDWI_bounds, ...
    NDSI, NDSI_bounds, MNDWI, MNDWI_bounds, DEM, DEM_bounds)
%Finds the lakes on the image given the indices and bounds.
%   Finds all pixels on a map which contain a lake. Uses the relevant
%   indices and the given bounds for the indices that a lake should have
%   Bounds are excluded by default and as such, to include the entire
%   range, values -1 and 2 should be used for lower and upper bounds.
%   If the index is not available, it should be sent as a "1" to the
%   function, not as a "NaN"
%
%INPUTS
%   NDWI (M x N): Matrix of the NDWI index of the image
%   NDWI_bounds (1 x 2): Lower and upper bounds for the NDWI index
%   NDSI (M x N): Matrix of the NDWI index of the image
%   NDSI_bounds (1 x 2): Lower and upper bounds for the NDSI index
%   MNDWI (M x N): Matrix of the NDWI index of the image
%   MNDWI_bounds (1 x 2): Lower and upper bounds for the MNDWI index
%   DEM (M x N): Matrix of the DEM of the image
%   DEM_bounds (1 x 2): Lower and upper bounds for the DEM
%
%OUTPUTS
%   lakeMap (M x N): A binary map of the image. 1 represents a lake. 0 not.

% get the binary maps of all the indices which are correct
NDWI_correct = NDWI > NDWI_bounds(1) & NDWI < NDWI_bounds(2);
NDSI_correct = NDSI > NDSI_bounds(1) & NDSI < NDSI_bounds(2);
MNDWI_correct = MNDWI > MNDWI_bounds(1) & MNDWI < MNDWI_bounds(2);
DEM_correct = DEM > DEM_bounds(1) & DEM < DEM_bounds(2);

% for it to be a lake, all bounds must be respected
lakeMap = NDWI_correct & NDSI_correct & MNDWI_correct & DEM_correct;

end

