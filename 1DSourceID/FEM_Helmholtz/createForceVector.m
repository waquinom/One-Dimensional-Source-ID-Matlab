function f = createForceVector(prepro)
%f = createForceVector(prepro, i, forceLocations, forceMagnitude)
%   Detailed explanation goes here

n =length(prepro.ForceMesh.nodalCoord);
if (n > 0)
    f=prepro.Mf * prepro.forceMagnitude';
elseif (prepro.distributedLoad)
    f = prepro.M * prepro.forceMagnitude';
else
    f = prepro.forceMagnitude';
end

f = sparse(f);

end
