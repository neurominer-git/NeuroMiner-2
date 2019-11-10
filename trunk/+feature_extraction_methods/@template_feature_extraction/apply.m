function [tfe_obj,data_obj] =apply(tfe_obj,data_obj)
%APPLY (TEMPLATE_FEATURE_EXTRACTION class) performs feature extraction 
%   [TFE FEATURES]=APPLY(TFE,FEATURES) estimates or applies a model defined
%   by the TFE class to the data_class object, data_obtj.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in the FEATURES to produce a model based
%   on the TEMPLATE_FEATURE_EXTRACTION method. In this mode TFE_OBJ (output)
%   is a TEMPLATE_FEATURE_EXTRACTION class object containing the model
%   estimated by APPLY(TEMPLATE_FEATURE_EXTRACTION). DATA_OBJ (output)
%   corresponds to features transformed accordingly to the model estimated.
%
%   2 - APPLICATION mode uses fully defined models to transform the data 
%   in the features property. This mode is activated when the all the models
%   defined in the models property of the input FE object are complete and
%   the reports property of the same object is empty. In this mode TFE_OBJ 
%   (output) is a TEMPLATE_FEATURE_EXTRACTION class remains untouched when 
%   compared to TFE_OBJ (input). DATA_OBJ (output) corresponds to features 
%   transformed accordingly to the model contained in TFE_OBJ (input).


%   [TFE,FEATURES] =APPLY(TFE,DATA)

%   APPLY revision history:
%   Date of creation: 22 October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    if ~isa(tfe_obj,'feature_extraction_methods.template_feature_extraction')
        error('apply:InputError',['Undefined function '' apply (template_feature_extraction class) '' for the input argument of type ''' class(tfe_obj) ''' (First input argument must be a template_feature_extraction class object).']);
    elseif numel(tfe_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(tfe_obj)) ') for the first input of function '' apply (template_feature_extraction class).']);
    elseif ~isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (template_feature_extraction class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (template_feature_extraction class).']);
    else
        dummy_template_feature_extraction=template_feature_extraction;
        try
            param_report=parameters_checker(dummy_template_feature_extraction.parameters,tfe_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (template_feature_extraction class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_template_feature_extraction
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=tfe_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    %copy the .m file of your function to the folder "auxiliary" in the
    %feature_extraction_methods package (<NM2 source code directory>/+feature_extraction_methods/auxiliary)
    
    switch status_fe %selecting the functioning mode
        case 'estimation_ready'
            try
                %here you introduce your previous function, please
                % adapt the need inputs based on the features as
                %well as the properties of the model
                %e.g:
                [features,param1,param2]=template_feature_extraction_func(data_obj.data,tfe_obj.parameter1.value{1},tfe_obj.parameter2.value{1},tfe_obj.parameter3.value{1},'estimation');
            catch err
                rethrow(err);
            end
            model.param1=param1;
            model.param2=param2;
        case 'application_ready' 
            try
                %here you introduce your previous function, please
                %adapt the need inputs based on the features as
                %well as the properties of the model
                %e.g:
                %using the model predefined to extract the features
                features=template_feature_extraction_func(data_obj.data,tfe_obj.model.param1,tfe_obj.model.param2,'apply');
            catch err
                rethrow(err);
            end
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (template_feature_extraction class) '' for the ' status_fe ' input argument of type ''' class(tfe_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and template_feature_extraction
    %class for models.
    switch status_fe
        case 'estimation_ready'
            rep_esti=report('template_feature_extraction',report(),true,[data_obj.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and template_feature_extraction
            %class for models.
            tfe_obj=template_feature_extraction(tfe_obj.parameters,model,rep_esti);
            %if the feature extraction method changes the number of
            %dimensions in data (examples or features) you have to change
            %the data_class inputs so they can be compatible with the
            %features outputed by your method.
            data_obj=data_class(features,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.features_descriptor,[data_obj.descriptor ' | template_feature_extraction'],data_obj.classes);
        case 'application_ready'
            rep_esti=report('template_feature_extraction',report(),true,[data_obj.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and template_feature_extraction
            %class for models.
            tfe_obj=tfe_obj(tfe_obj.parameters,tfe_obj.model,[tcfe.reports;rep_esti]);
            %if the feature extraction method changes the number of
            %dimensions in data (examples or features) you have to change
            %the data_class inputs so they can be compatible with the
            %features outputed by your method.
            data_obj=data_class(features,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_valies,data_obj.features_descriptor,[data_obj.descriptor ' | template_feature_extraction'],data_obj.classes);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (template_feature_extraction class). (number of arguments is not 1)');
end

end

