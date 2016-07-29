
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel  solutionMethod ...
    tikhonovPar  sourceElements sourceFrequency

% This script is used to construct the L curve for the source ID problem.
%The point of maximum curvature indicates the optimal regularization parameter.


% Consctruct data
setInputParameters();

nelemns = 100;
freqs = [1];
sourceElements = 100;
sourceFrequency = 1;

solutionMethod = {'direct'};
tikhonov=[0:0.5:12];

% Preprocessor. Mesh is generated here
% Preprocessor. Mesh is generated here
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
    [fsol, T, R] = solveIP(udata, FEModel);
     J(i) = norm(T*fsol - udata');
     RegOp(i) =norm(R * fsol);
end
loglog(J, RegOp);
title('LCurve');
ylabel('Log of Regulazation Norm');
xlabel('Log of Objective Function');
