function  MeshObject = generateMesh(MeshObject, domainSize, nelems)
%generateMesh(MeshObject, domainSize, nelems)
%   Detailed explanation goes here
MeshObject.nodalCoord(1:nelems+1) = [0:domainSize/nelems:domainSize];
MeshObject.elementConnectivity(1:nelems, 1:2)=0;
for i=1:nelems
    MeshObject.elementConnectivity(i,1) = i;
    MeshObject.elementConnectivity(i,2) = i+1;
end


