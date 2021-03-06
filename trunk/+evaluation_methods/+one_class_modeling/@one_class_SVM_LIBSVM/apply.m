function [teval_obj,outputs] =apply(teval_obj,features)
%APPLY (one_class_SVM_LIBSVM class) applies the method defined by
%   one_class_SVM_LIBSVM class.
%   [SVM_OBJ,OUTPUTS]=APPLY(SVM_OBJ,FEATURES) estimates or applies the model 
%   defined by the SVM_OBJ object to the data_class object FEATURES.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in FEATURES to train a model based
%   on the one_class_SVM_LIBSVM method and producdes a one_class_SVM_LIBSVM
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
    if ~isa(teval_obj,'evaluation_methods.one_class_modeling.one_class_SVM_LIBSVM')
        error('apply:InputError',['Undefined function '' apply (one_class_SVM_LIBSVM class) '' for the input argument of type ''' class(teval_obj) ''' (First input argument must be a one_class_SVM_LIBSVM class object).']);
    elseif numel(teval_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(teval_obj)) ') for the first input of function '' apply (one_class_SVM_LIBSVM class).']);
    elseif ~isdata_class(features)
        error('apply:InputError',['Undefined function '' apply (one_class_SVM_LIBSVM class) '' for the input argument of type ''' class(features) ''' (Second input argument must be a data_class class object).']);
    elseif numel(features)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(features)) ') for the  second input of function '' apply (one_class_SVM_LIBSVM class).']);
    else
        %check labels compatibility with this method - uni dimensional classification
        %experiments
        if ~(strcmp(features.evaluation_type,'one_class_modeling'))
            error('apply:InputError',['Undefined function '' apply (one_class_SVM_LIBSVM class) '' for data_class objects with the ''evaluation_type'' property of type ''' features.evaluation_type ''' .']);
        end
        if teval_obj.parameters.param_eval.value{1}
            dummy_evaluation=evaluation_methods.one_class_modeling.one_class_SVM_LIBSVM;
            try
                param_report=parameters_checker(dummy_evaluation.parameters,teval_obj.parameters,features);
            catch err
                rethrow(err);
            end
            if ~param_report.flag
                param_report.reporter;
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (one_class_SVM_LIBSVM class) ''. Please check the inputs more details can be found in the error_log');
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
            train_indic=find(cell2mat(features.target_values)>0);
            train_examples=features.data_selector(train_indic);
            train_indic(train_indic==0)=[];
            option_string=['-q -s 2 ' param2optstring(teval_obj.parameters)];
            weight_data_instances=teval_obj.parameters.weight_data_instances.value{1};
            if isempty(weight_data_instances)
               weight_data_instances=[];
            else
                weight_data_instances=weight_data_instances(train_indic);
            end
            model=evaluation_methods.auxiliary.libsvm3_12.matlab.svmtrain312(weight_data_instances,train_indic,train_examples.data,option_string);
            if isempty(model)
               error('apply:FunctionError','It was impossible to estimate a model based on '' one_class_SVM_LIBSVM  ''. Please check your screen for more details.');
            end
            %applying model to the train set
            if teval_obj.parameters.train_eval.value{1}
                try [output_hard,~,output_soft]=evaluation_methods.auxiliary.libsvm3_12.matlab.svmpredict312(cell2mat(features.target_values),features.data,model,'');
                catch err
                    rethrow(err);
                end
                outputs=results(num2cell(output_hard),output_soft,features.dbcode,features.target_values,features.descriptor,class(teval_obj),features.evaluation_type,features.classes);
            else
                outputs=results;
            end
        case 'application_ready'
            if isfield(teval_obj.model,'weight_vector')
                model=rmfield(teval_obj.model,'weight_vector');
            else
                model=teval_obj.model;
            end
            try [output_hard,~,output_soft]=evaluation_methods.auxiliary.libsvm3_12.matlab.svmpredict312(double(cell2mat(features.target_values)),features.data,model,'');
            catch err
                rethrow(err);
            end
            outputs=results(num2cell(output_hard),output_soft,features.dbcode,features.target_values,features.descriptor,class(teval_obj),features.evaluation_type,features.classes);
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (one_class_SVM_LIBSVM class) '' for the ' status_eval ' input argument of type ''' class(teval_obj) '''.']);
    end
    %% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and template_evaluation
    %class for models.
    switch status_eval
        case 'estimation_ready'
            rep_esti=report('one_class_SVM_LIBSVM',report(),true,[features.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and template_evaluation
            %class for models.
            teval_obj=one_class_modeling.one_class_SVM_LIBSVM(teval_obj.parameters,model,rep_esti);
        case 'application_ready'
            rep_esti=report('one_class_SVM_LIBSVM',report(),true,[features.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and template_evaluation
            %class for models.
            teval_obj=one_class_modeling.one_class_SVM_LIBSVM(teval_obj.parameters,teval_obj.model,[teval_obj.reports;rep_esti]);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (one_class_SVM_LIBSVM class). (number of arguments is not 2)');
end

end

