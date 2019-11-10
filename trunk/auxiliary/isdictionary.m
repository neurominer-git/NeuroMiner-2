function res =isdictionary(r)
%ISDICTIONARY  True for DICTIONARY class elements or arrays.
%   ISDICTIONARY(R) returns 1 if R is a DICTIONARY class element or array and 0 otherwise.
%
%   See also DICTIONARY, ISA.

%   ISDICTIONARY (DICTIONARY class)  revision history:
%   Date of creation: 7 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'dictionary');
end
