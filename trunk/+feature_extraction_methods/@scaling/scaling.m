classdef scaling
       %Summary of SCALING:
    %   The SCALING class controls the scaling process in NM2. This class
    %   is the first test of the incorporation of NM functions into the NM2
    %   framework.
    %
    %   SCALING properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   SCALING revision history:
    %   Date of creation: 21 of October 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    
    properties
        parameters; %FORMAT: struct; Description : Structure with 6 fields: low, high, scalefactor, minY, maxY, ZeroOne.
        % revertflag (logical) - Revert scaling 
        % overmatflag (logical) - Not across entire matrix / feature-wise
        % zerooutflag (logical) - Remove non-finite values
        % minY - (double) original minimim (1xN), N=number of features
        % maxY - (double) original maximum (1xN), N=number of features
        % ZeroOne (numeric) - 1 (default), 0 to 1 scaling
        %                - 2, -1 to 1 scaling
        model;  %FORMAT: struct; DESCRIPTION : One field structure with the model generated by the scaling. In this case, a structure with 6 fields:low, high, minY, maxY, scalefactor and ZeroOne.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class
        %object that describes the status and incidences in the model
        %estimation/application process
    end
    
    methods
        function obj = scaling(parameter,model,reports)
            import feature_extraction_methods.*
            if nargin==0
               %low :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {0},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               revertflag=parameters({false},'logical',int16([1 1]),[true false]);
               
               %low :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {0},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               AcMatFl=parameters({false},'logical',int16([1 1]),[true false]);
               
               %high :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {1},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               overmatflag=parameters({false},'logical',int16([1 1]),[true false]);
               
               %scalefactor :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {[]},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               zerooutflag=parameters({true},'logical',int16([1 1]),[true false]);
               
               %minY :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {[]},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               minY=parameters({[]},'double',[1 Inf],[-Inf Inf],'empty values allowed');
               
               %maxY :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {[]},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               maxY=parameters({[]},'double',[1 Inf],[-Inf Inf],'empty values allowed');
               
               %maxY :data_ZeroOne 'double' : dimension [1 1] : range from -Inf to Inf :
               %value : {[]},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               indnonfin=parameters({[]},'double',[1 Inf],[-Inf Inf],'empty values allowed');
               
               %ZeroOne :data_ZeroOne 'logical' : dimension [1 1] : range True or False :
               %value : {false},no comment; example for a regular logical parameter
               %without dependencies on the data.
               ZeroOne=parameters({1},'double',int16([1 1]),[1 2]);
               
               %assembling the parameters
               parameter=struct('revertflag',revertflag,'overmatflag',overmatflag,'zerooutflag',zerooutflag,'minY',minY,'maxY',maxY,'ZeroOne',ZeroOne,'AcMatFl',AcMatFl,'indnonfin',indnonfin);
               obj.parameters=parameter;
               obj.model=struct([]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=scaling();
                    if isstruct(parameter)
                        try rpt=parameters_checker(obj.parameters,parameter);
                        catch err
                            rethrow(err)
                        end
                        if rpt.flag
                            obj.parameters=parameter;
                        else
                            error('scaling:Class_error','Error using scaling \n Invalid parameters introduced.');
                        end
                    else
                        error('scaling:Class_error','Error using scaling \n First input must (parameters) be a structure.');
                    end
                elseif (nargin==2)
                    obj=scaling(parameter);
                    if ~isstruct(model)
                        error('scaling:Incompability_error','Error using scaling \nSecond input (model) must be a structure.')
                    else
                        aux_model=fieldnames(model);
                        if numel(aux_model)~=8
                           error('scaling:Incompability_error','Error using scaling \nSecond input (model) must have 7 fields.')
                        else
                           if ~(isfield(model,'revertflag')&&isfield(model,'overmatflag')&&isfield(model,'zerooutflag')&&isfield(model,'minY')&&isfield(model,'maxY')&&isfield(model,'ZeroOne')&&isfield(model,'AcMatFl')&&isfield(model,'indnonfin'))
                             error('scaling:Incompability_error','Error using scaling \nSecond input (model) structure is invalid.')
                           end
                        end
                    end
                    %you might want to add some other guards here to insure
                    %that your model has the fields or the data ZeroOne that
                    %you wish. 
                    obj.model=model;
                elseif (nargin==3)
                    obj=scaling(parameter,model);
                    if ~(sum(isreport(reports))>0)
                        error('scaling:Incompability_error','Error using scaling \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('scaling:Incompability_error','Invalid numer of arguments specified please read the scaling class documentation.')
                end
            end
        end
    end
end