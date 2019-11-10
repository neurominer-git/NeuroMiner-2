function res =isempty(r)
%ISEMPTY is True for empty evaluation class objects or arrays, FALSE
%otherwise.
%  RES=ISEMPTY (R) when R is a single evaluation object, r is a
%  scalar logical 1 or 0. This value is logical 1 (true) if R is empty and
%  logical if it is not.
%
%  RES=ISEMPTY(R) When R is an array, RES is an array if logical
%  ones and zeros. This array is the same size as the input array and
%  contains logical 1 (true) for those elements of the the input array that
%  are empty and logical 0 (false) for those elements that are not
%
%   See also EVALUATION, ISEVALUATION.

%   ISEMPTY (evaluation class)  revision history:
%   Date of creation: 8 July 2014 beta (Helena)
%   Creator: Carlos Cabral
res=zeros(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux.model)&&isempty(aux.outputs)&&isempty(aux.reports)
        res(i)=1;
    end
end
res=res>0;
end