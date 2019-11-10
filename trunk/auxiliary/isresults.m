function res =isresults(r)
%ISRESULTS  True for RESULTS class elements or arrays.
%   ISRESULTS(R) returns 1 if R is a RESULTS class element or array and 0 otherwise.
%
%   See also RESULTS, ISA.

%   ISRESULTS revision history:
%   Date of creation: 08 September 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'results');
end