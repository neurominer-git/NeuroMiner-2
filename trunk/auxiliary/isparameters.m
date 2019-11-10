function res =isparameters(r)
%ISPARAMETERS  True for PARAMETERS class elements or arrays.
%   ISPARAMETERS(R) returns 1 if R is a PARAMETERS class element or array and 0 otherwise.
%
%   See also PARAMETERS, ISA.

%   ISPARAMETERS revision history:
%   Date of creation: 11 July 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'parameters');
end