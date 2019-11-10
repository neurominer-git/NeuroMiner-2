function [cv_obj,design] =apply(cv_obj,data_obj)
%APPLY (CV class) performs feature extraction 
%   [CV,DESIGN]=APPLY(CV,FEATURES) defines the validation strategy
%   implemented in the CV class for the DATA_CLASS object
%   FEATURES in the form of a VALIDATION_DESIGN array, DESIGN.
%

%   [CV,DESIGN] =APPLY(CV,FEATURES)

%   APPLY revision history:
%   Date of creation: 09 September 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
import validation_methods.*
if nargin==2
    if ~isa(cv_obj,'validation_methods.cv')
        error('apply:InputError',['Undefined function '' apply (cv class) '' for the input argument of type ''' class(cv_obj) ''' (First input argument must be a cv class object).']);
    elseif numel(cv_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(cv_obj)) ') for the first input of function '' apply (cv class).']);
    elseif ~isdata_class(data_obj)
        error('apply:InputError',['Undefined function '' apply (cv class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' apply (cv class).']);
    elseif isempty(data_obj)
        error('apply:InputError','Undefined function '' apply (cv class) '' for empty data_class objects');
    else
        dummy_cv=cv;
        try
        param_report=parameters_checker(dummy_cv.parameters,cv_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
           param_report.reporter;
           error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (cv class) ''. Please check the inputs, more details can be found in the error_log');
        end
        clear dummy_cv
    end
    %% Act: Proceeding to the design definition
    mode=cv_obj.parameters.mode.value{1};
    nof=cv_obj.parameters.number_of_folds.value{1};
    switch mode
        case 'none'
            val=numel(data_obj.dbcodes);
            % main CV folds
            dummy=validation_design();
            c=cvpartition(val,'k',nof(1));
            for i=1:nof(1)
                train_ind=c.training(i);
                test_ind=c.test(i);
                if numel(nof)>1
                    number_of_folds=parameters({nof(2:end)});
                    mode1=parameters({mode});
                    parameter=struct('number_of_folds',number_of_folds,'mode',mode1);
                    cv_obj2=cv(parameter);
                    train_data=data_selector(data_obj,train_ind);
                    try
                        [~,design1]=apply(cv_obj2,train_data);
                    catch err
                        rethrow(err);
                    end
                else
                    design1=validation_design();
                end
                dummy=[dummy;validation_design(train_ind,test_ind,data_obj.target_values,data_obj.evaluation_type,design1)];
            end
            design=dummy(2:end);
        case 'class balanced'
            targets=data_obj.target_values;
            if isnumeric(targets{1})||islogical(targets{1})
               targets=cell2mat(targets);
            end
            % main CV folds
            dummy=validation_design();
            c=cvpartition(targets,'k',double(nof(1)));
            for i=1:nof(1)
                train_ind=c.training(i);
                test_ind=c.test(i);
                if numel(nof)>1
                    number_of_folds=parameters({nof(2:end)});
                    mode1=parameters({mode});
                    parameter=struct('number_of_folds',number_of_folds,'mode',mode1);
                    cv_obj2=cv(parameter);
                    train_data=data_selector(data_obj,train_ind);
                    try
                        [~,design1]=apply(cv_obj2,train_data);
                    catch err
                        rethrow(err);
                    end
                else
                    design1=validation_design();
                end
                dummy=[dummy;validation_design(train_ind,test_ind,data_obj.target_values,data_obj.evaluation_type,design1)];
            end
            design=dummy(2:end);
        otherwise
          error('apply:IncompatibilityError',['Invalid mode ' mode ' for the cv object']);  
    end
      
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and cv
    %class for models.
    
    rep_esti=report('cv',report(),true,[data_obj.descriptor ' | application']);
    %Organization of the results of processing in the classes
    %data_class for features and cv
    %class for models.
    cv_obj=cv(cv_obj.parameters,rep_esti);

else
    error('apply:InputError','Invalid number of arguments for function '' apply (cv class). (number of arguments is not 2)');
end

end