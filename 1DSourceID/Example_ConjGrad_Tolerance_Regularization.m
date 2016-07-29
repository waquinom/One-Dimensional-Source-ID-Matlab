
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel pcgTol solutionMethod...
    tikhonovPar  sourceElements sourceFrequency

% This script plots the error in solution versus the tolerance of conjugate
% gradient. Notice that there is an optimal tolerance  that produces a 
% stable solution.

% Consctruct data
setInputParameters();

% Preproc
nelemns = 100;
freqs = [1];
sourceElements = 100;
sourceFrequency = 1;
solutionMethod = {'pcg'};
tikhonovPar =0;

FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.setForceFunction(forceGenerator, sourceFrequency);
udata = generateData(noiselevel, FEModel, meaLocations);
 x = FEModel.getNodalCoord();
 utrue = solveForwardProblem(FEModel, 1);
 ftrue = FEModel.forceMagnitude;


FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator, sourceFrequency);
FEModel.createForceMassMatrix();

tolerance=0:1:10;
for i=1:length(tolerance)
    pcgTol=10^(-tolerance(i));
    fsol = solveIP(udata, FEModel);
    solutionError(i) = norm(FEModel.forceMagnitude(2:end) - fsol(2:end)')^2;
end
semilogy(tolerance, solutionError);
title('Solution Error vs Conj Grad Tolerance');
xlabel('CG Tolerance');
ylabel(' Relative Solution Error');
