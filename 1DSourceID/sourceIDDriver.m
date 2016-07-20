
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%
clc
clear all
close all

global L A E freqs rho  constraints ...
    meaLocations nelemns forceGenerator noiselevel sourceElements ...
    sourceFrequency

% Conctruct data
setInputParameters();
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
fsol = solveIP(udata, FEModel);



figure(2)
hold on
plot(x, ftrue);
%PLotting the inverse problem solution
xsol = FEModel.ForceMesh.nodalCoord;
plot(xsol, fsol, '--');

figure(3)
FEModel.setForceMagnitudeAndLocations(x, fsol');
FEModel.setDistributedLoadFlag(1);

 u = solveForwardProblem(FEModel, 0);
 plot(x, abs(u(:,1)),'o');
 hold on
 xd = x(meaLocations);
 plot(x , abs(utrue));

 
%Error in the Solution
%solutionError = norm(ftrue(FEModel.forceLocations(2:end)) - fsol(2:end)')^2/norm(ftrue)^2
