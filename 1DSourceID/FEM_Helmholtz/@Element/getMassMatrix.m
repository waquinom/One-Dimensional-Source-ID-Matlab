function Me = getMassMatrix(ElementObject, elementNo)
% getStiffnessMatrix(ElementObject, elementNo, E, A)
%
%
    node1 = ElementObject.grid.elementConnectivity(elementNo, 1);
    node2 = ElementObject.grid.elementConnectivity(elementNo, 2);
    x1 = ElementObject.grid.nodalCoord(1);
    x2 = ElementObject.grid.nodalCoord(2);
    L = x2 - x1;
    Me =  L / 3 * [1 1/2; 1/2 1];
end
