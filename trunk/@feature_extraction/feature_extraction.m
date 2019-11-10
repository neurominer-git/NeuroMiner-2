classdef feature_extraction
    %Summary of FEATURE_EXTRACTION:
    %   The FEATURE_EXTRACTION class defines a feature selection process
    %   composed by none, one or more processes defined by in the models
    %   property.
    %
    %   FEATURE_EXTRACTION properties:
    %   models - ...
    %   features - ...
    %   reports - ...
    
    %   FEATURE_EXTRACTION revision history:
    %   Date of creation: 20 February 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        models;  %FORMAT: struct; DESCRIPTION ; Model estimated using the method or methods defined in the methods proprieties. If empty the model will be estimated, else applied.
        features; %FORMAT: data_class object ; DESCRIPTION: Data transformed by the method(s) defined in method properties.
        reports; %FORMAT: array of report class objects ; DESCRIPTION: Set of array class objects one for each model that describe the models already applied to the data and the status and incidences in the model application
    end
    
    methods
        function obj = feature_extraction (models,features,reports)
            if (nargin>0)
                if (nargin==1)
                    obj=feature_extraction();
                    if isstruct(models)
%                         if sum(is_package(models,'feature_extraction_methods','classes'))==numel(models)
                            obj.models=models;
%                         else
%                             error('Feature_Extraction:Class_error','Error using feature_extraction \nFirst input must be a structure of feature_extraction_methods.')
%                         end
                    else
                        error('Feature_Extraction:Class_error','Error using feature_extraction \nFirst input must be a structure.')
                    end
                elseif (nargin==2)
                    obj=feature_extraction(models);
                    if numel(features)==1
                        if isdata_class(features)||isdictionary(features)
                            obj.features=features;
                        else
                            error('Feature_Extraction:Class_error','Error using feature_extraction \n Second input must be a data_class or dictionary object.')
                        end
                    else
                        error('Feature_Extraction:Class_error','Error using feature_extraction \n Second input must be a single data_class or dictionary object.')
                    end
                elseif (nargin==3)
                    obj=feature_extraction(models,features);
                    if isreport(reports)
                        %if numel(fieldnames(models))<=numel(reports)
                            obj.reports=reports;
                        %else
                        %    error('Feature_Extraction:Incompability_error','Error using feature_extraction \nFirst and third element dimensions are not consistent.')
                        %end
                    else
                        error('Feature_Extraction:Incompability_error','Error using feature_extraction \nThird input must be a report object or array.')
                    end
                else
                    error('Feature_Extraction:class_error','Invalid numer of arguments specified please read the feature_extraction class documentation.')
                end
            end
        end
    end
end