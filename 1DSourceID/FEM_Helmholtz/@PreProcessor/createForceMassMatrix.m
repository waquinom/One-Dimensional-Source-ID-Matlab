function [ ] = createForceMassMatrix( prepro )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

IP = [-sqrt(3)/3 sqrt(3)/3];
weights=[1 1];%
% IP = [-sqrt(3/5) 0 sqrt(3/5)];
% weights=[5/9 8/9  5/9];


Nlocal(1:length(IP),1:2)=0;
for i=1:length(IP)
    Nlocal(i,:) = evalShapeAtIPs(IP(i));
end
prepro.Mf(1:prepro.numElemns+1, 1:prepro.ForceMesh.getNumElements()+1)=0;

for i=1:prepro.numElemns
    nodes = prepro.FEmesh.elementConnectivity(i, 1:2);
    %node2 = ElementObject.grid.elementConnectivity(i, 2);
    x = prepro.FEmesh.nodalCoord(nodes);
    %  x2 = ElementObject.grid.nodalCoord(2);
    xIP(1:length(IP))=0;
    for r=1:length(IP)
        xIP(r) = Nlocal(r,:) * x';
    end
    
    elementsConnected = getNodesAssociatedWithIP(xIP, prepro.ForceMesh);
    globalForceNodes=prepro.ForceMesh.elementConnectivity(elementsConnected,:);
    % globalForceNodes(2,:)=FoceMesh.elementConnectivity(elementsConnected(2),:);
    ForceNodalCoords(1:length(IP),1:2)=0;
    
    Nhat(1:length(IP),1:2)=0;
    for r=1:length(IP)
        ForceNodalCoords(r,:) = prepro.ForceMesh.nodalCoord(globalForceNodes(r,:));
        Nhat(r,:) = evaluateShapFunatPt(xIP(r), ForceNodalCoords(r,:));
    end
    
    for j =1:2
        globalJ = nodes(j);
        for k = 1:2
            globalK = globalForceNodes(j,k);
            for p=1:length(IP)
                prepro.Mf(globalJ, globalK) = prepro.Mf(globalJ, globalK)...
                    + Nlocal(p,j) * Nhat(p,k) * (x(2)-x(1))*0.5*(weights(p));
            end
        end
    end
end

prepro.Mf = sparse(prepro.Mf);

end

function [Nlocal] = evalShapeAtIPs(x)
Nlocal(1) = 1/2*(1-x);
Nlocal(2) = 1/2*(x+1);
end

function [Nglobal] = evaluateShapFunatPt(x, coords)
L= coords(2)-coords(1);
Nglobal(1) = 1/L*(coords(2)-x);
Nglobal(2) = 1/L*(x-coords(1));
end
