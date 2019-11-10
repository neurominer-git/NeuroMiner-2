function [tens_obj,outputs] =apply(tens_obj,results_array)
%APPLY (TEMPLATE_ENSEMBLE_LEARNING class) applies the method defined by
%   TEMPLATE_ENSEMBLE_LEARNING class.
%   [TENS_OBJ,OUTPUTS]=APPLY(TENS_OBJ,RESULTS_ARRAY) estimates or applies 
%   the model defined by the TEMPLATE_ENSEMBLE_LEARNING class, TENS_OBJ to 
%   the array of RESULTS class RESULTS_ARRAY.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in RESULTS_ARRAY to train a model based
%   on the TEMPLATE_ENSEMBLE_LEARNING method and produces a TEMPLATE_ENSEMBLE_LEARNING
%   class object (TENS_OBJ) containing the estimated model. This model is
%   then applied to the training data resulting in results
%   class object, OUTPUTS.
%   2 - APPLICATION mode uses fully defined models to evaluate the array of
%   results objects RESULTS_ARRAY producing OUTPUTS (results object). In this 
%   mode TENS_OBJ does not undergo any change from input to output.

%   [TENS_OBJ,OUTPUTS]=APPLY(TENS_OBJ,EVAL_ARRAY)

%   APPLY revision history:
%   Date of creation: 09 September 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import ensemble_learning_methods.*
    if ~isa(tens_obj,'ensemble_learning_methods.template_ensemble_learning')
        error('apply:InputError',['Undefined function '' apply (template_ensemble_learning class) '' for the input argument of type ''' class(tens_obj) ''' (First input argument must be a template_ensemble_learning class object).']);
    elseif numel(tens_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(tens_obj)) ') for the first input of function '' apply (template_ensemble_learning class).']);
    elseif isresults(results_array)
        error('apply:InputError',['Undefined function '' apply (template_ensemble_learning class) '' for the input argument of type ''' class(results_array) ''' (Second input argument must be a data_class class object).']);
    elseif numel(results_array)<1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(results_array)) ') for the  second input of function '' apply (template_ensemble_learning class).']);
    else
        dummy_template_ensemble_learning=template_ensemble_learning;
        try
            param_report=parameters_checker(dummy_template_ensemble_learning.parameters,tens_obj.parameters,results_array);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (template_ensemble_learning class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_template_ensemble_learning
    end
%% Act: Proceeding to the feature estimation/application process
    status_eval=status.tens_obj{1};
    import ensemble_learning_methods.auxiliary.*
    evaluation_type='classification';%possible values: classification or regression
    %copy the .m file of your function to the folder "auxiliary" in the
    %ensemble_learning_methods package (<NM2 source code directory>/+ensemble_learning_methods/auxiliary)
    switch status_eval %selecting the functioning mode
        case 'estimation_ready'
            try
                %here you introduce your previous function, please
                %adapt the needed inputs based on the results_array as
                %well as the properties of the model
                % Please remember that the class RESULTS contains the
                % method FUSER. This method receives an array of
                % RESULTS objects and fuses them in a single RESULTS
                % object. You can use then the UNIQUE function on the
                % dbcodes to obtain the number of examples and their unique
                % designation. Afterwards you can use STRCMP to find all
                % the values correspondent to one db_code
                %e.g:
                [output_hard,output_soft,model]=template_ensemble_learning_func(results_array.data,tens_obj.parameter1.value,parameter2.value,parameter3.value);
            catch err
                rethrow(err);
            end
            outputs=results(output_hard,output_soft,results_array.dbcode,results_array.target_values,results_array.descriptor,class(tens_obj),evaluation_type);
            %ATTENTION: please respect outputs structure (see
            %documentation for results class).
            %Suggestion: You can code here the adaptation of your
            %functions outputs to the NM2 results structure so you
            %don't have to alter your old functions.
        case 'application_ready'
            try
                %here you introduce your previous function, please
                %rename so it is template_ensemble_learning_func(...)
                %and adapt the need inputs based on the eval_array as
                %well as the properties of the model
                %e.g:
                [output_hard,output_soft]=template_ensemble_learning_func(results_array.data,tens_obj.model);
            catch err
                rethrow(err);
            end
            outputs=results(output_hard,output_soft,results_array.dbcode,results_array.target_values,results_array.descriptor,class(tens_obj),evaluation_type);
            %ATTENTION: please respect outputs structure (see
            %documentation for results class).
            %Suggestion: You can code here the adaptation of your
            %functions outputs to the NM2 results structure so you
            %don't have to alter your old functions.
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (template_ensemble_learning class) '' for the ' status_eval ' input argument of type ''' class(tens_obj) '''.']);
    end
%% Finale: Building reports
    %Organization of the results of processing in the classes
    %results for results_array and template_ensemble_learning
    %class for models.
    switch status_eval
        case 'estimation_ready'
            rep_esti=report('template_ensemble_learning',report(),true,[results_array.descriptor ' | ensemble estimation']);
            %Organization of the results of processing in the classes
            %data_class for eval_array and template_ensemble_learning
            %class for models.
            tens_obj=template_ensemble_learning(template_ensemble_learning.parameters,model,rep_esti);
        case 'application_ready'
            rep_esti=report('template_ensemble_learning',report(),true,[results_array.descriptor ' | ensemble application']);
            %Organization of the results of processing in the classes
            %data_class for eval_array and template_ensemble_learning
            %class for models.
            tens_obj=template_ensemble_learning(tens_obj.parameters,tens_obj.model,[tens_obj.reports;rep_esti]);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (template_ensemble_learning class). (number of arguments is not 2)');
end
end