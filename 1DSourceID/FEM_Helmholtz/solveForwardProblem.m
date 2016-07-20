function u = solveForwardProblem(prepro, assemble)
% u = solveForwardProblem(prepro, constraints, forceLocations, forceMagnitude)
%   Detailed explanation goes here

% Build  system matrices
if(assemble)
    prepro.assembleMatrices();
end
f = createForceVector(prepro);

% Solve at each frequency
for i = 1:length(prepro.frequencies)
    u(:,i) = solveSystem(prepro.frequencies(i), f, prepro);
end

end

