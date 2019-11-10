function res =isempty(r)
%ISEMPTY  True for empty REPORT class elements or arrays.
%   ISEMPTY(R) returns 1 if R is an empty REPORT class element or array and 0 otherwise.
%
%   See also REPORT, ISREPORT.

%   ISREPORT (REPORT class)  revision history:
%   Date of creation: 5 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=zeros(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux.process)&&isempty(aux.subprocesses_report)&&(~aux.flag)&&isempty(aux.descriptor);
        res(i)=1;
    end
end
res=res>0;
end
