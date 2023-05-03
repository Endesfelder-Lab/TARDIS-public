function [fy] = laur(y,alpha,beta,n)
% This function creates distributions for D* generated by localization
% error. It uses equations from the sum of correlated gamma functions taken
% from Paris, J. F. A Note on the Sum of Correlated Gamma Random Variables.

% inputs:
% - y 
% - beta: localization error^2/(frametime*#steps) 
% Outputs:
% - fy: the pdf of the localization error
% was created by Jochem Vink 01-08-2019

D = beta*eye(n);
corrskew = 0;           % There can also be correlation between frames further than one step apart because of different intensities of particles, can correct for this by increasing corrskew (between 0-1).
C = [1 sqrt(1/4+3/4*corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew);sqrt(1/4+3/4*corrskew) 1 sqrt(1/4+3/4*corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew);sqrt(corrskew) sqrt(1/4+3/4*corrskew) 1 sqrt(1/4+3/4*corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew); sqrt(corrskew) sqrt(corrskew) sqrt(1/4+3/4*corrskew) 1 sqrt(1/4+3/4*corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew);sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(1/4+3/4*corrskew) 1 sqrt(1/4+3/4*corrskew) sqrt(corrskew) sqrt(corrskew);sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(1/4+3/4*corrskew) 1 sqrt(1/4+3/4*corrskew) sqrt(corrskew); sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(1/4+3/4*corrskew) 1 sqrt(1/4+3/4*corrskew); sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(corrskew) sqrt(1/4+3/4*corrskew) 1]; % The correlation matrix

C = C(1:n,1:n); % The correlation matrix only for numbers of frames 
A = D*C;
detA = det(A);
eigenvalues = eig(A);
bvector = alpha*ones(n,1);

for i = 1:length(y)
for j = 1:n
xvector(i,j) = -y(i)/eigenvalues(j);
end
end

if n ==2
N = round(100000/n);
else
N = round(50000/n); 
end
c = n*alpha;
fy = (y.^(-1+n*alpha))/(detA^alpha*gamma(1)).*Phi2(bvector,c,xvector,N)';