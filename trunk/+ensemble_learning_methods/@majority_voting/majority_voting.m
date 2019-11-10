classdef majority_voting
       %Summary of MAJORITY_VOTING:
    %   The MAJORITY_VOTING class defines the MAJORITY_VOTING ensemble
    %   learning method. That consists in taking the full  This method is one of the simplest. There are no
    %   parameters to be tuned or model to estimated.
    %
    %   MAJORITY_VOTING properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   MAJORITY_VOTING revision history:
    %   Date of creation: 08 July 2014
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
        function obj =majority_voting(paramet,model,reports)
            import ensemble_learning_methods.*
            if nargin==0
               obj.parameters=struct([]);
               obj.model=struct([]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=majority_voting();
                    if isstruct(paramet)&&isempty(paramet)
                        
                        obj.parameters=paramet;
                        
                    else
                        error(['majority_voting:Class_error','Error using majority_voting \n First input (parameters) must be an empty structure.']);
                    end
                elseif (nargin==2)
                    obj=majority_voting(paramet);
                    if isstruct(model)&&isempty(model)
                        obj.model=model;
                    else
                        error('majority_voting:Incompability_error','Error using majority_voting \nSecond input (model) must be an empty structure.')
                    end
                elseif (nargin==3)
                    obj=majority_voting(paramet,model);
                    if ~isreport(reports)
                        error('majority_voting:Incompability_error','Error using majority_voting \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('majority_voting:Invalid_number_of_arguments','Invalid number of arguments specified please read the majority_voting class documentation.')
                end
            end
        end
    end
end
