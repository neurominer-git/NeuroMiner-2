function res =isevaluation(r)
%ISEVALUATION  True for EVALUATION class elements or arrays.
%   ISEVALUATION(R) returns 1 if R is a EVALUATION class element or array and 0 otherwise.
%
%   See also EVALUATION, ISA.

%   ISEVALUATION revision history:
%   Date of creation: 11 July 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'evaluation');
end