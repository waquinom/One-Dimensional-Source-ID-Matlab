
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel  solutionMethod ...
    eigenvalsFrac sourceElements sourceFrequency

% This script plots the error in solution versus the number of singular
% values used for the SVD expnasion. This example illustrates the use
% of a truncated SVD as a regularizer.

% Consctruct data
setInputParameters();
nelemns = 100;
freqs = [1];
sourceElements = 100;
sourceFrequency = 1;
solutionMethod = {'svd'};
noiselevel= 0.1;

%====================================================================
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.setForceFunction(forceGenerator, sourceFrequency);
udata = generateData(noiselevel, FEModel, meaLocations);
 x = FEModel.getNodalCoord();
 utrue = solveForwardProblem(FEModel, 1);
 ftrue = FEModel.forceMagnitude;

FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator, sourceFrequency);
FEModel.createForceMassMatrix();
%=====================================================================

eigenvals=[1:1:50];
for i=1:length(eigenvals)
    eigenvalsFrac = eigenvals(i);
    fsol = solveIP(udata, FEModel);
    solutionError(i) = norm(FEModel.forceMagnitude(2:end) - fsol(2:end)')^2;
end
semilogy(eigenvals, solutionError);
title('Solution Error vs Number of Terms in SVD');
xlabel('Number of Terms in SVD');
ylabel(' Relative Solution Error');
