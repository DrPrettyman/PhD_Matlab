%load('fourteen2D')
%load('indicators1D')

%%

t0 = 1200 - 300;
t1 = 1200;

weightings = linspace(0,1,100)';
windowSizePS   = 102;
windowSizeACF1 = 90;

for cy = 1:14
    disp(fourteen2D(cy).h_name)
    holderPS   = zeros(t1-t0+1, size(weightings,1));
    holderACF1 = zeros(t1-t0+1, size(weightings,1));
    for i = 1:size(weightings,1)   
        weights = [weightings(i),1-weightings(i)];
        X = [fourteen2D(cy).slp(t0:t1) , fourteen2D(cy).windspeed(t0:t1)];
        EOFoutPS   = EOF_sliding(X, windowSizePS, 'PS', weights);
        EOFoutACF1 = EOF_sliding(X, windowSizeACF1, 'ACF1', weights);
        
        holderPS(:,i)   = EOFoutPS;
        holderACF1(:,i) = EOFoutACF1;
        
        if mod(i,10)==0; disp(num2str(i)); end
        
    end
    fourteen2D(cy).WeightSensitivityPS   = holderPS;
    fourteen2D(cy).WeightSensitivityACF1 = holderACF1;
end

%% Add the mean

huge3DarrayACF1 = zeros(301,100,14);
huge3DarrayPS   = zeros(301,100,14);

for i = 1:14
    
    huge3DarrayACF1(:,:,i) = fourteen2D(cy).WeightSensitivityACF1;
    huge3DarrayPS(:,:,i) = fourteen2D(cy).WeightSensitivityPS;
end

meanACF1 = mean(huge3DarrayACF1,3);
meanPS   = mean(huge3DarrayPS,3);

newIndex = 15;

fourteen2D(newIndex).h_name = 'mean';
fourteen2D(newIndex).WeightSensitivityACF1 = meanACF1;
fourteen2D(newIndex).WeightSensitivityPS   = meanPS;


