function [ ] = createForceH1Matrix( prepro )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
element = Element(prepro.ForceMesh);
nelements=prepro.ForceMesh.getNumElements();
prepro.Kr(1:nelements+1, 1:nelements+1)=0;

for i=1:nelements
    Ke = element.getStiffnessMatrix(i,1,1);
  
    for j =1:2
        for k = 1:2
            globalJ = prepro.ForceMesh.elementConnectivity(i,j);
            globalK = prepro.ForceMesh.elementConnectivity(i,k);
            prepro.Kr(globalJ, globalK) = prepro.Kr(globalJ, globalK) + Ke(j,k);
        end
    end
end

prepro.Kr =sparse(prepro.Kr);


end

