function res =isempty(r)
%ISEMPTY  True for empty VALIDATION_DESIGN class elements or arrays.
%   ISEMPTY(R) returns 1 if R is an empty VALIDATION_DESIGN class element or array and 0 otherwise.
%
%   See also VALIDATION_DESIGN, ISVALIDATION_DESIGN.

%   ISVALIDATION_DESIGN (VALIDATION_DESIGN class)  revision history:
%   Date of creation: 13 March 2015 beta (Helena)
%   Creator: Carlos Cabral
res=zeros(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux.train)&&isempty(aux.test)&&isempty(aux.design)&&isempty(aux.depth)&&isempty(aux.target_values)&&isempty(aux.evaluation_type)
        res(i)=1;
    end
end
res=res>0;
end
