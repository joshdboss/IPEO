function classMap = classifyML(unkImage, trainedData, trainedLabels, ...
    dataMax, dataMin)
%Classifies the given dataset using a known labelled dataset
%   Using a known labelled image, classify an unknown image. First
%   starts by putting the unknown image in the right format, scales it
%   and then performs the machine learning classification.
%
%INPUTS
%   unkImage (M x N): The unlabelled, unknown image to classify
%   trainedData : The data of the pixels that have already been trained.
%       This data should already be prepared in the right format.
%   trainedLabels : The labels for each of the pixels in trainedData
%   dataMax : max values of the trained data to rescale the unknown image
%   dataMin : mib values of the trained data to rescale the unknown image
%
%OUTPUTS
%   classMap (M x N): The labels of each of the pixels on the image

% Reshape the image into a 2d matrix
data = reshape(unkImage, size(unkImage,1)*size(unkImage,2), ...
    size(unkImage,3));
% Rescale the data according to how the labelled data was scaled
data_sc = classificationScaling(double(data), dataMax, dataMin, 'std');
% Classify the image
classMap = classify(data_sc, trainedData, trainedLabels, 'linear');
% Reshape the classMap back into the shape of the image
classMap = reshape(classMap,size(unkImage,1),size(unkImage,2));

end

