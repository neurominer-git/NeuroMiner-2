classdef template_validation
       %Summary of TEMPLATE_VALIDATION:
    %   The TEMPLATE_VALIDATION class defines a validation process. 
    %   This template aims to define a set of functions
    %   that can easily be adapted to existing methods. In this header
    %   should be a description of the method, the more detailed the better
    %
    %   TEMPLATE_VALIDATION properties:
    %   parameters - ...
    %   reports - ...
    
    %   TEMPLATE_VALIDATION revision history:
    %   Date of creation: 9 September 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct; Description : Structure with the 
        %parameters to be used by the method implemented in 
        %TEMPLATE_VALIDATION.Each field in the parameters structure
        %is a parameter class object and corresponds to a single parameter,
        %hence should be named accordingly. If no parameters are provided
        %the the TEMPLATE_VALIDATION object will inherite the
        %built-in values predefined for this class. If parameters are
        %provided the program will assess if they are valid based on the
        %built-in parameters.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class 
        %object that describes the status and incidences in the model 
        %estimation/application process
    end
    
    methods
        function obj = template_validation (parameter,reports)
            import validation_methods.*
            if nargin==0
               %VERY IMPORTANT built-in parameters definition. Each
               %parameter is a parameter class object (for more information
               %read the parameter class documentation). In this example we
               %will use three parameters
               
               %parameter1 :value {0,1,2,3,4,5} : data_type 'integer' : dimension [1 1] : range from 0 to Inf :
               % comment no comment; example for a regular numeric parameter
               %without dependencies on the data.
               parameter1=parameters(num2cell(int16(0:10:100)),'integer',int16([1 1]),int16([0 100]));
               
               %parameter2 : value : {'abcd'} :data_type 'char' : dimension [1 4] : range {'abcd','efgh','ijkl','mnop'}:
               % comment 'Functioning Mode'; example for a regular character parameter
               %without dependencies on the data.
               parameter2=parameters({'abcd'},'char',[1 4],{'abcd','efgh','ijkl','mnop'},'Functioning Mode');
               
               %parameter3 :value : {0.01:0.1:1*number_examples} :
               %data_type 'double' : dimension [1 1] : range from 0 to Inf
               %: comment 'Percentage of components to estimate the model'
               %example for a regular numeric parameter
               %with dependencies on the data (number of examples), comment
               %: 'Percentage of components to estimate the model'.
               
               %You can find the implemented variables that characterize
               %the data dependencies in the file
               %cross_component_vars.m located in NM2 main directory.
               %When the range and the value depend on the data the
               %definition should be in a way that it can parsed by our
               %function. Please have a look at the example: ->
               parameter3=parameters('0.01:0.1:1*number_examples','double',[1 1],'1 number_examples','Percentage of components to estimate the model');
               %assembling the parameters
               parameters=struct('parameter1',parameter1,'parameter2',parameter2,'parameter3',parameter3);
               obj.parameters=parameters;
               obj.reports=report;
            else
                if (nargin==1)
                    obj=template_validation();
                    if isstruct(parameter)
                      try reporta=parameters_checker(obj.parameters,parameter);
                      catch err
                          rethrow(err)
                      end
                      if reporta.flag
                          obj.parameters=parameter;
                      else
                         error(['template_validation:Class_error','Error using template_validation \n Invalid parameters provided. \n ' reporta.descriptor]); 
                      end
                    else
                        error(['template_validation:Class_error','Error using template_validation \n First input must (parameters) be a structure.']);
                    end
                elseif (nargin==2)
                    obj=template_validation(parameter);
                    if ~(sum(isreport(reports))>0)
                        error('Validation:Incompability_error','Error using template_validation \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('Invalid numer of arguments specified please read the template_validation class documentation.')
                end
            end
        end
    end
end