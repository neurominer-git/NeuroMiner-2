%Type: Script
%Title: NM2 backbone alpha testing
%Date: 09-Sep-2014
%Creator: Carlos Cabral
clear all
clear classes
close all
clc
addpath('/home/neurominer_develop/NM2/trunk/')
addpath('/home/neurominer_develop/NM2/trunk/auxiliary/')
%% Data definition
tic
%% Validation Strategy
import validation_methods.*
%cv parameter creation
number_of_folds=parameters(int16([10 10]));
mode=parameters('class balanced');
param.number_of_folds=number_of_folds;
param.mode=mode;
%cv creation
val=validation(cv(param));
val=val.apply(data);
import feature_extraction_methods.*
import evaluation_methods.*
ind=1;
ap=binary_classification.C_SVM_LIBLINEAR;
for i=1:numel(val.design);
    %% Get training and testing set - CV2
    design_cv2=val.design(i);
    train=design_cv2.get_train(data);
    test=design_cv2.get_test(data);
    methods.scaling=scaling;
    %% Feature Extraction - CV2
    %train
    fextrain=feature_extraction(methods,train);
    fextrain=fextrain.apply;
    %test
    fexttest=feature_extraction(fextrain.models,test);
    fexttest=fexttest.apply;
    %% Evaluation - CV2
    train_evlt=apply(evaluation(ap),fextrain.features);
    test_evl=evaluation(train_evlt.model,train_evlt.reports);
    test_evl=apply(test_evl,fexttest.features);
    aux_results(ind)=test_evl.output;
    ind=ind+1;
    %defining the
    for j=1:numel(design_cv2.design);
        %% Get training and testing set
        design_cv1=design_cv2.design(j);
        train_cv1=design_cv1.get_train(train);
        test_cv1=design_cv1.get_test(train);
        %% Feature Extraction
        %train
        fextrain_cv1=feature_extraction(methods,train_cv1);
        fextrain_cv1=fextrain_cv1.apply;
        %test
        fexttest_cv1=feature_extraction(fextrain_cv1.models,test_cv1);
        fexttest_cv1=fexttest_cv1.apply;
        %% Evaluation
        train_evlt_cv1=apply(evaluation(ap),fextrain_cv1.features);
        test_evl_cv1=evaluation(train_evlt_cv1.model,train_evlt_cv1.reports);
        test_evl_cv1=apply(test_evl_cv1,fexttest_cv1.features);
        aux_results(ind)=test_evl_cv1.output;
        ind=ind+1;
    end
end
%% Ensemble Learning
import ensemble_learning_methods.*
[eval_ensemble_majority,outputs_majority]=apply(majority_voting,aux_results);
res_majority=outputs_majority.accuracy;
[eval_ensemble_mean,outputs_mean]=apply(mean_decision,aux_results);
res_mean=outputs_mean.accuracy;
toc