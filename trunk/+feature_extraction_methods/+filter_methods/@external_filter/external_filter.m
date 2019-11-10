classdef external_filter < feature_extraction_methods.filter_method
       %Summary of EXTERNAL_FILTER:
    %   The EXTERNAL_FILTER class controls the external_filter
    %   process in NM2 framework. The external_filter class inherit
    %   belongs to the super class filter_method
    %
    %   EXTERNAL_FILTER properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   EXTERNAL_FILTER revision history:
    %   Date of creation: 19 of July 2016
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    methods
        function obj = external_filter(parameter,model,reports)
            import feature_extraction_methods.*
            import filter_methods.*
            if nargin==0
               %type :data_type 'char' : dimension [1 Inf] : range
               %{'Pearson','Spearman','Kendall'}:
               %value : {Pearson},no comment; example for a regular char
               %parameter
               %without dependencies on the data.
               descriptor=parameters({'stability'},'char',int16([1 Inf]),{''},'range not applicable');
               
               %assembling the parameters
               parameter=struct('descriptor',descriptor);
               obj.parameters=parameters_eval(parameter);
               
               % getting the paramters descriptor
               obj.parameter_descriptor=parameter.descriptor.value{1};
               obj.model.cut_off=cut_off;
               obj.model.weight_vector=[];
               obj.reports=report;
            else
                if (nargin==1)
                    obj=filter_methods.external_filter();
                    if isstruct(parameter)
                        try rpt=parameters_checker(obj.parameters,parameter);
                        catch err
                            rethrow(err)
                        end
                        obj.parameter_descriptor=parameter.descriptor.value{1};
                        if rpt.flag
                            obj.parameters=parameter;
                        else
                            error('external_filter:Class_error','Error using external_filter \n Invalid parameters introduced.');
                        end
                    else
                        error('external_filter:Class_error','Error using external_filter \n First input must (parameters) be a structure.');
                    end
                elseif (nargin==3)
                    obj=filter_methods.external_filter(parameter);
                    if ~isstruct(model)
                        error('external_filter:Incompability_error','Error using external_filter \nSecond input (model) must be a structure.')
                    else
                        if ~(isfield(model,'weight_vector')&&isfield(model,'cut_off'))
                            error('external_filter:Incompability_error','Error using external_filter \nSecond input (model) structure is invalid.')
                        end
                        if ~isa(model.cut_off,'cut_off')
                            error('external_filter:Incompability_error','Error using correlation_filter \nSecond input (model) structure is invalid, Invalid cut_off in model.')
                        end
                    end
                    %you might want to add some other guards here to insure
                    %that your model has the fields or the data type that
                    %you wish. 
                    obj.model=model;
                    if ~(sum(isreport(reports))>0)
                        error('external_filter:Incompability_error','Error using external_filter \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('external_filter:Incompability_error','Invalid numer of arguments specified please read the external_filter class documentation.')
                end
            end
        end
    end
end