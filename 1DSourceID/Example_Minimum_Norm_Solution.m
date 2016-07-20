
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel  solutionMethod ...
     pcgIters pcgTol tikhonovPar

% This script shows how the solution converges as the tikonov parameter
% decreases for the case of zero noise. The inverse  problem solution 
% converges to the  minimum norm solution.

% Consctruct data
setInputParameters();
solutionMethod = {'pcg'};
pcgIters = 1000;
pcgTol =1e-8;
noiselevel = 1e-3;
tikhonov=[0:1:18];

% Preprocessor. Mesh is generated here
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.setForceFunction(forceGenerator);
udata = generateData(noiselevel, FEModel, meaLocations);



for i=1:length(tikhonov)
    tikhonovPar =10^(-tikhonov(i));
    fsol = solveIP(udata, FEModel);
    solutionError(i) = norm(FEModel.forceMagnitude(2:end) - fsol(2:end)')^2;
end
semilogy(-tikhonov, solutionError);
title('Solution Error vs Tikhonov Parameter');
xlabel('Log of Tikhonov Parameter');
ylabel(' Relative Solution Error');
