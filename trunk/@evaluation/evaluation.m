classdef evaluation
    %Summary of EVALUATION:
    %   The EVALUATION class defines a evaluation process (classification
    %   or regression) defined by the method specified in the models
    %   property. The results of the classification are enclosed in the
    %   outputs property. Finally the incidences of the processing are
    %   registered in the reports property.
    %
    %   EVALUATION properties:
    %   model - ...
    %   outputs - ...
    %   reports - ...
    
    %   EVALUATION revision history:
    %   Date of creation: 04 July 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        model;  %FORMAT: object in the evaluation_methods package ; DESCRIPTION ; Model estimated/applied using the method impletmented in the an object in the evaluation_methods package.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class objects that describe the models already applied to the data and the status and incidences in the model application/estimation
        output; %FORMAT: results classs object ; DESCRIPTION: Results obtained for the application of the evaluation method enclosed in model.
    end
    
    methods
        function obj = evaluation (models,reports,outputs)
            if (nargin>0)
                if (nargin==1)
                    obj=evaluation();
                    if ~isempty(strfind(class(models),'evaluation_methods'))
                        obj.model=models;
                    else
                        error('Evaluation:Class_error','Error using evaluation \nFirst input must be a class of evaluation_methods.')
                    end
                    obj.reports=report;
                elseif (nargin==2)
                    obj=evaluation(models);
                    if isreport(reports)
                        obj.reports=reports;
                    else
                        error('Evaluation:Class_error','Error using evaluation \nSecond input must be a report class object.')
                    end
                elseif (nargin==3)
                    obj=evaluation(models,reports);
                    if isresults(outputs)
                        obj.output=outputs;
                    else
                        error('Evaluation:Class_error','Error using evaluation \n Third input must be a classification_result object.')
                    end
                else
                    error('Evaluation:Class_error','Invalid numer of arguments specified please read the evaluation class documentation.')
                end
            end
        end
    end
end