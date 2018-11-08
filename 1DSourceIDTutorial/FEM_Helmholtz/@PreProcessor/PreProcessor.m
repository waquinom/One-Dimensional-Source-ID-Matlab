classdef PreProcessor < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private)
        Length;
        numElemns;
        ElasticModulus;
        Area;
        frequencies;
        density;
        FEmesh;
        ForceMesh;
        forceLocations;
        forceMagnitude;
        constraints;
        K;
        M;
        Mf;
        Kr;
        distributedLoad=1;
    end
    
    methods
        function PreProcessorObject = PreProcessor(L, nelemns, E, A, freqs, rho,...
                 constraints)
            PreProcessorObject.Length=L;
            PreProcessorObject.numElemns = nelemns;
            PreProcessorObject.ElasticModulus(1:nelemns) = E;
            PreProcessorObject.Area(1:nelemns) = A;
            PreProcessorObject.frequencies = freqs;
            PreProcessorObject.density = rho;
            PreProcessorObject.FEmesh = Mesh();
            PreProcessorObject.FEmesh.generateMesh(L, nelemns);
            PreProcessorObject.constraints = constraints;
            PreProcessorObject.ForceMesh=Mesh();
        end 
        function setElasticity(PreProcessorObject, E)
            PreProcessorObject.ElasticModulus = E;
        end
        function generateForceMesh(PreProcessorObject, nelems)
           L = PreProcessorObject.Length;
           PreProcessorObject.ForceMesh.generateMesh(L, nelems);
        end
        function setForceFunction(PreProcessorObject, forceFun)
            % test if there is a force mesh. If not, use domain mesh
            loadCoords = PreProcessorObject.ForceMesh.getCoordinates();
            if (isempty(loadCoords))
               loadCoords = PreProcessorObject.FEmesh.getCoordinates();
            end
            PreProcessorObject.forceLocations=1:1:length(loadCoords);
            PreProcessorObject.forceMagnitude = ...
                 forceFun(loadCoords);
        end
        
        function setForceMagnitudeAndLocations(PreProcessorObject,...
                forceLocations, forceMagnitude)
            PreProcessorObject.forceMagnitude = forceMagnitude;
            PreProcessorObject.forceLocations = forceLocations;
            PreProcessorObject.distributedLoad=0;
            
        end
        function setDistributedLoadFlag(PreProcessor, flag)
            PreProcessor.distributedLoad=flag;
        end
        
         function [coord]=getNodalCoord(PreProcessor)
            coord = PreProcessor.FEmesh.getCoordinates();
         end
    end
    
end

