
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel  solutionMethod ...
     tikhonovPar sourceElements sourceFrequency

% This script shows how the solution converges as the tikonov parameter
% decreases for the case of zero noise. The inverse  problem solution 
% converges to the  minimum norm solution.

% Consctruct data
setInputParameters();
nelemns = 100;
freqs = [1];
sourceElements = 100;
sourceFrequency = 1;
solutionMethod = {'direct'};
noiselevel = 0;
tikhonov=[0:1:15];

FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.setForceFunction(forceGenerator, sourceFrequency);
udata = generateData(noiselevel, FEModel, meaLocations);
 x = FEModel.getNodalCoord();
 utrue = solveForwardProblem(FEModel, 1);
 ftrue = FEModel.forceMagnitude;


FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator, sourceFrequency);
FEModel.createForceMassMatrix();


for i=1:length(tikhonov)
    tikhonovPar =10^(-tikhonov(i));
    fsol = solveIP(udata, FEModel);
    solutionError(i) = norm(FEModel.forceMagnitude(2:end) - fsol(2:end)')^2;
end
semilogy(-tikhonov, solutionError);
title('Solution Error vs Tikhonov Parameter');
xlabel('Log of Tikhonov Parameter');
ylabel(' Relative Solution Error');
