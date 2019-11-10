function res =iscv(r)
%ISCV  True for CV class elements or arrays.
%   ISCV(R) returns 1 if R is a ISCV class element or array and 0 otherwise.
%
%   See also CV, ISA.

%   ISCV (CV class)  revision history:
%   Date of creation: 10 September 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'cv');
end