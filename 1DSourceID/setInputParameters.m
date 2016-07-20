
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

function setInputParameters()
global L A E freqs rho  constraints ...
 meaLocations nelemns forceGenerator noiselevel eigenvalsFrac solutionMethod pcgIters ...
 pcgTol tikhonovPar regularizationOperator sourceElements sourceFrequency

%***********************Forward Problem to Create Data*******
L = 1;
nelemns = 500;
E = 1;
A = 1;
freqs = [5];
rho = 1;
sourceElements = 10;
sourceFrequency = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solutionMethod = {'direct'}; %'svd', 'direct' or 'pcg' are the options
pcgIters = 2000;
pcgTol =1e-8;
tikhonovPar = 1e-12;
regularizationOperator={'H1'}; %H1 or L2
 eigenvalsFrac = 15; %number of eigenvalues to use 
                    %in the pseudoinverse

constraints = 1; %Node 1 will be constrained
forceGenerator=@getSinusoidalForces;

%**********************************Inverse Problem********************
%Inputs for inverse problems%
%meaLocations=[2 3 4 5 6 20 21 22 23 24 25 40 41 2 43 44 45];
meaLocations = 2:25:nelemns;
noiselevel= 1e-2; %0.1;%; 1e-2;
%********************************************************************