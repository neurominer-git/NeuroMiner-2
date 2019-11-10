function res =isempty(r)
%ISEMPTY  True for empty DATA_CLASS class elements or arrays.
%   ISEMPTY(R) returns 1 if R is an empty DATA_CLASS class element or array and 0 otherwise.
%
%   See also DATA_CLASS, ISDATA_CLASS.

%   ISEMPTY (DATA_CLASS class)  revision history:
%   Date of creation: 5 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=zeros(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux.data)&&isempty(aux.type)&&isempty(aux.dbcode)&&isempty(aux.covariates)&&isempty(aux.target_values)&&isempty(aux.descriptor)
        res(i)=1;
    end
end
res=res>0;
end