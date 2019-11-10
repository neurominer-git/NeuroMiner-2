function [teval_obj,outputs] =apply(teval_obj,features)
%APPLY (TEMPLATE_EVALUATION class) applies the method defined by
%   TEMPLATE_EVALUATION class.
%   [TEVAL,OUTPUTS]=APPLY(TEVAL,FEATURES) estimates or applies the model 
%   defined by the TEVAL class to the data_class object FEATURES.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in FEATURES to train a model based
%   on the TEMPLATE_EVALUATION method and producdes a TEMPLATE_EVALUATION
%   class object (TEVAL_OBJ) containing the estimated model. This model is
%   then applied to the training data resulting in results
%   class object, OUTPUTS.
%   2 - APPLICATION mode uses fully defined models to evaluate the
%   data_class object FEATURES producing OUTPUTS (results object). In this 
%   mode TEVAL_OBJ does not undergoe any change from input to output.

%   [TEVAL_OBJ,OUTPUTS]=APPLY(TEVAL_OBJ,FEATURES)

%   APPLY revision history:
%   Date of creation: 22 October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import evaluation_methods.*
    if ~isa(teval_obj,'evaluation_methods.template_evaluation')
        error('apply:InputError',['Undefined function '' apply (template_evaluation class) '' for the input argument of type ''' class(teval_obj) ''' (First input argument must be a template_evaluation class object).']);
    elseif numel(teval_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(teval_obj)) ') for the first input of function '' apply (template_evaluation class).']);
    elseif ~isdata_class(features)
        error('apply:InputError',['Undefined function '' apply (template_evaluation class) '' for the input argument of type ''' class(features) ''' (Second input argument must be a data_class class object).']);
    elseif numel(features)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(features)) ') for the  second input of function '' apply (template_evaluation class).']);
    else
        %check labels compatibility with this method - uni dimensional classification
        %experiments
        if ischar(features.classes{1})
            error('apply:InputError',['Undefined function '' apply (knn class) '' for ''' features.classes{1} ''' experiments.']);
        else
            cla=features.classes;%classes involved in this classification experiment.
            evaluation_type='classification';
        end
        %e.g.regression function
%         if ischar(features.classes{1})
%            if strcmp(features.classes{1},'regression')
%               evaluation_type=features.classes{1};
%            else
%               error('apply:InputError',['Undefined function '' apply (template_evaluation) '' for ''' features.classes{1} ''' experiments.']);
%            end
%         else
%             error('apply:InputError',['Undefined function '' apply (template_evaluation) '' for classification experiments.']);
%         end
        dummy_template_evaluation=template_evaluation;
        try
            param_report=parameters_checker(dummy_template_evaluation.parameters,teval_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (template_evaluation class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_template_evaluation
    end
%% Act: Proceeding to the feature estimation/application process
    status_eval=teval_obj.status{1};
    import evaluation_methods.auxiliary.*
    %copy the .m file of your function to the folder "auxiliary" in the
    %evaluation_methods package (<NM2 source code directory>/+evaluation_methods/auxiliary)
    
    switch status_eval %selecting the functioning mode
        case 'estimation_ready'
            try
                %here you introduce your previous function, please
                %adapt the needed inputs based on the features as
                %well as the properties of the model
                %IMPORTANT: remember that for classification experiments
                %NM2 accepts strings and integers labels. If your old
                %function works with doubles or any other data please adapt
                %the labels to fit your function (have a look at the
                %auxiliary function target_transformer <NM2 home
                %directory>/auxiliary/target_transformer.m
                %e.g. :
                [output_hard,output_soft,model]=template_evaluation_func(features.data,teval_obj.parameter1{1}.value,teval_obj.parameter2{1}.value,teval_obj.parameter3.value{1},cla);
            catch err
                rethrow(err);
            end
            
            %ATTENTION: please respect outputs structure (see
            %documentation for results class). 
            %Suggestion: You can code here the adaptation of your
            %functions outputs to the NM2 results structure so you
            %don't have to alter your old functions.
            %IMPORTANT: respect labels integrity, if you have changed the
            %labels data_type to fit your function, please do the inverse
            %process for the output definition. Again, we recommend to give
            %a look at the function target_transformer <NM2 home
            %directory>/auxiliary/target_transformer.m
            %e.g. :
            outputs=results(output_hard,output_soft,features.dbcode,features.target_values,features.descriptor,class(teval_obj),evaluation_type);
        case 'application_ready'
            try
                %here you introduce your previous function, please
                %rename so it is template_evaluation_func(...)
                %and adapt the need inputs based on the features as
                %well as the properties of the model.
                %IMPORTANT: remember that for classification experiments
                %NM2 accepts strings and integers labels. If your old
                %function works with doubles or any other data please adapt
                %the labels to fit your function (have a look at the
                %auxiliary function target_transformer <NM2 home
                %directory>/auxiliary/target_transformer.m
                %e.g:
                [output_hard,output_soft]=template_evaluation_func(features.data,teval_obj.model,cla);
            catch err
                rethrow(err);
            end
            %ATTENTION: please respect outputs structure (see
            %documentation for results class).
            %Suggestion: You can code here the adaptation of your
            %functions outputs to the NM2 results structure so you
            %don't have to alter your old functions.
            %IMPORTANT: respect labels integrity, if you have changed the
            %labels data_type to fit your function, please do the inverse
            %process for the output definition. Again, we recommend to give
            %a look at the function target_transformer <NM2 home
            %directory>/auxiliary/target_transformer.m
            %e.g. :
            outputs=results(output_hard,output_soft,features.dbcode,features.target_values,features.descriptor,class(teval_obj),evaluation_type);
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (template_evaluation class) '' for the ' status_eval ' input argument of type ''' class(teval_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and template_evaluation
    %class for models.
    switch status_eval
        case 'estimation_ready'
            rep_esti=report('template_evaluation',report(),true,[features.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and template_evaluation
            %class for models.
            teval_obj=template_evaluation(template_evaluation.parameters,model,rep_esti);
        case 'application_ready'
            rep_esti=report('template_evaluation',report(),true,[features.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and template_evaluation
            %class for models.
            teval_obj=template_evaluation(teval_obj.parameters,teval_obj.model,[teval_obj.reports;rep_esti]);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (template_evaluation class). (number of arguments is not 2)');
end

end

