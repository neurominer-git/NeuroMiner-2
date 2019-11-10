function res =emptysoft_labels(r)
%EMPTYSOTFT_LABELS (RESULTS class)  
%   EMPTYSOTFT_LABELS(R) returns TUE if R has an empty SOFT_LABELS property
%   and 0 otherwise. If R is an array of RESULTS class objects, the
%   function returns an array of logicals.
%
%   See also RESULTS, ENSEMBLE_LEARNING.

%   EMPTYSOTFT_LABELS(R) (RESULTS class)  revision history:
%   Date of creation: 29 October 2014 beta (Helena)
%   Creator: Carlos Cabral
res=zeros(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux.soft_labels)
       res(i)=1;
    end
end
res=res>0;
end