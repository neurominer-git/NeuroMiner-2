classdef pca_class < feature_extraction_methods.component_analysis
       %Summary of PCA_CLASS:
    %   The PCA_CLASS class controls the principal component analysis
    %   process in NM2 framework. The PCA_CLASS class inherit
    %   belongs to the super class component analysis
    %
    %   PCA_CLASS properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   PCA_CLASS revision history:
    %   Date of creation: 11 August 2016
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    methods
        function obj = pca_class(parameter,model,reports)
            import feature_extraction_methods.*
            import component_analysis_methods.*
            if nargin==0
               %weights :data_type 'char' : dimension [1 Inf] : range
               %{'none','variance','external'}:
               %value : {none},no comment; example for a regular char
               %parameter
               %without dependencies on the data.
               weights=parameters({'none'},'char',int16([1 Inf]),{'none','variance','external'});
               
               parameter=struct('weights',weights);
               obj.parameters=parameters_eval(parameter);
               
               % getting the paramters descriptor
               obj.parameter_descriptor=['weights-' weights.value{1}];
               obj.model.transformation=[];
               obj.model.component_weight=[];
               obj.model.statistics=[];
               obj.model.bias=[];
               obj.reports=report;
            else
                if (nargin==1)
                    obj=filter_methods.pca_class();
                    if isstruct(parameter)
                        try rpt=parameters_checker(obj.parameters,parameter);
                        catch err
                            rethrow(err)
                        end
                        obj.parameter_descriptor=['weights-' parameter.weights.value{1}];
                        if rpt.flag
                            obj.parameters=parameter;
                        else
                            error('pca_class:Class_error','Error using pca_class \n Invalid parameters introduced.');
                        end
                    else
                        error('pca_class:Class_error','Error using pca_class \n First input must (parameters) be a structure.');
                    end
                elseif (nargin==3)
                    obj=filter_methods.pca_class(parameter);
                    if ~isstruct(model)
                        error('pca_class:Incompability_error','Error using pca_class \nSecond input (model) must be a structure.')
                    else
                        if ~(isfield(model,'transformation')&&isfield(model,'component_weight')&&isfield(model,'statistics')&&isfield(model,'bias'))
                            error('pca_class:Incompability_error','Error using pca_class \nSecond input (model) structure is invalid.')
                        end
                    end
                    obj.model=model;
                    if ~(sum(isreport(reports))>0)
                        error('pca_class:Incompability_error','Error using pca_class \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('pca_class:Incompability_error','Invalid numer of arguments specified please read the pca_class class documentation.')
                end
            end
        end
    end
end