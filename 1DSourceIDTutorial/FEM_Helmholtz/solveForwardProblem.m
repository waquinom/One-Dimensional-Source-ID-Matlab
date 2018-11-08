function u = solveForwardProblem(prepro, assemble)
% u = solveForwardProblem(prepro, constraints, forceLocations, forceMagnitude)
%   Detailed explanation goes here

% Build  system matrices
if(assemble)
    prepro.assembleMatrices();
end
f = createForceVector(prepro);

n = size(f,1);
assert( size(f,2) == 1 );

% Solve at each frequency
u = zeros(n, length(prepro.frequencies));
for i = 1:length(prepro.frequencies)
    u(:,i) = solveSystem(prepro.frequencies(i), f, prepro);
end


end