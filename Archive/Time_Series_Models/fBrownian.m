function Brown = fBrownian(H, len)

% create fractional brownian noise

% set the default length to about 16000
if nargin < 2
    len = 2^14;
end

% find the maximum power of 2
pow2 = floor(log2(len));

% create the output with zeros and a random last entry
Brown = zeros(2^pow2 +1, 1);
Brown(end) = randn(1,1);

% calculate the scaling factors
scaleFactor = zeros(pow2,1);
scaleFactor(1) = sqrt( 1/(2^(2*H)) - 1/4 );
for i = 2:pow2 
    scaleFactor(i) = scaleFactor(i-1)*(1/2^H);
end

for j = 1:pow2
    % create a list of indices
    a = 2^(pow2-j+1) .* (0:(2^(j-1)))';
    
    % for each pair of indices (c1, c2), take the index 
    % inbetween (cnew) and give it a value by ofsetting 
    % the mean of above and below. 
    for k = 1:size(a,1)-1
        c1 = a(k);
        c2 = a(k+1);
        cnew = (c1+c2)/2;
        
        Brown(cnew+1) = 0.5*(Brown(c1+1) + Brown(c2+1)) ...
            + scaleFactor(j)*randn(1,1);
        
        clear c1 c2 cnew
    end
    
    clear a
end

Brown = Brown*2^(pow2*H);

return
