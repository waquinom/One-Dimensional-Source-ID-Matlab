
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel pcgTol solutionMethod...
    tikhonovPar

% This script plots the error in solution versus the tolerance of conjugate
% gradient. Notice that there is an optimal tolerance  that produces a 
% stable solution.

% Consctruct data
setInputParameters();
% Preprocessor. Mesh is generated here
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.setForceFunction(forceGenerator);
udata = generateData(noiselevel, FEModel, meaLocations);

solutionMethod = {'pcg'};
tikhonovPar =0;
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
