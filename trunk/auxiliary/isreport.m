function res =isreport(r)
%ISREPORT  True for REPORT class elements or arrays.
%   ISREPORT(R) returns 1 if R is a REPORT class element or array and 0 otherwise.
%
%   See also REPORT, ISA.

%   ISREPORT (REPORT class)  revision history:
%   Date of creation: 24 April 2014 beta (Helena)
%   Creator: Carlos Cabral
res=isa(r,'report');
end
