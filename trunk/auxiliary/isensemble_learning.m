function res =isensemble_learning(r)
%ISENSEMBLE_LEARNING  True for ENSEMBLE_LEARNING class elements or arrays.
%   ISENSEMBLE_LEARNING(R) returns 1 if R is a ENSEMBLE_LEARNING class element or array and 0 otherwise.
%
%   See also ENSEMBLE_LEARNING, ISA.

%   ISENSEMBLE_LEARNING (ENSEMBLE_LEARNING class)  revision history:
%   Date of creation: 9 September 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'ensemble_learning');
end