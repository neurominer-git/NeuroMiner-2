classdef external_correlation_filter < feature_extraction_methods.filter_method
       %Summary of EXTERNAL_CORRELATION_FILTER:
    %   The EXTERNAL_CORRELATION_FILTER class controls the
    %   external_correlation_filter process in NM2 framework. The
    %   external_correlation_filter class inherit belongs to the super
    %   class filter_method.
    %
    %   EXTERNAL_CORRELATION_FILTER properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   EXTERNAL_CORRELATION_FILTER revision history:
    %   Date of creation: 22 of July 2016
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    methods
        function obj = external_correlation_filter(parameter,model,reports)
            import feature_extraction_methods.*
            import filter_methods.*
            if nargin==0
               %type :data_type 'char' : dimension [1 Inf] : range
               %{'Pearson','Spearman','Kendall'}:
               %value : {Pearson},no comment; example for a regular char
               %parameter
               %without dependencies on the data.
               type=parameters({'Pearson'},'char',int16([1 Inf]),{'Pearson','Spearman','Kendall'});
               
               %target :data_type 'char' : dimension [1 Inf] : range not applicable:
               %value : {label},no comment; example for a regular char parameter
               %without dependencies on the data.
               target=parameters({'target_values'},'char',int16([1 Inf]),{''},'range not applicable');
               
               %descriptor
               descriptor=parameters({'stability'},'char',int16([1 Inf]),{''},'range not applicable');
               
               %mode
               mode=parameters({'sum'},'char',int16([1 Inf]),{'sort_ascend','sort_descend','sum','diff','times','divide'});
               
               %assembling the parameters
               parameter=struct('type',type,'target',target,'descriptor',descriptor,'mode',mode);
               obj.parameters=parameters_eval(parameter);
               
               % getting the paramters descriptor
               obj.parameter_descriptor=['type-' type.value{1} '_target-' target.value{1} '_descriptor-' descriptor.value{1} '_mode-' mode.value{1}];
               obj.model.cut_off=cut_off;
               obj.model.weight_vector=[];
               obj.reports=report;
            else
                if (nargin==1)
                    obj=filter_methods.external_correlation_filter();
                    if isstruct(parameter)
                        try rpt=parameters_checker(obj.parameters,parameter);
                        catch err
                            rethrow(err)
                        end
                        obj.parameter_descriptor=['type-' parameter.type.value{1} '_target-' parameter.target.value{1} '_descriptor-' parameter.descriptor.value{1} '_mode-' parameter.mode.value{1}];
                        if rpt.flag
                            obj.parameters=parameter;
                        else
                            error('external_correlation_filter:Class_error','Error using external_correlation_filter \n Invalid parameters introduced.');
                        end
                    else
                        error('external_correlation_filter:Class_error','Error using external_correlation_filter \n First input must (parameters) be a structure.');
                    end
                elseif (nargin==3)
                    obj=filter_methods.external_correlation_filter(parameter);
                    if ~isstruct(model)
                        error('external_correlation_filter:Incompability_error','Error using external_correlation_filter \nSecond input (model) must be a structure.')
                    else
                        if ~(isfield(model,'weight_vector')&&isfield(model,'cut_off'))
                            error('external_correlation_filter:Incompability_error','Error using external_correlation_filter \nSecond input (model) structure is invalid.')
                        end
                        if ~isa(model.cut_off,'cut_off')
                            error('external_correlation_filter:Incompability_error','Error using correlation_filter \nSecond input (model) structure is invalid, Invalid cut_off in model.')
                        end
                    end
                    %you might want to add some other guards here to insure
                    %that your model has the fields or the data type that
                    %you wish. 
                    obj.model=model;
                    if ~(sum(isreport(reports))>0)
                        error('external_correlation_filter:Incompability_error','Error using external_correlation_filter \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('external_correlation_filter:Incompability_error','Invalid numer of arguments specified please read the external_correlation_filter class documentation.')
                end
            end
        end
    end
end