

%% Setup

transitions = struct;
number_of_types = 3;

T = 1000;
delta_t = 0.01;
sample_f = 100;
t = (0:delta_t:T)';
t = t(1:sample_f:end);
N = size(t,1);
clear t

for i = 1:number_of_types
    transitions(i).T = T;
    transitions(i).N = N;
    transitions(i).sample_f = sample_f;
    transitions(i).delta_t = delta_t;
end
clear i

% A forced transition
transitions(1).type = 'Forced';
transitions(1).cp = @(t)@(z)(z-(tanh(0.01*(t-600))+1))^2;
transitions(1).initial_z = 0;
transitions(1).sigma = @(t)0.1;

% A genuine bifurcation transition
transitions(2).type = 'Pitchfork';
transitions(2).cp = @(t)@(z)(z^4+(3-t/200)*z^2);
transitions(2).initial_z = 0;
transitions(2).sigma = @(t)0.1;

% A noise-induced transition
transitions(3).type = 'Noise-induced';
transitions(3).cp = @(t)@(z)(z^4-3*z^2);
transitions(3).initial_z = 1;
transitions(3).sigma = @(t)(0.5*tanh(0.01*(t-600))+1.0);
transitions(3).sigma = @(t)(1.5*10^(-3)*t);

clear number_of_types
clear T delta_t sample_f N 

%% Calculations
number_of_types = size(transitions,2);

no_trials = 30;
pse_windowsize = 100;
acf_windowsize = 100;
for i = 1:number_of_types
    transitions(i).no_trials = no_trials;
    transitions(i).pse_windowsize = pse_windowsize;
    transitions(i).acf_windowsize = acf_windowsize;
end
clear i 
clear no_trials pse_windowsize acf_windowsize

for i = 1:number_of_types
%for i = 3:3
    dispmsg = ['calc type ',num2str(i),': ',transitions(i).type];
    disp(dispmsg)
    clear dispmsg
    transitions(i).Zarray =...
        zeros(transitions(i).N, transitions(i).no_trials);
    transitions(i).PSEarray =...
        zeros(transitions(i).N, transitions(i).no_trials);
    transitions(i).ACFarray =...
        zeros(transitions(i).N, transitions(i).no_trials);
    
    for k = 1:transitions(i).no_trials
        [t, z] =...
            time_series_cp(transitions(i).T,...
            transitions(i).delta_t,...
            transitions(i).cp,...
            transitions(i).initial_z,...
            transitions(i).sigma);
        z = z(1:transitions(i).sample_f:end);
        transitions(i).PSEarray(:,k) =...
            PSE_sliding(z,transitions(i).pse_windowsize);
        transitions(i).ACFarray(:,k) =...
            ACF_sliding(z,1,transitions(i).acf_windowsize);
        transitions(i).Zarray(:,k) = z;
        dispmsg = ['comp ',num2str(k),' trials'];
        disp(dispmsg)
        clear dispmsg
    end
    transitions(i).t =...
        t(1:transitions(i).sample_f:end);
    transitions(i).t1 =...
        linspace(0,1,transitions(i).N)';
    
    clear k t z

    transitions(i).mean_acf =...
        mean(transitions(i).ACFarray,2);
    transitions(i).mean_pse =...
        mean(transitions(i).PSEarray,2);
    
    transitions(i).std_acf =...
        std(transitions(i).ACFarray,0,2);
    transitions(i).std_pse =...
        std(transitions(i).PSEarray,0,2);
    
    
    
end
clear i 
clear number_of_types 









