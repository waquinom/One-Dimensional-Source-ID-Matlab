
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%
function [x, xsol, fsol, ftrue, u, utrue]=sourceIDDriverForGui()

global L A E freqs rho  constraints ...
 meaLocations nelemns forceGenerator noiselevel eigenvalsFrac...
 solutionMethod pcgIters ...
 pcgTol tikhonovPar regularizationOperator sourceElements

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
[fsol, Tmat] = solveIP(udata, FEModel);

%[U, D, V]=svd(full(Tmat));
%a=diag(D);

% figure(1)
% hold on
% plot(x, ftrue);
% %PLotting the inverse problem solution
 xsol = FEModel.ForceMesh.nodalCoord;
% plot(xsol, fsol, '--');
% 
% set(gca, 'fontsize', 18, 'fontWeight','bold');
% xlabel('X', 'fontsize', 18, 'fontWeight','bold')
% ylabel('Force', 'fontsize', 18,'fontWeight', 'bold');
% le=legend('Target Function', 'Inverse Solution');
% set(le, 'fontsize', 18, 'fontWeight','bold')

% figure(2)
 FEModel.setForceMagnitudeAndLocations(x, fsol');
 FEModel.setDistributedLoadFlag(1);
% 
  u = solveForwardProblem(FEModel, 0);
%  plot(x, abs(u(:,1)),'o');
%  hold on
%  xd = x(meaLocations);
%  plot(xd , abs(utrue));
%  set(gca, 'fontsize', 18, 'fontWeight','bold');
% xlabel('X', 'fontsize', 18, 'fontWeight','bold')
% ylabel('Disp Magnitude', 'fontsize', 18,'fontWeight', 'bold');
% le=legend('Estimated', 'Truth');
% set(le, 'fontsize', 18, 'fontWeight','bold')

 
%Error in the Solution
%solutionError = norm(ftrue(FEModel.forceLocations(2:end)) - fsol(2:end)')^2/norm(ftrue)^2
