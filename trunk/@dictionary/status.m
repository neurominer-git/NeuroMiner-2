function res =status(r)
%   STATUS (DICTIONARY class)
%   STATUS (R) returns a cell array with the same number of elements and in
%   the same order as r. Each position in the cell array contains a string
%   describing the status of the correspendent DICTIONARY class object.
%   Possible values are:
%   "empty" - for empty DICTIONARY class objects.
%   "incomplete" - for DICTIONARY class objects with insuficient info.
%   "ready" - for DICTIONARY class objects with enough information but
%   without the design property defined.
%   "complete" - for DICTIONARY class objects with all the information
%   defined
%
%   See also DICTIONARY, ISDICTIONARY.

%   STATUS (DICTIONARY class)  revision history:
%   Date of creation: 16 May 2014 beta (Helena)
%   Creator: Carlos Cabral
res=cell(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    if isempty(aux)
       aux_name='empty';
    elseif isempty(aux.method)||(isempty(aux.ouput)&&isempty(aux.input))
        aux_name='incomplete';
    elseif isempty(aux.warnings)&&isempty(aux.ouput)
        aux_name='ready_input';
    elseif isempty(aux.warnings)&&isempty(aux.input)
        aux_name='ready_output';
    elseif isempty(aux.warnings)
        aux_name='ready';
    else
        aux_name='complete';
    end
    res{i}=aux_name;
end
end