function applyBCs( PreProcessorObject )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

PreProcessorObject.K(PreProcessorObject.constraints,:)=[];
PreProcessorObject.K(:,PreProcessorObject.constraints)=[];
PreProcessorObject.M(PreProcessorObject.constraints,:)=[];
PreProcessorObject.M(:,PreProcessorObject.constraints)=[];
end

