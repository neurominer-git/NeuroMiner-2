function eval_obj =apply(eval_obj,features)
%APPLY (EVALUATION class) performs the evaluation procedure 
%   EVAL =APPLY(EVAL,FEATURES) applies the evaluation processed defined in the
%   model property of the evaluation object (EVAL) over the data
%   defined in the data_class object FEATURES. The result of 
%   the evaluation process is recorded in EVAL's outputs property and
%   a report is produced and stored in EVAL's reports property.
%
%   APPLY has two main modes, estimation and application.
%
%   ESTIMATION mode uses the data in the features variable to estimate the 
%   models defined in the models property of the same objetc. This mode is 
%   activated when:
%       1 - The EVAL object has the status 'estimation_ready', meaning that
%       there is a model ready to be estimated with the correspondent
%       documentation (reports property defined in the EVAL object).
%
%   APPLICATION mode uses a fully defined model to evaluate the data in the
%   FEATURES variable. This mode is activated when the the model in the
%   EVAL's models property has the status 'application_ready' meaning that
%   there is model already defined and ready to be applied accompanied by
%   the correspondent documentation
%
%   EVAL (output) is a EVAL object class that resulted from the application
%   of the methods defined in the EVAL class to the FEATURES variable.


%   EVAL =APPLY(EVAL,FEATURES)

%   APPLY revision history:
%   Date of creation: 08 July 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    if ~isevaluation(eval_obj)
        error('apply:InputError',['Undefined function '' apply (evaluation class) '' for the input argument of type ''' class(eval_obj) ''' (First input argument must be a evaluation class object).']);
    elseif numel(eval_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(eval_obj)) ') for the first input of function '' apply (evaluation class).']);
    elseif numel(features)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(features)) ') for the second input of function '' apply (evaluation class).']);
    elseif ~isdata_class(features)
        error('apply:InputError',['Undefined function '' apply (evaluation class) '' for the input argument of type ''' class(features) ''' (Second input argument must be a data_class class object).']);
    elseif strcmp(eval_obj.status{1},'complete')
        warning(['The input argument of type ''' class(eval_obj) ''' provided to the function '' apply (evaluation class) '' is already complete. Nothing to do.']);
        return
    elseif strcmp(eval_obj.status{1},'invalid')||strcmp(eval_obj.status{1},'empty')
        error('apply:InputError',['Undefined function '' apply (evaluation class) '' for the ' eval_obj.status{1} ' first input argument of type ''' class(eval_obj) '''.']);
    end
    
    flag_exist=~isempty(strfind(class(eval_obj.model),'evaluation_methods'));
    
    if flag_exist
        import evaluation_methods
    else
        error('apply:FunctionError',['Evaluation method ' class(eval_obj.model) ' not found in the evaluation toolbox please check if the method is valid.']);
    end
    %% Act: Proceeding to the feature estimation process
    status_eval=eval_obj.status{1};
    switch status_eval %selecting the functioning mode
        case 'estimation_ready'
                try
                    [aux_eval_method,outputs]=apply(eval_obj.model,features);
                catch err
                    rethrow(err);
                end
                eval_obj=evaluation(aux_eval_method,aux_eval_method.reports,outputs);
        case 'application_ready'
            
               try
                    [aux_eval_method,outputs]=apply(eval_obj.model,features);
                catch err
                    rethrow(err);
                end
                eval_obj=evaluation(eval_obj.model,aux_eval_method.reports,outputs);
            
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (evaluation class) '' for the ' status_eval ' input argument of type ''' class(eval_obj) '''.']);
    end
    %% Finale: Producing the overall feature_extractiom report
    report_string=status_eval;
    aux_=strfind(report_string,'_');
    report_string=report_string(1:aux_(1)-1);
    final_report=report(class(eval_obj),eval_obj.reports,true,[datestr(clock) ' - ' report_string]);
    final_report=flag_decider(final_report);
    eval_obj=evaluation(eval_obj.model,final_report,outputs);
else
    error('apply:InputError','Invalid number of arguments for function '' apply (evaluation class). (number of arguments is not 1)');
end

end