function [ grad ] = computeGradient( PreProcessorObject, u, w )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

element = Element(PreProcessorObject.FEmesh);
for i=1:PreProcessorObject.numElemns
    %we set the elastic modulus to 1.
    E=1;
    Ke = element.getStiffnessMatrix(i,E, PreProcessorObject.Area(i));
    enodes = PreProcessorObject.FEmesh.elementConnectivity(i,:);
    ue = u(enodes);   
    we = w(enodes);
    grad(i,1)=ue'*Ke*we;    
end

