function res =isvalidation(r)
%ISVALIDATION  True for VALIDATION class elements or arrays.
%   ISVALIDATION(R) returns 1 if R is a VALIDATION class element or array and 0 otherwise.
%
%   See also VALIDATION, ISA.

%   ISVALIDATION revision history:
%   Date of creation: 15 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'validation');
end