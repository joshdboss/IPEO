function plotOverlay(background, overlay, refmat, ...
    transparency, plot_title)
%Overlays a labelled image on the background image according to a colormap
%   Plots a binary image on a background image using provided colormap
%   Each label in the overlay is associated a different color
%
%INPUTS
%   background (M x N x 3): Background image/map. Should contain 3 bands
%   overlay (M x N): binary map to overlay on top
%   refmat : The reference information to be able to map everything
%   transparency : Transparency to use for the overlay. Between 0 (fully
%   transparent) and 1 (fully opaque).

% get an rgb representation of the overlay
RGB  = im2double(label2rgb(overlay));

% plot the map
figure()
set(gcf,'Position',[100 -100 1000 500])

% without overlay
subplot(1,2,1);
mapshow(background, refmat)
axis equal tight
xlabel('Longitude')
ylabel('Lattitude')
title(plot_title);

% with overlay
subplot(1,2,2);
mapshow((1 - transparency) * background + transparency * RGB, refmat)
axis equal tight
xlabel('Longitude')
ylabel('Lattitude')
title(strcat(plot_title,' with lakes overlayed'));

end

