classdef ensemble_learning
    %Summary of ENSEMBLE_LEARNING:
    %   The ENSEMBLE_LEARNING class defines a ensemble_learning process
    %   defined by the method specified in the MODEL
    %   property. The results of the ensemble is enclosed in the
    %   OUTPUTS property. Finally the incidences of the processing are
    %   registered in the REPORTS property.
    %
    %   ENSEMBLE_LEARNING properties:
    %   model - ...
    %   output - ...
    %   reports - ...
    
    %   ENSEMBLE_LEARNING revision history:
    %   Date of creation: 28 October 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        model;  %FORMAT: object in the ensemble_learning_methods package ; DESCRIPTION ; Model estimated/applied using the method impletmented in the an object in the ensemble_learning_methods package.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class objects that describe the models already applied to the data and the status and incidences in the model application/estimation
        output; %FORMAT: results classs objects ; DESCRIPTION: Results obtained for the application of the ensemble model implemented in the model property.
    end
    
    methods
        function obj = ensemble_learning (models,reports,outputs)
            if (nargin>0)
                if nargin==1
                    if is_package(models,'ensemble_learning_methods','classes')
                        obj.model=models;
                    else
                        error('Ensemble_Learning:Class_error','Error using ensemble_learning \nFirst input must be a class of ensemble_learning_methods.')
                    end
                    obj.reports=report;
                elseif (nargin==2)
                    obj=ensemble_learning();
                    if is_package(models,'ensemble_learning_methods','classes')
                        obj.model=models;
                    else
                        error('Ensemble_Learning:Class_error','Error using ensemble_learning \nFirst input must be a class of ensemble_learning_methods.')
                    end
                    if isreport(reports) 
                       obj.reports=reports;
                    else
                        error('Ensemble_Learning:Class_error','Error using ensemble_learning \nSecond input must be a report class object.')
                    end
                elseif (nargin==3)
                    obj=ensemble_learning(models,reports);
                    if isresults(outputs)
                        obj.output=outputs;
                    else
                        error('Ensemble_Learning:Class_error','Error using ensemble_learning \n Third input must be a results object.')
                    end
                else
                    error('Ensemble_Learning:Class_error','Invalid numer of arguments specified please read the ensemble_learning class documentation.')
                end
            end
        end
    end
end