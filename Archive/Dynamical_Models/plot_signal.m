sigma = 0.05;

t = 1:1:10;
z = -1.5:0.2:1.5;

[T,Z] = meshgrid(t,z);

U = Z.^4 - 2*Z.^2;
[DT,DZ] = gradient(U);
DU = -DZ + 1+sigma*randn(size(DZ));

quiver(T,Z,ones(size(DU)),DU)
