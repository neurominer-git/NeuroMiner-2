function [filt_obj,data_obj] =apply(filt_obj,data_obj)
%APPLY (FILTER_METHOD class) performs feature extraction 
%   [SCL_OBJ FEATURES]=APPLY(SCL_OBJ,FEATURES) estimates or applies a model defined
%   by the TFE class to the data_class object, data_obtj.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in the FEATURES to produce a model based
%   on the FILTER_METHOD method. In this mode SCL_OBJ (output)
%   is a FILTER_METHOD class object containing the model
%   estimated by APPLY(FILTER_METHOD). DATA_OBJ (output)
%   corresponds to features transformed accordingly to the model estimated.
%
%   2 - APPLICATION mode uses fully defined models to transform the data 
%   in the features property. This mode is activated when the all the models
%   defined in the models property of the input FE object are complete and
%   the reports property of the same object is empty. In this mode SCL_OBJ 
%   (output) is a FILTER_METHOD class remains untouched when 
%   compared to SCL_OBJ (input). DATA_OBJ (output) corresponds to features 
%   transformed accordingly to the model contained in SCL_OBJ (input).


%   [SCL_OBJ,FEATURES] =APPLY(SCL_OBJ,DATA)

%   APPLY revision history:
%   Date of creation: 16 July 2016 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    import filter_methods.*
    if ~isa(filt_obj,'feature_extraction_methods.filter_method')
        error('apply:InputError',['Undefined function '' apply (filter_method class) '' for the input argument of type ''' class(filt_obj) ''' (First input argument must be a filter_method class object).']);
    elseif numel(filt_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(filt_obj)) ') for the first input of function '' apply (filter_method class).']);
    elseif ~isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (filter_method class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['apply:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (filter_method class).']);
    else
        dummy_filter_method=filt_obj;
        dummy_filter_method=parameters_eval(dummy_filter_method.parameters,data_obj);
        filt_obj.parameters=parameters_eval(filt_obj.parameters,data_obj);
        try
            param_report=parameters_checker(dummy_filter_method,filt_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (filter_method class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_filter_method
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=filt_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    switch status_fe %selecting the functioning mode
        case 'estimation_ready'
            %estimating the weight of each feature
            try filt_obj=filt_obj.weight_estimator(data_obj);
            catch err
                rethrow(err)
            end
            data_obj=data_obj.data_selector(filt_obj.model.cut_off.apply(filt_obj.model.weight_vector),'features');
        case 'application_ready'
            %% filtering the data
            data_obj=data_obj.data_selector(filt_obj.model.cut_off.apply(filt_obj.model.weight_vector),'features');
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (filter_method class) '' for the ' status_fe ' input argument of type ''' class(filt_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and filter_method
    %class for models.
    switch status_fe
        case 'estimation_ready'
            rep_esti=report('filter_method',report(),true,[data_obj.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and filter_method
            %class for models.
            filt_obj.reports=rep_esti;
            data_obj.descriptor=[data_obj.descriptor ' | ' class(filt_obj) ' ' filt_obj.parameter_descriptor];
        case 'application_ready'
            rep_esti=report('filter_method',report(),true,[data_obj.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and filter_method
            %class for models.
            filt_obj.reports=rep_esti;
            data_obj.descriptor=[data_obj.descriptor ' | ' class(filt_obj) ' ' filt_obj.parameter_descriptor];
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (filter_method class). (number of arguments is not 2)');
end
end