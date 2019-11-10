function val_obj =apply(val_obj,dataset)
%APPLY (VALIDATION class) performs the validation procedure 
%   VAL =APPLY(VAL,DATASET) applies the validation processed defined in the
%   method property of the validation object (VAL) over the data
%   defined in the data_class object DATASET. The result of 
%   the validation process is recorded in VAL's design property and
%   a report is produced and stored in VAL's reports property.
%
%   VAL (output) is a VAL object class that resulted from the application
%   of the methods defined in the VAL class to the DATASET variable.

%   VAL =APPLY(VAL,DATASET)

%   APPLY revision history:
%   Date of creation: 08 July 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    if ~isvalidation(val_obj)
        error('apply:FunctionError',['Undefined function '' apply (validation class) '' for the input argument of type ''' class(val_obj) ''' (First input argument must be a validation class object).']);
    elseif numel(val_obj)~=1
        error('apply:FunctionError',['Invalid number of elements (' num2str(numel(val_obj)) ') for the first input of function '' apply (validation class).']);
    elseif numel(dataset)~=1
        error('apply:FunctionError',['Invalid number of elements (' num2str(numel(dataset)) ') for the second input of function '' apply (validation class).']);
    elseif ~isdata_class(dataset)
        error('apply:FunctionError',['Undefined function '' apply (validation class) '' for the input argument of type ''' class(dataset) ''' (Second input argument must be a data_class class object).']);
    elseif strcmp(val_obj.status,'complete')
        warning(['The input argument of type ''' class(val_obj) ''' provided to the function '' apply (validation class) '' is already complete. Nothing to do.']);
        return
    elseif any(strcmp(val_obj.status,'invalid'))
        error('apply:FunctionError',['Undefined function '' apply (val_objidation class) '' for the ' val_obj.status ' first input argument of type ''' class(val_obj) '''.']);
    elseif any(strcmp(val_obj.status,'empty'))
         error('apply:FunctionError',['Undefined function '' apply (val_objidation class) '' for the ' val_obj.status ' first input argument of type ''' class(val_obj) '''.']);
    end
    try
        flag_exist=is_package(class(val_obj.method),'validation_methods');
    catch err
        rethrow(err);
    end
    if flag_exist
        import validation_methods
    else
        error('apply:FunctionError',['Validation method ' class(val_obj.method) ' not found in the validation toolbox please check if the method is valid.']);
    end
    
    %% Act: Proceeding to the feature estimation process
    status_val=val_obj.status;
    switch status_val %selecting the functioning mode
        case 'incomplete'
                try
                    [val_obj,design]=val_obj.method.apply(dataset);
                catch err
                    rethrow(err);
                end            
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (validation class) '' for the ' status_val ' input argument of type ''' class(val_obj) '''.']);
    end
    
    %% Finale: Checking the  status of the validation object and producing the overall validation report
    %checking the status of the validation object
    final_report1=report(class(val_obj),val_obj.reports,true,datestr(clock));
    final_report1=flag_decider(final_report1);
    val_obj1=validation(val_obj,final_report1,design);
    status_val=val_obj1.status;
    %building the final report
    final_report=report(class(val_obj),val_obj.reports,true,[ datestr(clock) '-' status_val]);
    final_report=flag_decider(final_report);
    val_obj=validation(val_obj,final_report,design);
else
    error('apply:FunctionError','Invalid number of arguments for function '' apply (validation class). (number of arguments is not 2)');
end

end