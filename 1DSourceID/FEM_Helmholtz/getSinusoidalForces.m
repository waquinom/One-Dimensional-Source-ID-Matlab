function [nodalForces] = getSinusoidalForces(locations, frequency)
%
%
%
nodalForces = sin(2*frequency*pi*locations);

end