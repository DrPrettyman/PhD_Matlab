%% Tyoesofbifurcation
%
% Integrates three bifurcating dynamical systems and caluclates the
% ACF1 and PS early warning indicators in each time series.

%% Setup

bifurcations = struct;
number_of_types = 3;

T = 1000;
delta_t = 0.01;
sample_f = 100;
t = (0:delta_t:T)';
t = t(1:sample_f:end);
N = size(t,1);
clear t

for i = 1:number_of_types
    bifurcations(i).T = T;
    bifurcations(i).N = N;
    bifurcations(i).sample_f = sample_f;
    bifurcations(i).delta_t = delta_t;
end
clear i

% Fold bifurcation
bifurcations(1).type = 'Fold bifurcation';
bifurcations(1).cp = @(t)@(z)(z^3+((t-900)/300)*z);
bifurcations(1).initial_z = 0;
bifurcations(1).sigma = @(t)0.1;

% Transcritical bifurcation
bifurcations(2).type = 'Transcritical';
bifurcations(2).cp = @(t)@(z)(z^3-((t-900)/300)*z^2);
bifurcations(2).initial_z = 0;
bifurcations(2).sigma = @(t)0.1;

% Sub-critical pitchfork
bifurcations(3).type = 'Sub-critical pitchfork';
bifurcations(3).cp = @(t)@(z)(-z^4-((t-900)/300)*z^2);
bifurcations(3).initial_z = 0;
bifurcations(3).sigma = @(t)0.1;

clear number_of_types
clear T delta_t sample_f N 

%% Calculations
number_of_types = size(bifurcations,2);

no_trials = 30;
pse_windowsize = 100;
acf_windowsize = 100;
for i = 1:number_of_types
    bifurcations(i).no_trials = no_trials;
    bifurcations(i).pse_windowsize = pse_windowsize;
    bifurcations(i).acf_windowsize = acf_windowsize;
end
clear i 
clear no_trials pse_windowsize acf_windowsize

for i = 1:number_of_types
%for i = 3:3
    dispmsg = ['calc type ',num2str(i),': ',bifurcations(i).type];
    disp(dispmsg)
    clear dispmsg
    bifurcations(i).Zarray =...
        zeros(bifurcations(i).N, bifurcations(i).no_trials);
    bifurcations(i).PSEarray =...
        zeros(bifurcations(i).N, bifurcations(i).no_trials);
    bifurcations(i).ACFarray =...
        zeros(bifurcations(i).N, bifurcations(i).no_trials);
    
    for k = 1:bifurcations(i).no_trials
        [t, z] =...
            time_series_cp(bifurcations(i).T,...
            bifurcations(i).delta_t,...
            bifurcations(i).cp,...
            bifurcations(i).initial_z,...
            bifurcations(i).sigma);
        z = z(1:bifurcations(i).sample_f:end);
        bifurcations(i).PSEarray(:,k) =...
            PSE_sliding(z,bifurcations(i).pse_windowsize);
        bifurcations(i).ACFarray(:,k) =...
            ACF_sliding(z,1,bifurcations(i).acf_windowsize);
        bifurcations(i).Zarray(:,k) = z;
        dispmsg = ['comp ',num2str(k),' trials'];
        disp(dispmsg)
        clear dispmsg
    end
    bifurcations(i).t =...
        t(1:bifurcations(i).sample_f:end);
    bifurcations(i).t1 =...
        linspace(0,1,bifurcations(i).N)';
    
    clear k t z

    bifurcations(i).mean_acf =...
        mean(bifurcations(i).ACFarray,2);
    bifurcations(i).mean_pse =...
        mean(bifurcations(i).PSEarray,2);
    
    bifurcations(i).std_acf =...
        std(bifurcations(i).ACFarray,0,2);
    bifurcations(i).std_pse =...
        std(bifurcations(i).PSEarray,0,2);
    
    
    
end
clear i 
clear number_of_types 









