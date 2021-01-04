function plotOverlay(background, overlay, refmat, colormap, ...
    transparency, plot_title)
%Overlays a binary image on the background image according to a colormap
%   Plots a binary image on a background image using provided colormap
%
%INPUTS
%   background (M x N x 3): Background image/map. Should contain 3 bands
%   overlay (M x N): binary map to overlay on top
%   refmat : The reference information to be able to map everything
%   colormap (2 x 3): Colormap to use to plot the binary image
%   transparency : Transparency to use for the overlay. Between 0 (fully
%   transparent) and 1 (fully opaque).

% get an rgb representation of the overlay
RGB  = ind2rgb(overlay + 1, colormap);

% plot the map
figure()
set(gcf,'Position',[100 -100 600 400])

mapshow(background + transparency * RGB, refmat)
axis equal tight
xlabel('Easting [m]')
ylabel('Northing [m]')
title(plot_title);

end

