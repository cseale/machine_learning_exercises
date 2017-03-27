function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.1;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%


% all_C = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30];
% all_sigma = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30];

% [A,B] = meshgrid(all_C,all_sigma);
% c=cat(2,A',B');
% d=reshape(c,[],2);

% num_options = size(d, 1)
% prediction_error = zeros(4, 1);

% for i = 1:num_options
%     fprintf('training with C of %2.2f and sigma %2.2f\n', d(i,1), d(i,2));
%     model= svmTrain(X, y, d(i,1), @(x1, x2) gaussianKernel(x1, x2, d(i,2)));
%     predictions = svmPredict(model, Xval);
%     prediction_error(i) = mean(double(predictions ~= yval));
% end

% [C sigma] = d(find(prediction_error == min(prediction_error), 1), :)

% =========================================================================

end
