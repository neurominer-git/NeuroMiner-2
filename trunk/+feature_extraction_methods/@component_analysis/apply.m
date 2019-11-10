function [comp_obj,data_obj] =apply(comp_obj,data_obj)
%APPLY (COMP_METHOD class) performs feature extraction 
%   [COMP_METHOD FEATURES]=APPLY(COMP_METHOD,FEATURES) estimates or applies
%   a model defined by the component analysis method defined by COMP_METHOD
%   to the data_class object, data_obtj.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in the FEATURES to produce a model based
%   on the COMP_METHOD method. In this mode COMP_METHOD (output)
%   is a COMP_METHOD class object containing the model
%   estimated by APPLY(COMP_METHOD). DATA_OBJ (output)
%   corresponds to features transformed accordingly to the model estimated.
%
%   2 - APPLICATION mode uses fully defined models to transform the data 
%   in the features property. This mode is activated when the all the models
%   defined in the models property of the input FE object are complete and
%   the reports property of the same object is empty. In this mode COMP_METHOD 
%   (output) is a COMP_METHOD class remains untouched when 
%   compared to COMP_METHOD (input). DATA_OBJ (output) corresponds to features 
%   transformed accordingly to the model contained in COMP_METHOD (input).


%   [COMP_METHOD,FEATURES] =APPLY(COMP_METHOD,DATA)

%   APPLY revision history:
%   Date of creation: 11 August 2016 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    import component_analysis.*
    if ~isa(comp_obj,'feature_extraction_methods.component_analysis')
        error('apply:InputError',['Undefined function '' apply (component_analysis class) '' for the input argument of type ''' class(comp_obj) ''' (First input argument must be a component_analysis class object).']);
    elseif numel(comp_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(comp_obj)) ') for the first input of function '' apply (component_analysis class).']);
    elseif ~isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (component_analysis class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['apply:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (component_analysis class).']);
    else
        dummy_component_analysis=comp_obj;
        dummy_component_analysis=parameters_eval(dummy_component_analysis.parameters,data_obj);
        comp_obj.parameters=parameters_eval(comp_obj.parameters,data_obj);
        try
            param_report=parameters_checker(dummy_component_analysis,comp_obj.parameters);%,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_component_analysis
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=comp_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    switch status_fe %selecting the functioning mode
        case 'estimation_ready'
            %estimating the weight of each feature
            try [comp_obj,data_obj]=comp_obj.transformation_handler(data_obj,'estimation');
            catch err
                rethrow(err)
            end
            %% filtering the data
        case 'application_ready'
            try data_obj=comp_obj.transform_handler(data_obj,'application');
            catch err
                rethrow(err)
            end
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (component_analysis class) '' for the ' status_fe ' input argument of type ''' class(comp_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and component_analysis
    %class for models.
    switch status_fe
        case 'estimation_ready'
            rep_esti=report('component_analysis',report(),true,[data_obj.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and component_analysis
            %class for models.
            comp_obj.reports=rep_esti;
            data_obj.descriptor=[data_obj.descriptor ' | ' class(comp_obj) ' ' comp_obj.parameter_descriptor];
        case 'application_ready'
            rep_esti=report('component_analysis',report(),true,[data_obj.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and component_analysis
            %class for models.
            comp_obj.reports=rep_esti;
            data_obj.descriptor=[data_obj.descriptor ' | ' class(comp_obj) ' ' comp_obj.parameter_descriptor];
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (component_analysis class). (number of arguments is not 2)');
end
end