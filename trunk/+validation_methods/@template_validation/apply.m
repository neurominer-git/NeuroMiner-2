function [tval_obj,design] =apply(tval_obj,data_obj)
%APPLY (TEMPLATE_VALIDATION class) performs feature extraction 
%   [TVAL,DESIGN]=APPLY(TVAL,FEATURES) estimates the validation strategy
%   implemented in the TEMPLATE_VALIDATION class for the DATA_CLASS object
%   FEATURES in the form of VALIDATION_DESIGN class object DESIGN.
%

%   [TVAL,DESIGN] =APPLY(TVAL,FEATURES)

%   APPLY revision history:
%   Date of creation: 09 September 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    if ~isa(tval_obj,'template_validation')
        error('apply:InputError',['Undefined function '' apply (template_validation class) '' for the input argument of type ''' class(tval_obj) ''' (First input argument must be a template_validation class object).']);
    elseif numel(tval_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(tval_obj)) ') for the first input of function '' apply (template_validation class).']);
    elseif isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (template_validation class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (template_validation class).']);
    else
        dummy_template_validation=template_validation;
        try
            param_report=parameters_checker(dummy_template_validation.parameters,tval_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (template_validation class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_template_validation
    end
    %% Act: Proceeding to the design definition
    
    %here you introduce your previous function, please
    %rename so it is template_validation_func(...)
    %and adapt the need inputs based on the design properties (see
    %documentation of validation class)
    %e.g:
    try [train,test]=template_validation_func(data_obj.data,tval_obj.parameter1.value,parameter2.value,parameter2.value);
    catch err
        rethrow(err)
    end
    %design1 - this is the validation_design object that defines a nested validation processin the training set, if you have none just input an empty validation_design object or nothing;
    design=validation_design(train,test,data_obj.target_values,data_obj.classes,design1); %adapting your own outputs to the NM2 convention (see VALIDATION_DESIGN documentation)
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and template_validation
    %class for models.
    
    rep_esti=report('template_validation',report(),true,[data_obj.descriptor ' | application']);
    %Organization of the results of processing in the classes
    %data_class for features and template_validation
    %class for models.
    aux_reports=tval_obj.reports;
    aux_reports.subprocesses=[aux_reports.subprocesses;rep_esti];
    aux_reports=aux_reports.flag_decider;
    tval_obj=tval_obj(tval_obj.parameters,aux_reports);

else
    error('apply:InputError','Invalid number of arguments for function '' apply (template_validation class). (number of arguments is not 2)');
end

end