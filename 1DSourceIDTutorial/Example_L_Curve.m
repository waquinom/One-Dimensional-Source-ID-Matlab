
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel  solutionMethod ...
     pcgIters pcgTol tikhonovPar sourceElements

% This script is used to construct the L curve for the source ID problem.
%The point of maximum curvature indicates the optimal regularization parameter.


% Consctruct data
setInputParameters();

solutionMethod = {'ls'};
pcgIters = 1000;
pcgTol =1e-8;
noiselevel = 1e-1;
tikhonov=0:0.1:10;

% Preprocessor. Mesh is generated here
addpath('./FEM_Helmholtz');
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator);
FEModel.createForceMassMatrix();
udata = generateData(noiselevel, FEModel, meaLocations);
J = zeros(1,length(tikhonov));
RegOp = zeros(1,length(tikhonov));
for i=1:length(tikhonov)
    tikhonovPar =10^(-tikhonov(i));
    [fsol, T, R] = solveIP(udata, FEModel);
     J(i) = norm(T*fsol - udata');
     RegOp(i) =norm(R * fsol);
end
loglog(J, RegOp);
title('LCurve');
ylabel('Log of Regulazation Norm');
xlabel('Log of Objective Function');
