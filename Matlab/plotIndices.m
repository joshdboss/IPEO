function plotIndices(NDWI, NDSI, MNDWI, refMat)
%Plots the indices and their normalized versions
%   Plots the NDWI, NDSI and MNDWI indices as well as their normalized
%   versions in a figure with subplots. The function automatically
%   determines which indices need to be plotted
%
%INPUTS
%   NDWI (M x N): Matrix of the NDWI index of the image
%   NDSI (M x N): Matrix of the NDWI index of the image
%   MNDWI (M x N): Matrix of the NDWI index of the image
%   refMat : reference matrix

% see which indices to plot
plotNDWI = not(all(isnan(NDWI),'all'));
plotNDSI = not(all(isnan(NDSI),'all'));
plotMNDWI = not(all(isnan(MNDWI),'all'));
nbIdx = plotNDWI + plotNDSI + plotMNDWI; % number indices to plot

% function to normalize an image between 0 and 1
imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));

% plot only if indices present
if nbIdx ~= 0
    % create the empty figure
    figure()
    set(gcf,'Position',[100 -100 450*nbIdx 600])

    if plotNDWI
        % Unmodified NDWI index
        subplot(2,nbIdx,1);
        mapshow(NDWI, refMat)
        axis equal tight
        xlabel('Easting [m]')
        ylabel('Northing [m]')
        title('NDWI');
        
        % Normalized NDWI index
        subplot(2,nbIdx,nbIdx + 1);
        mapshow(imnorm(NDWI), refMat)
        axis equal tight
        xlabel('Easting [m]')
        ylabel('Northing [m]')
        title('Normalized NDWI');
    end
    
    if plotNDSI
        % Unmodified NDSI index
        subplot(2,nbIdx,1 + plotNDWI);
        mapshow(NDSI, refMat)
        axis equal tight
        xlabel('Easting [m]')
        ylabel('Northing [m]')
        title('NDSI');
        
        % Normalized NDSI index
        subplot(2,nbIdx,nbIdx + 1 + plotNDWI);
        mapshow(imnorm(NDSI), refMat)
        axis equal tight
        xlabel('Easting [m]')
        ylabel('Northing [m]')
        title('Normalized NDSI');
    end
    
    if plotMNDWI
        % Unmodified NDSI index
        subplot(2,nbIdx,1 + plotNDWI + plotNDSI);
        mapshow(MNDWI, refMat)
        axis equal tight
        xlabel('Easting [m]')
        ylabel('Northing [m]')
        title('MNDWI');
        
        % Normalized NDSI index
        subplot(2,nbIdx,nbIdx + 1 + plotNDWI + plotNDSI);
        mapshow(imnorm(MNDWI), refMat)
        axis equal tight
        xlabel('Easting [m]')
        ylabel('Northing [m]')
        title('Normalized MNDWI');
    end
end

end

