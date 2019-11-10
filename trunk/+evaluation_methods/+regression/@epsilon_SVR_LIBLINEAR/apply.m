function [teval_obj,outputs] =apply(teval_obj,features)
%APPLY (epsilon_SVR_LIBLINEAR class) applies the method defined by
%   epsilon_SVR_LIBLINEAR class.
%   [SVM_OBJ,OUTPUTS]=APPLY(SVM_OBJ,FEATURES) estimates or applies the model 
%   defined by the SVM_OBJ object to the data_class object FEATURES.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in FEATURES to train a model based
%   on the epsilon_SVR_LIBLINEAR method and producdes a epsilon_SVR_LIBLINEAR
%   class object (SVM_OBJ) containing the estimated model. This model is
%   then applied to the training data resulting in results
%   class object, OUTPUTS.
%   2 - APPLICATION mode uses fully defined models to evaluate the
%   data_class object FEATURES producing OUTPUTS (results object). In this 
%   mode SVM_OBJ does not undergoe any change from input to output.

%   [SVM_OBJ,OUTPUTS]=APPLY(SVM_OBJ,FEATURES)

%   APPLY revision history:
%   Date of creation: 27 February 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import evaluation_methods.*
    if ~isa(teval_obj,'evaluation_methods.regression.epsilon_SVR_LIBLINEAR')
        error('apply:InputError',['Undefined function '' apply (epsilon_SVR_LIBLINEAR class) '' for the input argument of type ''' class(teval_obj) ''' (First input argument must be a epsilon_SVR_LIBLINEAR class object).']);
    elseif numel(teval_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(teval_obj)) ') for the first input of function '' apply (epsilon_SVR_LIBLINEAR class).']);
    elseif ~isdata_class(features)
        error('apply:InputError',['Undefined function '' apply (epsilon_SVR_LIBLINEAR class) '' for the input argument of type ''' class(features) ''' (Second input argument must be a data_class class object).']);
    elseif numel(features)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(features)) ') for the  second input of function '' apply (epsilon_SVR_LIBLINEAR class).']);
    else
        %check labels compatibility with this method - uni dimensional classification
        %experiments
        if ~(strcmp(features.evaluation_type,'regression'))
            error('apply:InputError',['Undefined function '' apply (epsilon_SVR_LIBLINEAR class) '' for data_class objects with the ''evaluation_type'' property of type ''' features.evaluation_type ''' .']);
        end
        if teval_obj.parameters.param_eval.value{1}
            dummy_evaluation=evaluation_methods.regression.epsilon_SVR_LIBLINEAR;
            try
                param_report=parameters_checker(dummy_evaluation.parameters,teval_obj.parameters,features);
            catch err
                rethrow(err);
            end
            if ~param_report.flag
                param_report.reporter;
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (epsilon_SVR_LIBLINEAR class) ''. Please check the inputs more details can be found in the error_log');
            end
            clear dummy_evaluation
        end
    end
%% Act: Proceeding to the feature estimation/application process
    status_eval=teval_obj.status{1};
    import evaluation_methods.*
    switch status_eval %selecting the functioning mode
        case 'estimation_ready'
            %selecting the positive class
            option_string=['-q ' param2optstring(teval_obj.parameters)];      
            model=evaluation_methods.auxiliary.liblinear1_96.matlab.train(cell2mat(features.target_values),sparse(features.data),option_string);
            if isempty(model)
               error('apply:FunctionError','It was impossible to estimate a model based on '' epsilon_SVR_LIBLINEAR  ''. Please check your screen for more details.');
            end
            %applying model to the train set
            if teval_obj.parameters.train_eval.value{1}
                try [output_hard,~,output_soft]=evaluation_methods.auxiliary.liblinear1_96.matlab.predict(cell2mat(features.target_values),sparse(features.data),model);
                catch err
                    rethrow(err);
                end
                outputs=results(num2cell(output_hard),output_soft,features.dbcode,features.target_values,features.descriptor,class(teval_obj),features.evaluation_type,features.classes);
            else
                outputs=results;
            end
        case 'application_ready'
            try [output_hard,~,output_soft]=evaluation_methods.auxiliary.liblinear1_96.matlab.predict(cell2mat(features.target_values),sparse(features.data),teval_obj.model);
            catch err
                rethrow(err);
            end
            outputs=results(num2cell(output_hard),output_soft,features.dbcode,features.target_values,features.descriptor,class(teval_obj),features.evaluation_type,features.classes);
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (epsilon_SVR_LIBLINEAR class) '' for the ' status_eval ' input argument of type ''' class(teval_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and template_evaluation
    %class for models.
    switch status_eval
        case 'estimation_ready'
            rep_esti=report('epsilon_SVR_LIBLINEAR',report(),true,[features.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and template_evaluation
            %class for models.
            teval_obj=regression.epsilon_SVR_LIBLINEAR(teval_obj.parameters,model,rep_esti);
        case 'application_ready'
            rep_esti=report('epsilon_SVR_LIBLINEAR',report(),true,[features.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and template_evaluation
            %class for models.
            teval_obj=regression.epsilon_SVR_LIBLINEAR(teval_obj.parameters,teval_obj.model,[teval_obj.reports;rep_esti]);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (epsilon_SVR_LIBLINEAR class). (number of arguments is not 2)');
end

end