function [knn_obj,outputs] =apply(knn_obj,features)
%APPLY (KNN class) applies the method defined by
%   KNN class.
%   [KNN_OBJ,OUTPUTS]=APPLY(KNN_OBJ,FEATURES) estimates or applies the model 
%   defined by the KNN class to the data_class object FEATURES.
%
%   APPLY has two main modes, estimation and application.
%   1 - Estimation uses the data in FEATURES to train a model based
%   on the KNN method (not really ... this is kNN)and produces a KNN
%   class object (KNN_OBJ) containing the estimated model. This model is
%   then applied to the training data resulting in results
%   class object, OUTPUTS.
%   2 - APPLICATION mode uses fully defined models to evaluate the
%   data_class object FEATURES producing OUTPUTS (results object). In this 
%   mode KNN_OBJ does not undergoe any change from input to output.

%   [KNN_OBJ,OUTPUTS]=APPLY(KNN_OBJ,FEATURES)

%   APPLY revision history:
%   Date of creation: 22 of October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import evaluation_methods.*
    if ~isa(knn_obj,'evaluation_methods.binary_classification.knn')
        error('apply:InputError',['Undefined function '' apply (knn class) '' for the input argument of type ''' class(knn_obj) ''' (First input argument must be a knn class object).']);
    elseif numel(knn_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(knn_obj)) ') for the first input of function '' apply (knn class).']);
    elseif ~isdata_class(features)
        error('apply:InputError',['Undefined function '' apply (knn class) '' for the input argument of type ''' class(features) ''' (Second input argument must be a data_class class object).']);
    elseif numel(features)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(features)) ') for the  second input of function '' apply (knn class).']);
    else
        %check labels compatibility with this method - uni dimensional classification
        %experiments
        if any(strcmp(features.evaluation_type,{'binary_classification','multiclass_classification'}))
            classes=features.classes;
        else
           error('apply:InputError',['Undefined function '' apply (knn class) '' for data_class objects with the ''evaluation_type'' property of type ''' features.evaluation_type ''' .']);
        end
        if knn_obj.parameters.param_eval.value{1}
            dummy_knn=binary_classification.knn;
            try
                param_report=parameters_checker(dummy_knn.parameters,knn_obj.parameters,features);
            catch err
                rethrow(err);
            end
            if ~param_report.flag
                param_report.reporter;
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (knn class) ''. Please check the inputs more details can be found in the error_log');
            end
            clear dummy_knn
        end
    end
%% Act: Proceeding to the feature estimation/application process
status_eval=knn_obj.status{1};
import evaluation_methods.auxiliary.*
    switch status_eval %selecting the functioning mode
        case 'estimation_ready'
            %In estimation_ready processing more than one class is
            %necessary for the learning process
            if numel(classes)<2
               error('apply:InputError',['Undefined function '' apply (knn class) {estimation mode}'' for  experiments with ' numel(cla) ' class labels.']); 
            end
            %check is all the classes are represented in the training
            %set,if not issue a warning.
            aux_represent=setdiff(features.classes,unique(cell2mat(features.target_values)));
            if ~isempty(aux_represent);
               warning('apply:InputWarning','Not all classes represented in the training process');
            end
            try
                [output_soft,output_hard]=knnclass(features.data,features.data,cell2mat(features.target_values),knn_obj.parameters.neighbours.value{1},knn_obj.parameters.distance.value{1},knn_obj.parameters.p_mahalanobis.value{1},classes);
            catch err
                rethrow(err);
            end
            outputs=results(num2cell(output_hard),output_soft,features.dbcode,features.target_values,features.descriptor,class(knn_obj),features.evaluation_type,classes);
            model.space=features.data;
            model.target_values=cell2mat(features.target_values);
            model.classes=features.classes;
            model.db_codes=features.dbcode;
        case 'application_ready'
            try
                [output_soft,output_hard]=knnclass(knn_obj.model.space,features.data,knn_obj.model.target_values,knn_obj.parameters.neighbours.value{1},knn_obj.parameters.distance.value{1},knn_obj.parameters.p_mahalanobis.value{1},knn_obj.model.classes);       
            catch err
                rethrow(err);
            end
            outputs=results(num2cell(output_hard),output_soft,features.dbcode,features.target_values,features.descriptor,class(knn_obj),features.evaluation_type,classes);
        otherwise
            error('apply:FunctionError',['Undefined function '' apply (knn class) '' for the ' status_eval ' input argument of type ''' class(knn_obj) '''.']);
    end
%% Finale: Building reports
    %Organization of the results of processing in the classes
    %data_class for features and knn
    %class for models.
    switch status_eval
        case 'estimation_ready'
            rep_esti=report('knn',report(),true,[features.descriptor ' | estimation']);
            %Organization of the results of processing in the classes
            %data_class for features and knn
            %class for models.
            knn_obj=binary_classification.knn(knn_obj.parameters,model,rep_esti);
        case 'application_ready'
            rep_esti=report('knn',report(),true,[features.descriptor ' | application']);
            %Organization of the results of processing in the classes
            %data_class for features and knn
            %class for models.
            knn_obj=binary_classification.knn(knn_obj.parameters,knn_obj.model,[knn_obj.reports;rep_esti]);
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (knn class). (number of arguments is not 2)');
end

end

