function [classMap] = supervisedLearning(im, indices, labels)
%Performs supervised machine learning with the given data
%   Performs supervised machine learning using the labelled data and labels
%   to best predict the labels of the image
%
%INPUTS
%   image (M x N x D): M x N image to classify with D bands
%   indices (Nb_poygons x 1): Structure containing the indices of
%   pixels in each of the labelled polygons/roi
%   labels (Nb_poygons x 1): Labels of the polygons
%
%OUTPUTS
%   classMap (M x N): The labelled version of the image. Each pixel is
%   assigned a label according to the number of existing labels.

% Reshape the data into a 2d matrix
data = reshape(im,size(im,1)*size(im,2),size(im,3));

% Get pixels from each class mask (polygons)
data_roi = data(cell2mat(indices),:);
 
% concatenate the vector of labels
label_roi = [];

for c = 1:length(labels) % for each polygon
    % Create a vector with the label of the polygon class.
    label_roi = [label_roi; repmat(labels(c),size(indices{c},1),1)];
end

% Split into training and testing samples to evaluate performances
trainID = 1:10:length(label_roi);
testID = setdiff(1:length(label_roi),trainID);

% Subsample the training and the validation (test) data + labels
data_train = data_roi(trainID,:);
label_train = label_roi(trainID);

data_valid = data_roi(testID,:);
label_valid = label_roi(testID);

typeNorm = 'std'; % use 'std' to rescale to a unit variance and zero mean
[data_train_sc, dataMax, dataMin] = classificationScaling(double(data_train), [], [], typeNorm);

% Rescale accordingly all image pixels
% note: the parameters used on the training pixels are given as arguments in the
% function to rescale accordingly the rest of the pixels
data_sc = classificationScaling(double(data), dataMax, dataMin, typeNorm);

% The same for the validation pixels
data_valid_sc = classificationScaling(double(data_valid), dataMax, dataMin, typeNorm);

% class_gml = classify(data_sc, data_train_sc, label_train, 'linear');

% % Train a k-NN model
% k_knn = 5;
% model_knn = fitcknn(data_train_sc,label_train,'NumNeighbors',k_knn);
% % Classifying entire image for k-NN:
% class_knn = predict(model_knn,data_sc);

% Train a SVM model (fitcecoc() function is for multi-class problems)
model_svm = fitcecoc(data_train_sc,label_train);

% Performs cross-validation to tune the parameters: crossval() function
model_svm_cv = crossval(model_svm);

% Classifying entire image
class_svm = predict(model_svm_cv.Trained{1}, data_sc);

classMap = reshape(class_svm,size(im,1),size(im,2));

end

