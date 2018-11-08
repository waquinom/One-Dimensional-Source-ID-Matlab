function [ error ] = discrepancyFun(alpha)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global noiselevel   ...
  tikhonovPar  udata FEModel

tikhonovPar = alpha;

[fsol, Tmat] = solveIP(udata, FEModel);
error = norm(Tmat*fsol - udata')^2-noiselevel^2;
end

