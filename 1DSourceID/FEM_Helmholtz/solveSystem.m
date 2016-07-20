function u = solveSystem(freq, f, prepro)
% u = solveSystem(freqs(i), M, K, f, constraints)
%   Detailed explanation goes here
omega = 2 * pi * freq;

%Form system
A = prepro.K - omega^2 * prepro.density* prepro.M;

% Apply constraints
for i=1:length(prepro.constraints)
    A(prepro.constraints(i),:) = 0;
    A(:,prepro.constraints(i)) = 0;
    A(prepro.constraints(i),prepro.constraints(i))=1;
    f(prepro.constraints(i))=0;
end

u = A \ f;
end

