function Ke = getStiffnessMatrix(ElementObject, elementNo, E, A)
% getStiffnessMatrix(ElementObject, elementNo, E, A)
%
%
    node1 = ElementObject.grid.elementConnectivity(elementNo, 1);
    node2 = ElementObject.grid.elementConnectivity(elementNo, 2);
    x1 = ElementObject.grid.nodalCoord(1);
    x2 = ElementObject.grid.nodalCoord(2);
    L = x2 - x1;
    Ke = A * E / L * [1 -1; -1 1];
end
