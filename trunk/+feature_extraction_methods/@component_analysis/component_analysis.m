classdef component_analysis
       %Summary of COMPONENT_ANALYSIS:
    %   The COMPONENT_ANALYSIS class controls the component_analysis superclass in NM2 framework.
    %
    %   COMPONENT_ANALYSIS properties:
    %   parameters - ...
    %   parameters_descriptor - ...
    %   model - ...
    %   reports - ...
    
    %   COMPONENT_ANALYSIS revision history:
    %   Date of creation: 10 of August 2016
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct; Description : Structure 
        parameter_descriptor;%FORMAT: string; DESCRIPTION: String describing the paramters used for the model
        model;  %FORMAT: struct; DESCRIPTION : Structure with the model generated by the component_analysis. In this case, a structure with 2 fields:transformation, component_weight and statistics.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class
        %object that describes the status and incidences in the model
        %estimation/application process
    end
    
    methods (Abstract)
       transformation_handler(obj,data,mode)
       %Estimate the weight map based on the object and the data.
    end
end