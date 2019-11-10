function [tens_obj,outputs] =apply(tens_obj,results_array)
%APPLY (MAJORITY_VOTING class) applies the method defined by the
%   MAJORITY_VOTING class.
%   [TENS_OBJ,OUTPUTS]=APPLY(TENS_OBJ,RESULTS_ARRAY) calculates the class 
%   with the greatest support in the ensemble (hard_labels) and the 
%   distribution of the support across the labels space (soft_labels)
%   for each one of the unique examples present in
%   RESULTS_ARRAY.
%
%   APPLY has only one mode application as there is no model to be
%   estimated.

%   [TENS_OBJ,OUTPUTS]=APPLY(TENS_OBJ,EVAL_ARRAY)

%   APPLY revision history:
%   Date of creation: 30 of October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import ensemble_learning_methods.*
    if ~isa(tens_obj,'ensemble_learning_methods.majority_voting')
        error('apply:InputError',['Undefined function '' apply (majority_voting class) '' for the input argument of type ''' class(tens_obj) ''' (First input argument must be a majority_voting class object).']);
    elseif numel(tens_obj)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(tens_obj)) ') for the first input of function '' apply (majority_voting class).']);
    elseif ~isresults(results_array)
        error('apply:InputError',['Undefined function '' apply (majority_voting class) '' for the input argument of type ''' class(results_array) ''' (Second input argument must be a RESULTS class array).']);
    elseif numel(results_array)<1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(results_array)) ') for the  second input of function '' apply (majority_voting class).']);
    end
    %% Act: Proceeding to the feature estimation/application process
    evaluation_type=results_array.evaluation_type;
    aux_results=results_array.fuser;
    single_subjects=unique(aux_results.dbcode);
    if any(strcmp(evaluation_type,{'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'}))
        labels=aux_results.classes;
        for i=1:numel(single_subjects)
            aux_dbcode=strcmp(single_subjects{i},aux_results.dbcode);
            aux_hard=aux_results.hard_labels(aux_dbcode,:);
            voting=zeros(1,numel(labels));
            for j=1:numel(labels)
                
                voting(j)=sum(cell2mat(aux_hard)==labels(j));
            end
            [~,pos]=max(voting);
            aux_hard=num2cell(labels(pos));
            aux_find=find(aux_dbcode);
            outputs(i)=results(aux_hard,voting/sum(voting),single_subjects(i),aux_results.target_values(aux_find(1)),aux_results.features,aux_results.descriptor,evaluation_type,labels);
        end
    else
        outputs=results;
    end
    outputs=outputs.fuser;
    
    %% Finale: Building reports
    if size(aux_results.features,1)>1
       aux_features='';
       for i=1:numel(size(aux_results.features,1))
           aux_features=[aux_features ' , ' aux_results.features(i,:)];
       end
       aux_features=aux_features(2:end);
    else
       aux_features=aux_results.features; 
    end
    if size(aux_results.descriptor,1)>1
        aux_evaluation='';
        for i=1:numel(size(aux_results.descriptor,2))
            aux_evaluation=[aux_evaluation ' , ' aux_results.descriptor(i,:)];
        end
        aux_evaluation=aux_evaluation(2:end);
    else
        aux_evaluation=aux_results.descriptor;
    end
    rep_esti=report('majority_voting',report(),true,[aux_features ' | ' aux_evaluation ' | ensemble application']);
    %Organization of the results of processing in the classes
    %data_class for eval_array and majority_voting
    %class for models.
    tens_obj=majority_voting(tens_obj.parameters,tens_obj.model,rep_esti);
else
    error('apply:InputError','Invalid number of arguments for function '' apply (majority_voting class). (number of arguments is not 2)');
end
end