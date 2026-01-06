function y = changing_noise_generator( N , steps, alpha0, alpha1, plot )

tol=0.01;
if nargin<4
    plot = false;
end

alphas = linspace(alpha0, alpha1, steps);

y = zeros(N*steps, 1);

newnoise = noise_generator(N, alphas(1));
while abs(PSE_new(newnoise')-alphas(1))>tol
    newnoise = noise_generator(N, alphas(1));
end

y(1:N) = newnoise';

for i = 2:steps
    newnoise = noise_generator(N, alphas(i));
    while abs(PSE_new(newnoise')-alphas(i))>tol
        newnoise = noise_generator(N, alphas(i));
    end
    %disp([num2str(alphas(i)), ' : ', num2str(PSE_new(newnoise'))])
    
    difference = newnoise(1) - y(N*(i-1));
    
    newnoise = newnoise - difference;
    
    y((N*(i-1)+1):(N*i)) = newnoise';
    
end

end