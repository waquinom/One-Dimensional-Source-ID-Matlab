
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%
function [  f, T, regOperator ] = solveIP(umeasured, FEModel)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global  meaLocations eigenvalsFrac solutionMethod pcgIters pcgTol ...
    tikhonovPar regularizationOperator

%FEModel = PreProcessor(L, nelemns, E, A, freqs, rho, constraints);

T = formTransferMatrix(FEModel, meaLocations);
dimT = size(T);

if strcmp(regularizationOperator, 'H1')
    FEModel.createForceH1Matrix();
    regOperator = FEModel.Kr;
else
    regOperator =eye(dimT(2), dimT(2));
end

if (strcmp(solutionMethod, 'svd'))
    [U, D, V] = svd(full(T));
    dim=size(U);
    %figure(3)
    %plot(diag(D));
    if (eigenvalsFrac>dim(2))
        m=dim(2);
    else
        m=eigenvalsFrac;
    end
    
    Q=U(:,1:m);
    P=V(:,1:m);
    Dred = D(1:m,1:m);
    a=Q'*umeasured'./diag(Dred);
    f=P*a;
    
    % Minimum norm solution
      %A=T*T';
      %f=T'*A^-1*umeasured';
elseif(strcmp(solutionMethod, 'pcg'))
    
    A=T'*T;
    A= A + tikhonovPar * regOperator;
    b=T'*umeasured';
    f= pcg(A, b, pcgTol, pcgIters);
elseif(strcmp(solutionMethod, 'ls'))
     A=T'*T;
     A= A + tikhonovPar * regOperator;
     b=T'*umeasured';
     f = A\b;
else
    disp('No solution method specified \n');
end

%     for i=1:m
%          f(:,s)=f(:,s)+U(:,i)'*umeasured'*V(:,i)/D(i,i);
%     end
%

end

