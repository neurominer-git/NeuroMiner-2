function res =ischain(r)
%ISCHAIN  True for CHAIN class elements or arrays.
%   ISCHAIN(R) returns 1 if R is a CHAIN class element or array and 0 otherwise.
%
%   See also CHAIN, ISA.

%   ISCHAIN (CHAIN class)  revision history:
%   Date of creation: 26 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'chain');
end