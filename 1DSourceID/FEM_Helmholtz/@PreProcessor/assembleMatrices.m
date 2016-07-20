function assembleMatrices (PreProcessorObject)
% [ K, M ] = assembleMatrices (PreProcessorObject);
%   Detailed explanation goes here
element = Element(PreProcessorObject.FEmesh);
PreProcessorObject.K(1:PreProcessorObject.numElemns+1, 1:PreProcessorObject.numElemns+1)=0;
PreProcessorObject.M=PreProcessorObject.K;
for i=1:PreProcessorObject.numElemns
    Ke = element.getStiffnessMatrix(i,PreProcessorObject.ElasticModulus(i), PreProcessorObject.Area(i));
    Me = element.getMassMatrix(i);
    
    for j =1:2
        for k = 1:2
            globalJ = PreProcessorObject.FEmesh.elementConnectivity(i,j);
            globalK = PreProcessorObject.FEmesh.elementConnectivity(i,k);
            PreProcessorObject.K(globalJ, globalK) = PreProcessorObject.K(globalJ, globalK) + Ke(j,k);
            PreProcessorObject.M(globalJ, globalK) = PreProcessorObject.M(globalJ, globalK) + Me(j,k);
        end
    end
end

PreProcessorObject.Mf=0;
if (~isempty(PreProcessorObject.ForceMesh.nodalCoord))
    PreProcessorObject.createForceMassMatrix();
end

PreProcessorObject.M = sparse(PreProcessorObject.M);
PreProcessorObject.K =sparse(PreProcessorObject.K);


