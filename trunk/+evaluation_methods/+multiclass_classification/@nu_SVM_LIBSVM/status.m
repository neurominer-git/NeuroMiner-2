function res =status(r)
%STATUS (nu_SVM_LIBSVM class) determines the status of a
%nu_SVM_LIBSVM (C_SVM) object or array of C_SVM objects.
% RES=STATUS (R) returns a cell array with the same number of elements and in
%   the same order as r. Each position in the cell array contains a string
%   describing the status of the correspendent nu_SVM_LIBSVM 
%   class object.
%   Possible values are:
%
%       1 - 'estimation_ready' - for nu_SVM_LIBSVM class objects 
%       have no model defined and an empty report property.
%       2 - 'application_ready' - for nu_SVM_LIBSVM class objects 
%       with defined models and report property valid (success).
%       3 - 'invalid' - any other case.

%   RES=STATUS (R)
%   See also nu_SVM_LIBSVM, APPLY

%   STATUS (nu_SVM_LIBSVM class)  revision history:
%   Date of creation: 25 November 2014 beta (Helena)
%   Creator: Carlos Cabral
res=cell(1,numel(r));
for i=1:numel(r)
    
    %% Overture: Initialization
    aux=r(i);
    %% Act: Get the variables to decide between the three status
        %1st - model
        aux_model=isempty(aux.model);
        %2nd - reports
        aux_empty_report=isempty(aux.reports);
        aux_success_report=aux.reports.flag;
        %% Finale: Deciding the status
        if aux_model&&aux_empty_report
           aux_name='estimation_ready';
        elseif ~aux_model&&aux_success_report
           aux_name='application_ready';
        else
           aux_name='invalid';
        end
    res{i}=aux_name;
end
end
