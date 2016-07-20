
% ******************************************************************%
% Inverse Problem Tutorial: Source Inversion Example
% Written by: Wilkins Aquino, Professor, Duke University
%*******************************************************************%
function []=postprocess(freqs, sol, initialGuess, forceMagnitude)
%[]=postprocess(freqs, sol, initialGuess, forceMagnitude)
%   Detailed explanation goes here

dim = size(forceMagnitude);
forceSolution(1:dim(1), 1:dim(2))=0;
for i=1:dim(1)
    for j=1:dim(2)
        forceSolution(i,j)=sol(dim(2)*(i-1)+j);
    end
end
close all;
for i=1:dim(1)
       Y=[forceMagnitude(i,:);initialGuess(i,:);forceSolution(i,:)];
       location = ['Location ',int2str(i)];
       createfigure(freqs, Y, location);
end

