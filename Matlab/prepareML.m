function [data_train_sc, label_train, data_valid, label_valid,...
    dataMax, dataMin] = prepareML(refImage, indices, labels)
%Prepares the data for a supervised ML classification
%   Prepares the data from the refImage according to the indices and labels
%   obtained from the plotRoi function. Splits the data into train and
%   validation data. Also returns the training scale factor so it can be
%   applied on another dataset.
%
%INPUTS
%   refImageData (M x N x D): Relevant data to classify the M x N image.
%   Will usually contain the indices as well as slope
%   indices (Nb_poygons x 1): Structure containing the indices of
%   pixels in each of the labelled polygons/roi
%   labels (Nb_poygons x 1): Labels of the polygons
%
%OUTPUTS
%   data_train_sc : the training data, ready to use for classify()
%   label_train : the labels of the training data
%   data_valid : the validation data. NOT YET SCALED
%   label_valid : the labels of the validation data
%   dataMax : the maximum of the data_train range to scale another dataset
%   dataMin : the minimum of the data_train range to scale another dataset


% PREPARE DATA ============================================================

% Reshape the image into a 2d matrix
data = reshape(refImage, size(refImage,1)*size(refImage,2), ...
    size(refImage,3));

% Get pixels from each class mask (polygons)
data_roi = data(cell2mat(indices),:);
 
% concatenate the vector of labels
label_roi = [];

for c = 1:length(labels) % for each polygon
    % Create a vector with the label of the polygon class.
    label_roi = [label_roi; repmat(labels(c),size(indices{c},1),1)];
end

% Split into training and testing samples to evaluate performances
splt = 0.2;
trainID = randperm(length(label_roi), round(splt*length(label_roi)));
allID = [1:length(label_roi)];
testID = allID(~ismember(allID,trainID));

% Subsample the training and the validation (test) data + labels
data_train = data_roi(trainID,:);
label_train = label_roi(trainID);

data_valid = data_roi(testID,:);
label_valid = label_roi(testID);

[data_train_sc, dataMax, dataMin] = ...
    classificationScaling(double(data_train), [], [], 'std');