
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

function setInputParameters()
global L A E freqs rho  constraints ...
 meaLocations nelemns forceGenerator noiselevel eigenvalsFrac solutionMethod pcgIters ...
 pcgTol tikhonovPar regularizationOperator sourceElements

%***********************Forward Problem to Create Data*******
L = 1;
nelemns = 200;
E = 1;
A = 1;
freqs = 2;
rho = 1;
sourceElements = 200;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solutionMethod = {'pcg'}; %'svd', 'ls' or 'pcg' are the options
pcgIters = 2000;
pcgTol =1e-12;
tikhonovPar = 1e-13;
regularizationOperator={'H1'}; %H1 or L2
 eigenvalsFrac = 15; %number of eigenvalues to use 
                    %in the pseudoinverse

constraints = 1; %Node 1 will be constrained
forceGenerator=@getSinusoidalForces;

%**********************************Inverse Problem********************
%Inputs for inverse problems%
%meaLocations=[2 3 4 5 6 20 21 22 23 24 25 40 41 2 43 44 45];
meaLocations = 1:1:nelemns+1;
noiselevel= 0.005; %0.1;%; 1e-2;
%********************************************************************