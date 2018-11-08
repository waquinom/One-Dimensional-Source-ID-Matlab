
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%
function [x, xsol, fsol, ftrue, u, utrue, alpha]=discrepanyPrinciple()

global L A E freqs rho  constraints ...
 meaLocations nelemns forceGenerator noiselevel eigenvalsFrac...
 solutionMethod pcgIters ...
 pcgTol tikhonovPar regularizationOperator sourceElements udata FEModel

addpath(genpath('./FEM_Helmholtz'));
% Conctruct data
%setInputParameters();
% Preprocessor. Mesh is generated here
FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
FEModel.setForceFunction(forceGenerator);
udata = generateData(noiselevel, FEModel, meaLocations);
 x = FEModel.getNodalCoord();
 utrue = solveForwardProblem(FEModel, 1);
 ftrue = FEModel.forceMagnitude;


FEModel.generateForceMesh(sourceElements);
FEModel.setForceFunction(forceGenerator);
FEModel.createForceMassMatrix();

[alpha, val] = fzero(@discrepancyFun, [0 10]);
%alpha=0.00001;
tikhonovPar = alpha; 
[fsol, Tmat] = solveIP(udata, FEModel);


 xsol = FEModel.ForceMesh.nodalCoord;


 FEModel.setForceMagnitudeAndLocations(x, fsol');
 FEModel.setDistributedLoadFlag(1);
% 
  u = solveForwardProblem(FEModel, 0);
