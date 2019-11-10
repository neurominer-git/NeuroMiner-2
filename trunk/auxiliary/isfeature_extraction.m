function res =isfeature_extraction(r)
%ISFEATURE_EXTRACTION  True for FEATURE_EXTRACTION class elements or arrays.
%   ISFEATURE_EXTRACTION(R) returns 1 if R is a FEATURE_EXTRACTION class element or array and 0 otherwise.
%
%   See also FEATURE_EXTRACTION, ISA.

%   ISFEATURE_EXTRACTION (FEATURE_EXTRACTION class)  revision history:
%   Date of creation: 26 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'feature_extraction');
end
