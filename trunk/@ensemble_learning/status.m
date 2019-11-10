function res =status(r)
%STATUS (ENSEMBLE_LEARNING class) determines the status of a
%ENSEMBLE_LEARNING (EnL) object or array of EnL objects.
% RES=STATUS (R) returns a cell array with the same number of elements and in
%   the same order as r. Each position in the cell array contains a string
%   describing the status of the correspendent ENSEMBLE_LEARNING class object.
%   Possible values are:
%
%       1 - 'empty' - for empty ENSEMBLE_LEARNING class objects.
%       2 - 'estimation_ready' - for ENSEMBLE_LEARNING class objects that
%       contain 'estimation_ready' elements in the models property and also
%       have an empty reports property or containing only empty reports.
%       3 - 'application_ready' - for ENSEMBLE_LEARNING class objects with
%       'application_ready' models and features defined but with the reports
%       property empty or containing only empty reports.
%       4 - 'complete' - for ENSEMBLE_LEARNING objects that have the
%       underwent the full processing estimation/application.
%       5 - 'invalid' - any other case.


%   RES=STATUS (R)
%   See also ENSEMBLE_LEARNING, ISENSEMBLE_LEARNING, APPLY

%   STATUS (ENSEMBLE_LEARNING class)  revision history:
%   Date of creation: 8 July 2014 beta (Helena)
%   Creator: Carlos Cabral
res=cell(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    %% Overture: Checking if the ensemble_learning object/array is empty
    if isempty(aux)
        aux_name='empty';
    else
    %% Act: Reading the status of the model and the processes reported
        % checking the status of the model objects that constitute the evaluation object's model property
        if ~isempty(aux.model)
            flag_model=aux.model.status; 
        else
            flag_model=[];
        end
        % checking the status of the report object that constitute the ensemble_learning object's report property
        if ~isempty(aux.reports.flag)
            if aux.reports.flag
                flag_reports=aux.reports.process;
            else
                flag_reports='invalid';
            end
        else
            if strcmp(flag_model,'estimation_ready')
               flag_reports='valid';
            else
                flag_reports='invalid';
            end
        end
        %% Finale: Deciding the status
        %   the model can never be empty for estimation or application
        %   purposes
        if ~isempty(flag_model)
            if ~strcmp(flag_reports,'invalid')
                if isempty(aux.output)
                    flag_estimation=strcmp(flag_model,'estimation_ready');
                    flag_application=strcmp(flag_model,'application_ready');
                    if flag_estimation
                        aux_name='estimation_ready';
                    elseif flag_application
                        aux_name='application_ready';
                    else
                        aux_name='invalid';
                    end
                else
                   aux_name='complete'; 
                end
            else 
                aux_name='invalid';
            end
        else
            aux_name='invalid';
        end
    end
    res{i}=aux_name;
end
end