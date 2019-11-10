classdef mean_decision
       %Summary of MEAN_DECISION:
    %   The MEAN_DECISION class defines the MEAN_DECISION ensemble
    %   learning method. Consisting in averagin the decision values (soft_labels) of 
    %   every classifier in the ensemble and decide the final class by 
    %   taking the class with the greatest support. This method is one of 
    %   the simplest. There are no parameters to be tuned or model to estimated.
    %
    %   MEAN_DECISION properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   MEAN_DECISION revision history:
    %   Date of creation: 29 October 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct; Description : emtpy structure as there are no parameters to be estimated. 
        model;  %FORMAT: struct; DESCRIPTION : empty structure as there is no model to be estimated. 
        reports; %FORMAT: report class object ; DESCRIPTION: Report class 
        %object that describes the status and incidences in the model 
        %application process
    end
    
    methods
        function obj =mean_decision(paramet,model,reports)
            import ensemble_learning_methods.*
            if nargin==0
               obj.parameters=struct([]);
               obj.model=struct([]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=mean_decision();
                    if isstruct(paramet)&&isempty(paramet)
                        
                        obj.parameters=paramet;
                        
                    else
                        error(['mean_decision:Class_error','Error using mean_decision \n First input must (parameters) be an empty structure.']);
                    end
                elseif (nargin==2)
                    obj=mean_decision(paramet);
                    if isstruct(model)&&isempty(model)
                        obj.model=model;
                    else
                        error('mean_decision:Incompability_error','Error using mean_decision \nSecond input (model) must be an empty structure.')
                    end
                elseif (nargin==3)
                    obj=mean_decision(paramet,model);
                    if ~isreport(reports)
                        error('mean_decision:Incompability_error','Error using mean_decision \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('mean_decision:Invalid_number_of_arguments','Invalid number of arguments specified please read the mean_decision class documentation.')
                end
            end
        end
    end
end
