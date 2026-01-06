

%% Setup

T = 1;
delta_t = 0.01;
sample_f = 1;
cp = @(t)@(x)(0);
initial_z = 0;

sigma_vals = linspace(0,1,50)';
wstd_vals = zeros(size(sigma_vals));
no_tests = size(sigma_vals,1);

no_trials = 6;

options=odeset('AbsTol', 10^(-5));

%% Calculations
for i = 1:no_tests
    dispmsg = ['calc ',num2str(i)];
    disp(dispmsg)
    clear dispmsg
    
    wSTDarray =...
        zeros(no_trials,1);
    
    for k = 1:no_trials
        [t, z] =...
            ode45(@(t,x)(sigma_vals(i)*randn(1,1)),...
            (0:delta_t:T),0,options);
        z = z(1:sample_f:end);

        w_z = zeros(size(z));
        for j = 2:size(z,1)
            w_z(j) = z(j) - z(j-1);
        end
        clear j
        wSTDarray(k) =...
            std(w_z);
    end 
    clear k t z w_z

    wstd_vals(i) = mean(wSTDarray);
    
end
clear i 
clear options

%%

figure
hold on
%plot(sigma_vals,sigma_vals)
plot(sigma_vals,wstd_vals.^2/(delta_t)^2)











