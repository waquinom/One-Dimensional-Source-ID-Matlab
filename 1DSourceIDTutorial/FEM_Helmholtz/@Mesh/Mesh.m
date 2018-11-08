classdef Mesh<handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        nodalCoord;
        elementConnectivity;
        dimension;
    end
   
    methods
        function MeshObject = Mesh()
            MeshObject.dimension = 1;
        end 
        function [coordinates]=getCoordinates(MeshObject)
            coordinates = MeshObject.nodalCoord;
        end
        function [connectivityCoor]=getConnectivityWithCoor(MeshObject)
            connectivityCoor = [MeshObject.nodalCoord(MeshObject.elementConnectivity(:,1))
                                MeshObject.nodalCoord(MeshObject.elementConnectivity(:,2))]';
        end
        function [nelem] = getNumElements(MeshObject)
           dim = size(MeshObject.elementConnectivity);
           nelem = dim(1);         
        end
    end    
end

