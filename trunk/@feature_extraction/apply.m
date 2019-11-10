function fe_obj =apply(fe_obj)
%APPLY (FEATURE_EXTRACTION class) performs feature extraction 
%   FE =APPLY(FE) applies the features extraction pipeline defined in the
%   models property of the feature_extraction object (FE) over the data
%   defined in the same feature_extraction object property features. Each
%   operation performed in over the input FE object is recorded in the form
%   of a REPORT object associated to the reports property of the same
%   object.
%
%   APPLY has two main modes, estimation and application.
%
%   ESTIMATION mode uses the data in the features property of the FE input
%   object to estimate the models defined in the models property of the
%   same objetc. This mode is activated when:
%       1 - All the models defined in the models property of the FE input
%       object are empty (Full estimation).
%   
%       2 - If the first n models are complete and the first n elements of
%       the report property correspond to those n models
%       (Partial Estimation). In this case the estimation the will start 
%       from the n+1 model.
%
%   APPLICATION mode uses fully defined models to transform the data in the
%   features property. This mode is activated when the all the models
%   defined in the models property of the input FE object are complete and
%   the reports property of the same object is empty.
%
%   FE_OBJ (output) is a FE object class that resulted from the application
%   of APPLY (FEATURE_EXTRACTION) to the FE_OBJ (input).


%   FE =APPLY(FE)

%   APPLY revision history:
%   Date of creation: 02 June 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==1
    if ~isfeature_extraction(fe_obj)
        error('apply:InputError',['Undefined function '' apply (feature_extraction class) '' for the input argument of type ''' class(fe_obj) ''' (First input argument must be a feature_extraction class object).']);
    elseif numel(fe_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(fe_obj)) ') for the input of function '' apply (feature_extraction class).']);
    elseif strcmp(fe_obj.status,'complete')
        warning(['The input argument of type ''' class(fe_obj) ''' provided to the function '' apply (feature_extraction class) '' is already complete. Nothing to do.']);
        return
    elseif strcmp(fe_obj.status,'invalid')||strcmp(fe_obj.status,'empty')
        error('apply:InputError',['Undefined function '' apply (feature_extraction class) '' for the ' fe_obj.status{1} ' input argument of type ''' class(fe_obj) '''.']);
    end
    %check if the feature_extraction methods are included in the package
    import feature_extraction_methods.*
    fext_methods=fieldnames(fe_obj.models);
    errors='';
    flag_exist_final=true;
%     for i=1:numel(fext_methods)
%         try flag_exist=is_package(class(fe_obj.models.(fext_methods{i})),'feature_extraction_methods');
%         catch err
%             rethrow(err);
%         end
%         if ~flag_exist
%             flag_exist_final=false;
%             errors=[errors ' ,' class(fe_obj.models.(fext_methods{i}))];
%         end
%     end
    if flag_exist_final
        import feature_extraction_methods.*
    else
        error('apply:InputError',['Feature_Extraction method(s)' errors ' not found in the Feature_Extraction toolbox please check if the method is valid.']);
    end
    
    %% Act: Proceeding to the feature estimation process
    status_fe=fe_obj.status{1};
    aux_models_names=fieldnames(fe_obj.models);
    aux_reports=numel(fe_obj.reports);
    models_trans=fe_obj.models;
    reports_trans=fe_obj.reports;
    switch status_fe %selecting the functioning mode
        case 'estimation_ready'
            for i=1:numel(fieldnames(fe_obj.models))
                fext_method=aux_models_names{i};
                
                try
                    [aux_fext_method,aux_data]=fe_obj.models.(fext_method).apply(fe_obj.features);
                catch err
                    rethrow(err);
                end
                
                models_trans.(fext_method)=aux_fext_method;
                if isempty(reports_trans)
                    reports_trans=aux_fext_method.reports;
                else
                    reports_trans=cat(1,reports_trans,aux_fext_method.reports);
                end
                fe_obj=feature_extraction(models_trans,aux_data,reports_trans);
            end
        case 'application_ready'
            for i=1:numel(fe_obj.models)
                fext_method=aux_models_names{i};
                try
                    [aux_fext_method,aux_data]=fe_obj.models.(fext_method).apply(fe_obj.features);
                catch err
                    rethrow(err);
                end
                if isempty(reports_trans)
                    reports_trans=aux_fext_method.reports;
                else
                    reports_trans=cat(1,reports_trans,aux_fext_method.reports);
                end
                fe_obj=feature_extraction(models_trans,aux_data,reports_trans);
            end
        case 'estimation_unfinished'
            for i=(aux_reports+1):numel(fe_obj.models)
                fext_method=aux_models_names{i};
                try
                    [aux_fext_method,aux_data]=apply(fext_method,fe_obj.features);
                catch err
                    rethrow(err);
                end
                models_trans.(fext_method)=aux_fext_method;
                reports_trans(numel(reports_trans)+1)=aux_fext_method.reports;
                fe_obj=feature_extraction(models_trans,aux_data,reports_trans);
            end
%         case 'application_unfinished'
%             for i=(aux_reports+1):numel(fe_obj.models)
%                 fext_method=aux_models_names{i};
%                 try
%                     [aux_fext_method,aux_data]=apply(fext_method,fe_obj.features);
%                 catch err
%                     rethrow(err);
%                 end
%                 reports_trans(numel(reports_trans)+1)=aux_fext_method.reports;
%                 fe_obj=feature_extraction(models_trans,aux_data,reports_trans);
%             end
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (feature_extraction class) '' for the ' status_fe ' input argument of type ''' class(fe_obj) '''.']);
    end
    %% Finale: Producing the overall feature_extractiom report
    report_string=status_fe;
    aux_=strfind(report_string,'_');
    report_string=report_string(1:aux_(1)-1);
    final_report=report(class(fe_obj),fe_obj.reports,true,[datestr(clock) ' - ' report_string]);
    final_report=flag_decider(final_report);
    fe_obj.reports=final_report;
else
    error('apply:InputError','Invalid number of arguments for function '' apply (feature_extraction class). (number of arguments is not 1)');
end

end