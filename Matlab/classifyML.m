function [classMap, accuracy, lakePrecision, lakeRecall] = ...
    classifyML(classImage, classLabels, ...
    reshp, trainedData, trainedLabels, dataMax, dataMin)
%Classifies the given image using a known labelled dataset
%   Using a known labelled image, classify another image. First
%   starts by putting the unknown image in the right format, scales it
%   and then performs the machine learning classification.
%
%INPUTS
%   classImage (M x N): The image to classify
%   classLabels (M x N): If known, the labels of the image
%   reshp (boolean): Whether or not to reshape the matrix. This should be
%   false for the validation data which is already reshaped, and true for
%   any other case
%   trainedData : The data of the pixels that have already been trained.
%       This data should already be prepared in the right format.
%   trainedLabels : The labels for each of the pixels in trainedData
%   dataMax : max values of the trained data to rescale the unknown image
%   dataMin : mib values of the trained data to rescale the unknown image
%
%OUTPUTS
%   classMap (M x N): The labels of each of the pixels on the image
%   accuracy (float) : accuracy of the model, if labels given
%   lakePrecision (float): the classification precision of the lakes
%   lakeRecall (float): the classification recall of the lakes


% Reshape the image into a 2d matrix if desired
if reshp
    data = reshape(classImage, size(classImage,1)*size(classImage,2), ...
        size(classImage,3));
else
    data = classImage;
end

% Rescale the data according to how the labelled data was scaled
data_sc = classificationScaling(double(data), dataMax, dataMin, 'std');
% Classify the image
classMap = classify(data_sc, trainedData, trainedLabels, 'linear');

% Reshape the classMap back into the shape of the image if desired
if reshp
    classMap = reshape(classMap,size(classImage,1),size(classImage,2));
end

% if there are labels, compute the accuracy
if ~all(isnan(classLabels),'all')
    C = confusionmat(classLabels, classMap);
    accuracy = sum(diag(C)) / sum(C,'all');
    lakePrecision = C(2,2) / sum(C(2,:));
    lakeRecall = C(2,2) / sum(C(:,2));
else
    accuracy = NaN;
    lakePrecision = NaN;
    lakeRecall = NaN;
end

end

