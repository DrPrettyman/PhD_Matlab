function [ Y ] = remove_oscilations( X, wavelength )
% if there is no specified wavelength, 
% pass to the function find_wavelength
if nargin < 2
    j = find_wavelength(X);
else
    j = wavelength;
end

% remove the oscilating trend from the data
Y = zeros(size(X));
for i = 1:j
    Y(i:j:end) = X(i:j:end) - mean(X(i:j:end));
end

%% plot, if you like
%figure 
%hold on
%plot(X)
%plot(Y)
%hold off

end

%% Function to find wavelength if unspecified
function [ j ] = find_wavelength(X)
%   create the power spectrum of X
f = abs(fft(X));
plot(f)
f = f(2:floor(end/2));


%   identify where the peak lies in the PS
peak = find(f == max(f)) ; % +1? because we skip the first one with (2:end/2)
disp(['peak at ' num2str(peak)])

%  thus find the 'wave-length' j
j = floor(size(X,1)/peak); % maybe if we use floor we don't need +1 above
disp(['wave-length = ' num2str(j)])

end
