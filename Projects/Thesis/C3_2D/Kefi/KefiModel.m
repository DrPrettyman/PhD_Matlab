N = 10^3;
N=10^4;
n = 100;
n=10;

%%

f = 0.9;
m = 0.1;
delta = 0.1;
b = 0.5; % 0.3 to 1
c = 0.3;
d = 0.2;
r = 0.0001;


%%
Z = zeros(n,n,N);

Z(:,:,1) = ones(n);

for t = 1:N-1
    z = Z(:,:,t);
    
    positives = 0;
    minusNeighbours = 0;
    zeroNeighbours = 0;
    for i = 2:n-1
        for j = 2:n-1
            if z(i,j)==1
                positives = positives+1;
                neighbours = [z(i-1,j),z(i+1,j),z(i,j-1),z(i,j-1)];
                minusNeighbours = minusNeighbours + size(find(neighbours==-1),1);
                zeroNeighbours = zeroNeighbours + size(find(neighbours==0),1);
            end
        end
    end
    
    
    r_p = positives/((n-2)^2);
    q_p0 = zeroNeighbours/positives;
    q_pm = minusNeighbours/positives;
    
    w1 = (delta*r_p+(1-delta)*q_p0)*(b-c*r_p); % w_{0,+}
    w2 = m; % w_{+,0}
    w3 = d; % w_{0,-}
    w4 = r +f*q_pm; % w_{-,0}

    %
    chance = rand(n);
    
    changes=0;
    changes = changes+1;
    %
    y = z;
    for i = 1:n
        for j = 1:n
            
            if z(i,j) == 1
                if chance(i,j)<w1; y(i,j) = 0; changes = changes+1; end
            end
            
            if z(i,j) == 0
                if chance(i,j)<w2; y(i,j) = 1; changes = changes+1; end
                if chance(i,j)>1-w3; y(i,j) = -1; changes = changes+1; end
            end
            
            if z(i,j) == -1
                if chance(i,j)<w4; y(i,j) = 0; changes = changes+1; end
            end
           
        end
    end
    Z(:,:,t+1) = y;
    
end