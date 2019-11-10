function enl_obj =apply(enl_obj,outputs_array)
%APPLY (ENSEMBLE_LEARNING class) performs the ensemble_learning procedure 
%   EnL =APPLY(EnL,Eval) applies the ensemble_learning processed defined in the
%   model property of the ensemble_learning object (EnL) over the data
%   defined in the array of RESULTS objects, Eval. The result of 
%   the ensemble_learning process is recorded in EnL's outputs property,
%   a report is produced and stored in EnL's reports property.
%
%   APPLY has two main modes, estimation and application.
%
%   ESTIMATION mode uses the data in the EVAL variable to estimate the 
%   models defined in the models property of the same objetc. This mode is 
%   activated when:
%       1 - The EnL object has the status 'estimation_ready', meaning that
%       there is a model ready to be estimated with the correspondent
%       documentation (reports property defined in the EnL object).
%
%   APPLICATION mode uses a fully defined model to evaluate the data in the
%   EVAL variable. This mode is activated when the the model in the
%   EnL's models property has the status 'application_ready' meaning that
%   there is model already defined and ready to be applied accompanied by
%   the correspondent documentation
%
%   EnL (output) is a EnL object class that resulted from the application
%   of the methods defined in the EnL class to the EVAL variable.


%   EnL =APPLY(EnL,Eval)

%   APPLY revision history:
%   Date of creation: 09 July 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    if ~isensemble_learning(enl_obj)
        error('apply:InputError',['Undefined function '' apply (ensemble_learning class) '' for the input argument of type ''' class(enl_obj) ''' (First input argument must be a ensemble_learning class object).']);
    elseif numel(enl_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(enl_obj)) ') for the first input of function '' apply (ensemble_learning class).']);
    elseif ~all(isresults(outputs_array))
        error('apply:InputError',['Undefined function '' apply (ensemble_learning class) '' for the input argument of type ''' class(outputs_array) ''' (Second input argument must be an array of results class object).']);
    elseif strcmp(enl_obj.status,'complete')
        warning('apply:InputError',['The input argument of type ''' class(enl_obj) ''' provided to the function '' apply (ensemble_learning class) '' is already complete. Nothing to do.']);
        return
    elseif strcmp(enl_obj.status,'invalid')||strcmp(enl_obj.status,'empty')
        error('apply:InputError',['Undefined function '' apply (ensemble_learning class) '' for the ' status.enl_obj ' first input argument of type ''' class(enl_obj) '''.']);
    end
    try
        flag_exist=is_package(class(enl_obj),'ensemble_learning_methods');
    catch err
        rethrow(err);
    end
    if flag_exist
        import ensemble_learning_methods
    else
        error('apply:FunctionError',['Ensemble_Learning method ' class(enl_obj.model) ' not found in the ensemble_learning toolbox please check if the method is valid.']);
    end
    
    %% Act: Proceeding to the feature estimation process
    status_enl=enl_obj.status{1};
    switch status_enl %selecting the functioning mode
        case 'estimation_ready'
                try
                    [aux_enl_method,outputs]=apply(enl_obj.models,outputs_array);
                catch err
                    rethrow(err);
                end
                enl_obj=ensemble_learning(aux_enl_method,aux_enl_method.reports,outputs);
            
        case 'application_ready'
            
               try
                    [aux_enl_method,outputs]=apply(enl_obj.model,outputs_array);
                catch err
                    rethrow(err);
                end
                enl_obj=ensemble_learning(enl_obj.model,aux_enl_method.reports,outputs);
            
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (ensemble_learning class) '' for the ' status_enl ' input argument of type ''' class(enl_obj) '''.']);
    end
    %% Finale: Producing the overall ensemble learning report
    report_string=status_enl;
    aux_=strfind(report_string,'_');
    report_string=report_string(1:aux_(1)-1);
    final_report=report(class(enl_obj),enl_obj.reports,true,[datestr(clock) ' - ' report_string]);
    final_report=flag_decider(final_report);
    enl_obj=evaluation(enl_obj.model,final_report,enl_obj.output); 
else
    error('apply:InputError','Invalid number of arguments for function '' apply (ensemble_learning class). (number of arguments is not 1)');
end

end