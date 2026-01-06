function [ SlidingArg ] = Cov( X, windowSize )
%COV Summary of this function goes here
%   Detailed explanation goes here

SlidingArg = zeros(size(X,1),1);

for i = (windowSize+1):size(X,1)
    section = X((i-windowSize):i,:);
    
    section = section - ones(size(section,1),1)*mean(section);
    
    [vec,val] = eig(cov(section));
    val = diag(val);
    principalVector = vec(:,val==max(val));
    
    Arg = abs(atan(principalVector(2)/principalVector(1)))/(pi/2);
    
    SlidingArg(i) = Arg;
    
end

end

