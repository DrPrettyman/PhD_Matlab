

%% Setup

B = struct;
number_of_types = 3;

T = 1000;
delta_t = 0.01;
sample_f = 100;
t = (0:delta_t:T)';
t = t(1:sample_f:end);
N = size(t,1);
cp = @(t)@(x)(0);
initial_z = 0;
sigma = 0.3;

clear t

for i = 1:number_of_types
    B(i).T = T;
    B(i).N = N;
    B(i).sample_f = sample_f;
    B(i).delta_t = delta_t;
    B(i).cp = cp;
    B(i).initial_z = initial_z;
    B(i).sigma = @(t)sigma;
end
clear i

% A forced transition
B(1).type = '10^-2';
B(1).delta_t = 10^(-2);
B(1).sample_f = 100;

% A genuine bifurcation transition
B(2).type = '5*10^-3';
B(2).delta_t = 5*10^(-3);
B(2).sample_f = 200;

% A noise-induced transition
B(3).type = '10^-3';
B(3).delta_t = 10^(-3);
B(3).sample_f = 1000;

clear number_of_types
clear T delta_t sample_f N cp initial_z sigma

%% Calculations
number_of_types = size(B,2);

no_trials = 3;
for i = 1:number_of_types
    B(i).no_trials = no_trials;
end
clear i no_trials 

for i = 1:number_of_types
    dispmsg = ['calc type ',num2str(i),': ',B(i).type];
    disp(dispmsg)
    clear dispmsg
    B(i).Zarray =...
        zeros(B(i).N, B(i).no_trials);
    B(i).ACF1array =...
        zeros(B(i).no_trials,1);
    B(i).VARarray =...
        zeros(B(i).no_trials,1);
    B(i).wSTDarray =...
        zeros(B(i).no_trials,1);
    
    for k = 1:B(i).no_trials
        [t, z] =...
            time_series_cp(B(i).T,...
            B(i).delta_t,...
            B(i).cp,...
            B(i).initial_z,...
            B(i).sigma);
        z = z(1:B(i).sample_f:end);
        B(i).ACF1array(k) =...
            ACF(z,1);
        B(i).VARarray(k) =...
            var(z);
        w_z = zeros(size(z));
        for j = 2:size(z,1)
            w_z(j) = z(j) - z(j-1);
        end
        clear j
        B(i).wSTDarray(k) =...
            std(w_z);
        B(i).Zarray(:,k) = z;
        dispmsg = ['comp ',num2str(k),' trials'];
        disp(dispmsg)
        clear dispmsg
    end
    B(i).t =...
        t(1:B(i).sample_f:end);
    B(i).t1 =...
        linspace(0,1,B(i).N)';
    
    clear k t z w_z

    B(i).mean_acf =...
        mean(B(i).ACF1array);
    B(i).mean_var =...
        mean(B(i).VARarray);
    B(i).mean_wstd =...
        mean(B(i).wSTDarray);
    
    
    
end
clear i 
clear number_of_types 

%%
number_of_types = size(B,2);

figure 
hold on

for i = 1:number_of_types
    disp([B(i).type,', wstd= ',num2str(B(i).mean_wstd)]);
    t = linspace(0,B(i).T,size(B(i).Zarray(:,1),1));
    plot(t, B(i).Zarray(:,1));
end











