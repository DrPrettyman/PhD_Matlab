function [ W ] = mat_norm( input_matrix )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


W = zeros(size(input_matrix));

for i = 1:size(input_matrix,2)
    W(:,i) = input_matrix(:,i)/norm(input_matrix(:,i));
end

end

