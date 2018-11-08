
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel  solutionMethod ...
    eigenvalsFrac sourceElements

% This script plots the error in solution versus the number of singular
% values used for the SVD expnasion. This example illustrates the use
% of a truncated SVD as a regularizer.

% Consctruct data
setInputParameters();
solutionMethod = {'svd'};
noiselevel= 0.1;

% Preprocessor. Mesh is generated here
addpath('./FEM_Helmholtz');
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator);
FEModel.createForceMassMatrix();
udata = generateData(noiselevel, FEModel, meaLocations);

eigenvals=1:50;
solutionError = zeros(1,length(eigenvals));
for i=1:length(eigenvals)
    eigenvalsFrac = eigenvals(i);
    fsol = solveIP(udata, FEModel);
    solutionError(i) = norm(FEModel.forceMagnitude(2:end) - fsol(2:end)')^2;
end
semilogy(eigenvals, solutionError);
title('Solution Error vs Number of Terms in SVD');
xlabel('Number of Terms in SVD');
ylabel(' Relative Solution Error');
