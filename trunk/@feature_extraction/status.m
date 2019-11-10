function res =status(r)
%STATUS (FEATURE_EXTRACTION class) determines the status of a
%FEATURE_EXTRACTION (FE) object or array of FE objects.
% RES=STATUS (R) returns a cell array with the same number of elements and in
%   the same order as r. Each position in the cell array contains a string
%   describing the status of the correspendent FEATURE_EXTRACTION class object.
%   Possible values are:
%
%       1 - 'empty' - for empty FEATURE_EXTRACTION class objects.
%       2 - 'estimation_ready' - for FEATURE_EXTRACTION class objects that
%       contain 'estimation_ready' elements in the models property and also
%       have an empty reports property or containing only empty reports.
%       3 - 'application_ready' - for FEATURE_EXTRACTION class objects with
%       'application_ready' models and features defined but with the reports
%       property empty or containing only empty reports.
%       4 - 'estimation_unfinished' - for FEATURE_EXTRACTION objects that 
%       started the estimation process but have not finished it. The first 
%       n models are 'application_ready' and have the correspondent reports
%       in the sub_processes property of the report object in the reports
%       property (The process in the report must be 'application').
%       5 - 'invalid' - any other case.


%   RES=STATUS (R)
%   See also FEATURE_EXTRACTION, ISFEATURE_EXTRACTION, APPLY

%   STATUS (FEATURE_EXTRACTON class)  revision history:
%   Date of creation: 26 May 2014 beta (Helena)
%   Creator: Carlos Cabral
if numel(r)>1
   res=cellfun(@(x) x.status,r,'UniformOutput',false);
   res=cellfun(@(x) x{1},res,'UniformOutput',false);
else
    aux=r;
    %% Overture: Checking if the feature_extraction object/array is empty
    if sum(isempty(aux))>0
        res={'empty'};
    else
        res={'invalid'};
    %% Act1: Reading the status of the models and the processes reported
        aux_models=aux.models;
        aux_reports=aux.reports;
        %% ACT 3: Application Ready because no models are applied
        if isempty(aux_models)
           res={'application_ready'};
           return
        end
        %% ACT 3: Application Ready with reports
        if numel(aux_reports)==1
           if aux_reports.flag==true&&~isempty(strfind(aux_reports.descriptor,'application'))
              res={'application_ready'};
              return
           end
        end
        %% ACT 4: Application ready and estimation_ready without reports
        %checking the status of the models objects that constitute the feature_extraction object's model property
        aux_models_names=fieldnames(aux_models);
        flag_models=cell(1,numel(aux_models_names,1));
        for j=1:numel(aux_models_names)
            flag_models(j)=aux_models.(aux_models_names{j}).status;
        end
        flag_estimation=sum(strcmp(flag_models,'estimation_ready'))==numel(flag_models);
        flag_application=sum(strcmp(flag_models,'application_ready'))==numel(flag_models);
        if flag_estimation
            res={'estimation_ready'};
            return
        elseif flag_application
            res={'application_ready'};
            return
        end
        %% ACT 5: estimation_unfinished number of reports == number of application ready models, reports should have the same process, and the processes should be in order
        pos_estimation=find(strcmp(flag_models,'estimation_ready'));
        pos_estimation=pos_estimation(1);
        if pos_estimation~=1
           previous_flag=all(strcmp(flag_models(1:pos_estimation-1),'application_ready'));
           later_flag=all(strcmp(flag_models(pos_estimation:end),'estimation_ready'));
           if later_flag&&previous_flag
              if numel(aux_reports)==sum(strcmp(flag_models,'application_ready'))
                  aux_flag=true;
                  for i=1:pos_estimation-1
                     if ~isequal(aux_reports(i),aux_models.(aux_models_names{i}).reports)
                         aux_flag=false;
                     end
                  end
                 if aux_flag
                    res={'estimation_ready'};
                 end
              end
           end
        end
    end
end