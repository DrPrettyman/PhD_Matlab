%load('fourteen2D')
%load('indicators1D')

%%

t0 = 1200 - 300;
t1 = 1200;

T_end = 300;

weightings = linspace(0.1,0.9,100)';

for cy = 1:14
    disp(fourteen2D(cy).h_name)
    holder_re = zeros(t1-t0+1, size(weightings,1));
    holder_im = zeros(t1-t0+1, size(weightings,1));
    for i = 1:size(weightings,1)   
        weights = [weightings(i),1-weightings(i)];
        
        B = [fourteen2D(cy).slp(t0:t1) , fourteen2D(cy).windspeed(t0:t1)];
        Z = B ./ (ones(size(B,1),1)*std(B,1));
        X = Z .* (ones(size(Z,1),1)*weights);
        
        Output = plot_eigenvals_Jacobian(X, T_end, ws_WL, 1, false);
        
        holder_re(:,i) = Output(:,2);
        holder_im(:,i) = Output(:,3);
        
        if mod(i,10)==0; disp(num2str(i)); end
        
    end
    fourteen2D(cy).WeightSensitivity_WLre = holder_re;
    fourteen2D(cy).WeightSensitivity_WLim = holder_im;
end

%% Add the mean

huge3Darray_re = zeros(301,100,14);
huge3Darray_im = zeros(301,100,14);

for i = 1:14
    
    huge3Darray_re(:,:,i) = fourteen2D(cy).WeightSensitivity_WLre;
    huge3Darray_im(:,:,i) = fourteen2D(cy).WeightSensitivity_WLim;
end

mean_re = mean(huge3Darray_re,3);
mean_im = mean(huge3Darray_im,3);

newIndex = 15;

fourteen2D(newIndex).WeightSensitivity_WLre = mean_re;
fourteen2D(newIndex).WeightSensitivity_WLim = mean_im;


