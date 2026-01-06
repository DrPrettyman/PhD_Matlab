
%% Calculate
system = 1;
mu_vals = [2, 1, 0.5];
%mu_vals = [-1, 0, 1];
S = struct;
for i=1:numel(mu_vals)
    mu0 = mu_vals(i);
    % integrate starting close to the saddle
    if system == 1
        f = @(x,t)([x(2); (mu0*x(1)-x(1)^2)]); 
        x0 = [mu0-0.5;0];
        saddle = [0;   0];
        fixed  = [mu0; 0];
    elseif system == 2
        f = @(x,t)([-x(1)+2*x(2)+x(1)^2;...
            (2-mu0)*x(1)-x(2)-3*x(1)^2+1.5*x(1)*x(2)]);
        x0 = [0.1;0];
        saddle = [0; 0];
        fixedx = (-7/6) + (1/6)*sqrt(121-48*mu0); % could be + or - before sqrt
        fixed = [fixedx; (fixedx-fixedx^2)/2];
        clear fixedx
    end
    sigma = [0;0];
    tBounds = [0 50];
    delta_t = 10^(-3);
    [t,Z] = milstein(f, sigma, x0, tBounds, delta_t,10);
    i1=min(2*find(Z(2,:)<Z(2,1),1), size(Z,2)); % index of first return
    if isempty(i1); i1=size(Z,2); end
    xlimits = [-0.2*max(Z(1,1:i1)) 1.2*max(Z(1,1:i1))];
    ylimits = 1.2*[min(Z(2,1:i1)), max(Z(2,1:i1))];
    % Phase portrait
    xdom = linspace(xlimits(1),xlimits(2),11);
    ydom = linspace(ylimits(1),ylimits(2),11);
    [X,Y] = meshgrid(xdom,ydom); % generate mesh of domain
    if system == 1
        U=(Y); V=(X.*(mu0 - X));     % dx/dt and dy/dt
    elseif system == 2
        U=(-X+2*Y+X.^2); V=((2-mu0)*X-Y-3*X.^2+1.5*X.*Y);
    end

    S(i).mu0 = mu0;
    S(i).t = t; S(i).Z = Z;
    S(i).saddle = saddle;
    S(i).fixed = fixed;
    S(i).xlimits = xlimits; S(i).ylimits = ylimits;
    S(i).Quiv = {X,Y,U,V};
end

%% Plot

N=size(S,2);
a = zeros(1,N);
figure
for i = 1:N
    a(i) = subplot(1,N,i);
    hold on
    quiver(a(i),S(i).Quiv{1},S(i).Quiv{2},S(i).Quiv{3},S(i).Quiv{4}, 'Color', 'k')
    plot(a(i),S(i).saddle(1), S(i).saddle(2), 'Marker', 'x','Color', 'k', 'MarkerSize',15)
    plot(a(i),S(i).fixed(1), S(i).fixed(2), 'Marker', 's','Color', 'k', 'MarkerSize',15)
    plot(a(i),S(i).Z(1,:),   S(i).Z(2,:), 'Color', 'red')
    plot(a(i),S(i).Z(1,end), S(i).Z(2,end), 'Marker', 'o')
    xlim(S(i).xlimits)
    %xlim([-2,2])
    ylim(S(i).ylimits)
    xlabel('x')
    ylabel('y')
end