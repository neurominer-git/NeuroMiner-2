function res =isvalidation_design(r)
%ISVALIDATION_DESIGN  True for VALIDATION_DESIGN class elements or arrays.
%   ISVALIDATION_DESIGN(R) returns 1 if R is a ISVALIDATION_DESIGN class element or array and 0 otherwise.
%
%   See also VALIDATION_DESIGN, ISA.

%   ISVALIDATION_DESIGN (VALIDATION_DESIGN class)  revision history:
%   Date of creation: 10 September 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'validation_design');
end