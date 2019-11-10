function [scl_obj,data_obj] =apply(scl_obj,data_obj)
%APPLY (SCALING class) performs feature extraction 
%   [SCL_OBJ FEATURES]=APPLY(SCL_OBJ,FEATURES) estimates or applies a model defined
%   by the TFE class to the data_class object, data_obtj.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in the FEATURES to produce a model based
%   on the SCALING method. In this mode SCL_OBJ (output)
%   is a SCALING class object containing the model
%   estimated by APPLY(SCALING). DATA_OBJ (output)
%   corresponds to features transformed accordingly to the model estimated.
%
%   2 - APPLICATION mode uses fully defined models to transform the data 
%   in the features property. This mode is activated when the all the models
%   defined in the models property of the input FE object are complete and
%   the reports property of the same object is empty. In this mode SCL_OBJ 
%   (output) is a SCALING class remains untouched when 
%   compared to SCL_OBJ (input). DATA_OBJ (output) corresponds to features 
%   transformed accordingly to the model contained in SCL_OBJ (input).


%   [SCL_OBJ,FEATURES] =APPLY(SCL_OBJ,DATA)

%   APPLY revision history:
%   Date of creation: 21 October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    if ~isa(scl_obj,'feature_extraction_methods.scaling')
        error('apply:InputError',['Undefined function '' apply (scaling class) '' for the input argument of type ''' class(scl_obj) ''' (First input argument must be a scaling class object).']);
    elseif numel(scl_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(scl_obj)) ') for the first input of function '' apply (scaling class).']);
    elseif ~isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (scaling class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['apply:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (scaling class).']);
    else
        dummy_scaling=scaling;
        dummy_scaling=parameters_eval(dummy_scaling.parameters,data_obj);
        scl_obj.parameters=parameters_eval(scl_obj.parameters,data_obj);
        try
            param_report=parameters_checker(dummy_scaling,scl_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (scaling class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_scaling
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=scl_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    switch status_fe %selecting the functioning mode
        case 'estimation_ready'
            params=scl_obj.parameters;
            model.revertflag=params.revertflag.value{1};
            model.overmatflag=params.overmatflag.value{1};
            model.zerooutflag=params.zerooutflag.value{1};
            model.ZeroOne=params.ZeroOne.value{1};
            model.AcMatFl=params.AcMatFl.value{1};
            try
                [features,model]=nk_PerfScaleObj(data_obj.data,model);
            catch err
                rethrow(err);
            end
        case 'application_ready'
            model=scl_obj.model;
            try
               features=nk_PerfScaleObj(data_obj.data,model);
            catch err
                rethrow(err);
            end
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (scaling class) '' for the ' status_fe ' input argument of type ''' class(scl_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and scaling
    %class for models.
    switch status_fe
        case 'estimation_ready'
            rep_esti=report('scaling',report(),true,[data_obj.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and scaling
            %class for models.
            scl_obj=scaling(scl_obj.parameters,model,rep_esti);
            data_obj.data=features;
            data_obj.descriptor=[data_obj.descriptor ' | scaling'];
            %data_obj=data_class(features,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,data_obj.features_descriptor,[data_obj.descriptor ' | scaling']);
        case 'application_ready'
            rep_esti=report('scaling',report(),true,[data_obj.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and scaling
            %class for models.
            scl_obj=scaling(scl_obj.parameters,scl_obj.model,[scl_obj.reports;rep_esti]);
            data_obj.data=features;
            data_obj.descriptor=[data_obj.descriptor ' | scaling'];
            %data_obj=data_class(features,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,data_obj.features_descriptor,[data_obj.descriptor ' | scaling']);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (scaling class). (number of arguments is not 2)');
end
end