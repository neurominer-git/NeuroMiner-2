function res =status(r)
%STATUS (VALIDATION class) determines the status of a
%VALIDATION (EVAL) object or array of EVAL objects.
% RES=STATUS (R) returns a cell array with the same number of elements and in
%   the same order as r. Each position in the cell array contains a string
%   describing the status of the correspendent VALIDATION class object.
%   Possible values are:
%
%       1 - 'empty' - for empty VALIDATION class objects.
%       2 - 'incomplete' - for VALIDATION class objects with defined
%       methods but undefined designs.
%       4 - 'complete' - for VALIDATION objects that have defined designs.
%       5 - 'invalid' - any other case.


%   RES=STATUS (R)
%   See also VALIDATION, ISVALIDATION, APPLY

%   STATUS (VALIDATION class)  revision history:
%   Date of creation: 8 July 2014 beta (Helena)
%   Creator: Carlos Cabral
res=cell(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    %% Overture: Checking if the validation object/array is empty
    if sum(isempty(aux))>0
        aux_name='empty';
    else
    %% Act: Reading the status of the method and the processes reported
        % checking the status of the method object that constitute the validation object's method property
        if ~isempty(aux.design)
            flag_model=aux.method.reports.flag; 
        else
            flag_model=[];
        end
        % checking the status of the report object that constitute the validation object's report property
        if ~isempty(aux.reports) 
           flag_reports=aux.reports.flag;
        else
            flag_reports=[];
        end
        %% Finale: Deciding the status
        %   if the method is defined but the design is empty the validation
        %   is considered incomplete, if both are defined, completed.
        if isempty(flag_model)&&isempty(flag_reports)
            aux_name='incomplete';
        elseif ~isempty(flag_model)&&~isempty(flag_reports)
            if flag_model&&flag_reports
               aux_name='complete';
            else
               aux_name='invalid';
            end
        else
            aux_name='invalid';
        end
    end
    res{i}=aux_name;
end
if i==1
   res=res{1};
end
end