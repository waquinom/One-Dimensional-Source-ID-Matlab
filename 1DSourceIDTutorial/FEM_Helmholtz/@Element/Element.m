classdef Element < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private)
            grid;
    end
    
    methods
        function ElementObject = Element(FEMesh)
            ElementObject.grid = FEMesh ;
        end 
    end
    
end

