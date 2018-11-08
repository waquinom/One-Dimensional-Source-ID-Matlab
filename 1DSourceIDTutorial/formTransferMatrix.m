% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%

function [ T ] = formTransferMatrix(FEModel, meaLocations)
%[ T ] = formTransferMatrix(forceLocations, FEModel)
%   Detailed explanation goes here

nFlocs = length(FEModel.forceLocations);
nMeasLocs = length(meaLocations);
numNodes = length(FEModel.getNodalCoord());

T(1:nMeasLocs, 1:nFlocs) = 0;
if (FEModel.distributedLoad)
    B =  FEModel.Mf;
else
    B  = eye(numNodes,nFlocs);
end


numFreqs = length(FEModel.frequencies);
for i=1:numFreqs
    omega = 2 * pi * FEModel.frequencies(i);
    
    H =FEModel.K - FEModel.density * omega^2 * FEModel.M;
    
    applyConstraints(H, B, FEModel);
    
    Tfull =  H \ B;
    %extract influence at measured locations
    T = Tfull(meaLocations,:);
end

end







function A =applyConstraints(A, B, prepro)

% Apply constraints
for i=1:length(prepro.constraints)
    A(prepro.constraints(i),:) = 0;
    A(:,prepro.constraints(i)) = 0;
    A(prepro.constraints(i),prepro.constraints(i))=1;
    
    B(prepro.constraints(i),:) = 0;
    B(:,prepro.constraints(i)) = 0;
    B(prepro.constraints(i),prepro.constraints(i))=1;
end

end