classdef covariates_regression
       %Summary of COVARIATES_REGRESSION:
    %   The COVARIATES_REGRESSION class controls the covariates_regression process in NM2. This class
    %   is the first test of the incorporation of NM functions into the NM2
    %   framework.
    %
    %   COVARIATES_REGRESSION properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   COVARIATES_REGRESSION revision history:
    %   Date of creation: 25 July 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct; Description : Structure with 6 fields: low, high, scalefactor, minY, maxY, ZeroOne.
        % revertflag (logical) - Increase (=true) or attenuate (false), default (false). 
        % g (cell string) - Covariates to be extracted.
        % nointercept (logical) - Include an intercept in the model or not
        model;  %FORMAT: struct; DESCRIPTION : In this case, a structure with 2 fields:beta, subgroup.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class
        %object that describes the status and incidences in the model
        %estimation/application process
    end
    
    methods
        function obj = covariates_regression(parameter,model,reports)
            import feature_extraction_methods.*
            if nargin==0
               %low :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {0},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               revertflag=parameters({false},'logical',int16([1 1]),[true false]);
               
               %low :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {0},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               G=parameters({'age','sex'},'char',int16([1 Inf]),{''},'range not applicable');
               
               %high :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {1},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               nointercept=parameters({false},'logical',int16([1 1]),[true false]);
               
               
               %assembling the parameters
               parameter=struct('revertflag',revertflag,'G',G,'nointercept',nointercept);
               obj.parameters=parameter;
               obj.model=struct('beta',[],'subgroup',[]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=covariates_regression();
                    if isstruct(parameter)
                        try rpt=parameters_checker(obj.parameters,parameter);
                        catch err
                            rethrow(err)
                        end
                        if rpt.flag
                            obj.parameters=parameter;
                        else
                            error('covariates_regression:Class_error','Error using covariates_regression \n Invalid parameters introduced.');
                        end
                    else
                        error('covariates_regression:Class_error','Error using covariates_regression \n First input must (parameters) be a structure.');
                    end
                elseif (nargin==2)
                    obj=covariates_regression(parameter);
                    if ~isstruct(model)
                        error('covariates_regression:Incompability_error','Error using covariates_regression \nSecond input (model) must be a structure.')
                    else
                       % aux_model=fieldnames(model);
%                         if numel(aux_model)~=2
%                            error('covariates_regression:Incompability_error','Error using covariates_regression \nSecond input (model) must have 7 fields.')
%                         else
                           if ~(isfield(model,'beta')&&isfield(model,'subgroup'))
                             error('covariates_regression:Incompability_error','Error using covariates_regression \nSecond input (model) structure is invalid.')
                           end
%                         end
                    end
                    %you might want to add some other guards here to insure
                    %that your model has the fields or the data ZeroOne that
                    %you wish. 
                    obj.model=model;
                elseif (nargin==3)
                    obj=covariates_regression(parameter,model);
                    if ~(sum(isreport(reports))>0)
                        error('covariates_regression:Incompability_error','Error using covariates_regression \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('covariates_regression:Incompability_error','Invalid numer of arguments specified please read the covariates_regression class documentation.')
                end
            end
        end
    end
end