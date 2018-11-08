% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%
function [ umeasured ] = generateData(noiselevel, FEModel, meaLocations)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%global L nelemns

% Generate data
n =length(meaLocations);
um = solveForwardProblem(FEModel, 1);
%figure (1)
%x=0:L/nelemns:L;
umeasured(1:n)=0;
for i=1:n
    umeasured(i) = um(meaLocations(i))*(1+noiselevel*randn);
end


end

