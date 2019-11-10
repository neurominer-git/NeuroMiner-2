function res =isempty(r)
%ISEMPTY  True for empty DICTIONARY class elements or arrays.
%   ISEMPTY(R) returns 1 if R is an empty DICTIONARY class element or array and 0 otherwise.
%
%   See also DICTIONARY, ISDICTIONARY.

%   ISEMPTY (DICTIONARY class)  revision history:
%   Date of creation: 7 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=zeros(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux.method)&&isempty(aux.input)&&isempty(aux.output)&&isempty(aux.warnings)
        res(i)=1;
    end
end
res=res>0;
end