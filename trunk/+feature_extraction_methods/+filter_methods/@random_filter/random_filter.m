classdef random_filter < feature_extraction_methods.filter_method
       %Summary of RANDOM_FILTER:
    %   The RANDOM_FILTER class controls the random_filter
    %   process in NM2 framework. The random_filter class inherit
    %   belongs to the super class filter_method
    %
    %   RANDOM_FILTER properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   RANDOM_FILTER revision history:
    %   Date of creation: 19 of July 2016
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    methods
        function obj = random_filter(model,reports)
            import feature_extraction_methods.*
            import filter_methods.*
            if nargin==0
               obj.parameters=struct([]);
               % getting the paramters descriptor
               obj.parameter_descriptor='';
               obj.model.cut_off=cut_off;
               obj.model.weight_vector=[];
               obj.reports=report;
            else
                if (nargin==2)
                    obj=filter_methods.random_filter;
                    if ~isstruct(model)
                        error('random_filter:Incompability_error','Error using random_filter \nFirst input (model) must be a structure.')
                    else
                        if ~(isfield(model,'weight_vector')&&isfield(model,'cut_off'))
                            error('random_filter:Incompability_error','Error using random_filter \nFirst input (model) structure is invalid.')
                        end
                        if ~isa(model.cut_off,'cut_off')
                            error('random_filter:Incompability_error','Error using correlation_filter \nSecond input (model) structure is invalid, Invalid cut_off in model.')
                        end
                    end
                    %you might want to add some other guards here to insure
                    %that your model has the fields or the data type that
                    %you wish. 
                    obj.model=model;
                    if ~(sum(isreport(reports))>0)
                        error('random_filter:Incompability_error','Error using random_filter \nSecond (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('random_filter:Incompability_error','Invalid numer of arguments specified please read the random_filter class documentation.')
                end
            end
        end
    end
end