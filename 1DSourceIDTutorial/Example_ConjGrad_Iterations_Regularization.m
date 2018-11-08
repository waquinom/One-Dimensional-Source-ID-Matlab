% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel pcgIters solutionMethod...
    tikhonovPar sourceElements

% This script plots the error in solution versus the number of conjugate
% gradient iterations. Notice that there is an optimal number of
% iterations that produces a stable solution.

% Consctruct data
setInputParameters();
% Preprocessor. Mesh is generated here
addpath('./FEM_Helmholtz');
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator);
FEModel.createForceMassMatrix();
udata = generateData(noiselevel, FEModel, meaLocations);

solutionMethod = {'pcg'};
tikhonovPar =0;

iterations=1:200;
solutionError = zeros(1,length(iterations));
for i=1:length(iterations)
    pcgIters=iterations(i);
    fsol = solveIP(udata, FEModel);
    solutionError(i) = norm(FEModel.forceMagnitude(2:end) - fsol(2:end)')^2;
end
solutionError = solutionError/max(solutionError);
loglog(iterations, solutionError);
title('Solution Error vs Conj Grad Iterations');
xlabel('Iterations');
ylabel(' Relative Solution Error');
set(gca, 'fontsize', 18, 'fontWeight','bold');
