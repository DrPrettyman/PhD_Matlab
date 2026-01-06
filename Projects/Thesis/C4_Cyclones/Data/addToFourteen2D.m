%%

load('fourteen2D.mat')

%%
% windowsizes:
ws_PS = 102;
ws_ACF1 = 90;
ws_WL = 90;

% weights:
weights_EOFPS = [0.5, 0.5];
weights_EOFACF = [0.4, 0.6];
weights_WL  = [0.5, 0.5];

%% Calculate the EOF score of the two varaibles

for cy = 1:14 %for each cyclone
    disp(fourteen2D(cy).h_name)
    % place the two variables into an array
    X = zeros(size(fourteen2D(cy).slp,1),2);
    X(:,1) = fourteen2D(cy).slp;
    X(:,2) = fourteen2D(cy).windspeed;
    
    fourteen2D(cy).EOF_PS =...
        EOF_sliding(X, ws_PS, 'PS', weights_EOFPS);
    fourteen2D(cy).EOF_ACF1 =...
        EOF_sliding(X, ws_ACF1, 'ACF1', weights_EOFACF);
    
    
    fourteen2D(cy).EOFu_PS =...
        EOF_sliding_upto(X, ws_PS, 'PS', weights_EOFPS);
    fourteen2D(cy).EOFu_ACF1 =...
        EOF_sliding_upto(X, ws_ACF1, 'ACF1', weights_EOFACF);
    
end

%% for the mean and std

hugeEOF_PS    = zeros(1321,14);
hugeEOF_ACF1  = zeros(1321,14);
hugeEOFu_PS   = zeros(1321,14);
hugeEOFu_ACF1 = zeros(1321,14);
for cy = 1:14 %for each cyclone
    hugeEOF_PS(:,cy) = fourteen2D(cy).EOF_PS;
    hugeEOF_ACF1(:,cy) = fourteen2D(cy).EOF_ACF1;
    hugeEOFu_PS(:,cy) = fourteen2D(cy).EOFu_PS;
    hugeEOFu_ACF1(:,cy) = fourteen2D(cy).EOFu_ACF1;
end

fourteen2D(15).EOF_PS = mean(hugeEOF_PS,2);
fourteen2D(15).EOF_ACF1 = mean(hugeEOF_ACF1,2);
fourteen2D(15).EOFu_PS = mean(hugeEOFu_PS,2);
fourteen2D(15).EOFu_ACF1 = mean(hugeEOFu_ACF1,2);

fourteen2D(16).EOF_PS = std(hugeEOF_PS,0,2);
fourteen2D(16).EOF_ACF1 = std(hugeEOF_ACF1,0,2);
fourteen2D(16).EOFu_PS = std(hugeEOFu_PS,0,2);
fourteen2D(16).EOFu_ACF1 = std(hugeEOFu_ACF1,0,2);


%% Calculate the Jacobian eigenvalues of the two varaibles

T_end = size(fourteen2D(1).slp,1)-1;
for cy = 1:14 %for each cyclone
    disp(fourteen2D(cy).h_name)
    % place the two variables into an array
    B = zeros(size(fourteen2D(cy).slp,1),2);
    B(:,1) = fourteen2D(cy).slp;
    B(:,2) = fourteen2D(cy).windspeed;
    Z = B ./ (ones(size(B,1),1)*std(B,1));
    X = Z .* (ones(size(Z,1),1)*weights_WL);
    
    Output = plot_eigenvals_Jacobian(X, T_end, ws_WL, 1, false);
    
    fourteen2D(cy).WL_real = Output(:,2);
    fourteen2D(cy).WL_imag = Output(:,3);
end

%% for the mean and std

hugeWL_real = zeros(1321,14);
hugeWL_imag = zeros(1321,14);
for cy = 1:14 %for each cyclone
    hugeWL_real(:,cy) = fourteen2D(cy).WL_real;
    hugeWL_imag(:,cy) = fourteen2D(cy).WL_imag;
end

fourteen2D(15).WL_real = mean(hugeWL_real,2);
fourteen2D(15).WL_imag = mean(hugeWL_imag,2);

fourteen2D(16).WL_real = std(hugeWL_real,0,2);
fourteen2D(16).WL_imag = std(hugeWL_imag,0,2);

    