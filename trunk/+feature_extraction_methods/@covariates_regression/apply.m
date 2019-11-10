function [cr_obj,data_obj] =apply(cr_obj,data_obj)
%APPLY (COVARIATES_REGRESSION class) performs feature extraction 
%   [SCL_OBJ FEATURES]=APPLY(SCL_OBJ,FEATURES) estimates or applies a model defined
%   by the TFE class to the data_class object, data_obtj.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in the FEATURES to produce a model based
%   on the COVARIATES_REGRESSION method. In this mode SCL_OBJ (output)
%   is a COVARIATES_REGRESSION class object containing the model
%   estimated by APPLY(COVARIATES_REGRESSION). DATA_OBJ (output)
%   corresponds to features transformed accordingly to the model estimated.
%
%   2 - APPLICATION mode uses fully defined models to transform the data 
%   in the features property. This mode is activated when the all the models
%   defined in the models property of the input FE object are complete and
%   the reports property of the same object is empty. In this mode SCL_OBJ 
%   (output) is a COVARIATES_REGRESSION class remains untouched when 
%   compared to SCL_OBJ (input). DATA_OBJ (output) corresponds to features 
%   transformed accordingly to the model contained in SCL_OBJ (input).


%   [SCL_OBJ,FEATURES] =APPLY(SCL_OBJ,DATA)

%   APPLY revision history:
%   Date of creation: 21 October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    if ~isa(cr_obj,'feature_extraction_methods.covariates_regression')
        error('apply:InputError',['Undefined function '' apply (covariates_regression class) '' for the input argument of type ''' class(cr_obj) ''' (First input argument must be a covariates_regression class object).']);
    elseif numel(cr_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(cr_obj)) ') for the first input of function '' apply (covariates_regression class).']);
    elseif ~isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (covariates_regression class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['apply:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (covariates_regression class).']);
    else
        dummy_covariates_regression=covariates_regression;
        dummy_covariates_regression=parameters_eval(dummy_covariates_regression.parameters,data_obj);
        cr_obj.parameters=parameters_eval(cr_obj.parameters,data_obj);
        try
            param_report=parameters_checker(dummy_covariates_regression,cr_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (covariates_regression class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_covariates_regression
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=cr_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    switch status_fe %selecting the functioning mode
        case 'estimation_ready'
            params=cr_obj.parameters;
            model.revertflag=params.revertflag.value{1};
            aux_g=params.G.value;
            if ~all(isfield(data_obj.covariates,aux_g))
               error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (covariates_regression class) ''. Covariates are not present in the data set.'); 
            end
            model.G=data_obj.covariates.(aux_g{1});
            for i=2:numel(aux_g);
                model.G=[model.G data_obj.covariates.(aux_g{i})];
            end
            model.nointercept=params.nointercept.value{1};
            model.subgroup=cr_obj.model.subgroup;
            try
                [features,model]=nk_PartialCorrelationsObj(data_obj.data,model);
            catch err
                rethrow(err);
            end
            
        case 'application_ready'
            model=cr_obj.model;
            params=cr_obj.parameters;
            aux_g=params.G.value;
            if ~all(isfield(data_obj.covariates,aux_g))
               error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (covariates_regression class) ''. Covariates are not present in the data set.'); 
            end
            model.G=data_obj.covariates.(aux_g{1});
            for i=2:numel(aux_g);
                model.G=[model.G data_obj.covariates.(aux_g{i})];
            end
            try
               features=nk_PartialCorrelationsObj(data_obj.data,model);
            catch err
                rethrow(err);
            end
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (covariates_regression class) '' for the ' status_fe ' input argument of type ''' class(cr_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and covariates_regression
    %class for models.
    switch status_fe
        case 'estimation_ready'
            rep_esti=report('covariates_regression',report(),true,[data_obj.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and covariates_regression
            %class for models.
            cr_obj=covariates_regression(cr_obj.parameters,model,rep_esti);
            
            data_obj=data_class(features,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,data_obj.features_descriptor,[data_obj.descriptor ' | covariates_regression'],data_obj.feature_grouping);
        case 'application_ready'
            rep_esti=report('covariates_regression',report(),true,[data_obj.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and covariates_regression
            %class for models.
            cr_obj=covariates_regression(cr_obj.parameters,cr_obj.model,[cr_obj.reports;rep_esti]);
            data_obj=data_class(features,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,data_obj.features_descriptor,[data_obj.descriptor ' | covariates_regression'],data_obj.feature_grouping);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (covariates_regression class). (number of arguments is not 2)');
end
end