function res =isdata_class(r)
%ISDATA_CLASS  True for DATA_CLASS class elements or arrays.
%   ISDATA_CLASS(R) returns 1 if R is a ISDATA_CLASS class element or array and 0 otherwise.
%
%   See also DATA_CLASS, ISA.

%   ISDATA_CLASS (DATA_CLASS class)  revision history:
%   Date of creation: 24 April 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'data_class');
end