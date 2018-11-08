% ******************************************************************%
% 1D Wave Propagation. Helmholtz Equation.
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

clc
clear all
% 1D FE Code to Solve Helmholtz Equation

%%%%Inputs
%Inputs for Forward problem
L = 1;
nelemns = 200;
E = 1;
A = 1;
freqs = 10:1:10;
rho = 1;
%forceLocations = [nelemns + 1];
%forceMagnitude(1:length(forceLocations), 1:length(freqs)) = 1; %locations x n_freqs
constraints = 1;

% Preprocessor. Mesh is generated here
prepro = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
numForceElems = 30;
prepro.generateForceMesh(numForceElems);
prepro.setForceFunction(@getSinusoidalForces);

% Solve forward problem: assembly and solution of system of equations
assemble = true;
u = solveForwardProblem(prepro,assemble);
%
x = prepro.FEmesh.nodalCoord;

close all;
%figure(1)
%plot(freqs, u(nelemns+1,:));
figure(1)
plot(prepro.forceLocations, prepro.forceMagnitude);

 figure(2)
 plot(x, abs(u(:,1)));


 % Preprocessor. Mesh is generated here
 clear prepro
prepro = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);
prepro.setForceFunction(@getSinusoidalForces);

% Solve forward problem: assembly and solution of system of equations
u2 = solveForwardProblem(prepro,assemble);
hold
plot(x, abs(u2(:,1)),'o');
