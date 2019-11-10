classdef template_evaluation
       %Summary of TEMPLATE_EVALUATION:
    %   The TEMPLATE_EVALUATION class defines a single evaluation 
    %   process. This template aims to define a set of functions
    %   that can easily be adapted to existing methods. In this header
    %   should be a description of the method, the more detailed the better
    %
    %   TEMPLATE_EVALUATION properties:
    %   parameters - ...
    %   model - ...
    %   reports - ...
    
    %   TEMPLATE_EVALUATION revision history:
    %   Date of creation: 08 July 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct; Description : Structure with the 
        %parameters to be used by the method implemented in 
        %TEMPLATE_EVALUATION.Each field in the parameters structure
        %is a parameter class object and corresponds to a single parameter,
        %hence should be named accordingly. If no parameters are provided
        %the the TEMPLATE_EVALUATION object will inherite the
        %built-in values predefined for this class. If parameters are
        %provided the program will assess if they are valid based on the
        %built-in parameters.  
        model;  %FORMAT: struct; DESCRIPTION : Model estimated using the 
        %method defined in the TEMPLATE_EVALUATION class. If empty
        %the model will be estimated, else applied.
        reports; %FORMAT: report class object ; DESCRIPTION: Report class 
        %object that describes the status and incidences in the model 
        %estimation/application process
    end
    
    methods
        function obj =template_evaluation(paramet,model,reports)
            if nargin==0
               %VERY IMPORTANT built-in parameters definition. Each
               %parameter is a parameter class object (for more information
               %read the parameter class documentation). In this example we
               %will use three parameters
               
               %parameter1 :data_type 'integer' : dimension [1 1] : range from 0 to Inf :
               %value : {0,1,2,3,4,5},no comment; example for a regular numeric parameter
               %without dependencies on the data.
               parameter1=parameters('integer',int16([1 1]),int16([0 100]),num2cell(int16(0:10:100)));
               
               %parameter2 :data_type 'integer' : dimension [1 1] : range from 0 to Inf :
               %value : {0,1,2,3,4,5}, comment : 'Functioning Mode'; example for a regular character parameter
               %without dependencies on the data.
               parameter2=parameters('char',[1 4],{'abcd','efgh','ijkl','mnop'},{'abcd'},'Functioning Mode');
               
               %parameter3 :data_type 'double' : dimension [1 1] : range from 0 to Inf :
               %value : {0,1,2,3,4,5}; example for a regular numeric parameter
               %with dependencies on the data (number of examples), comment
               %: 'Percentage of components to estimate the model'.
               
               %You can find the implemented variables that characterize
               %the data dependencies in the file
               %cross_component_vars.m located in NM2 main directory.
               %When the range and the value depend on the data the
               %definition should be in a way that it can parsed by our
               %function. Please have a look at the example: ->
               parameter3=parameters('double',[1 1],{'1 number_examples'},{'0.01:0.1:1*number_examples'},'Percentage of examples used to estimate the model');
               %assembling the parameters
               paramet=struct('parameter1',parameter1,'parameter2',parameter2,'parameter3',parameter3);
               obj.parameters=paramet;
               obj.model=struct([]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=template_evaluation();
                    if isstruct(parameter)
                        try reporta=parameters_checker(obj.parameters,parameter);
                        catch err
                            rethrow(err)
                        end
                        if reporta.flag
                            obj.parameters=parameter;
                        else
                            error(['template_evaluation:Class_error','Error using template_evaluation \n Invalid parameters provided. \n ' reporta.descriptor]);
                        end
                    else
                        error(['template_evaluation:Class_error','Error using template_evaluation \n First input must (parameters) be a structure.']);
                    end
                elseif (nargin==2)
                    obj=template_evaluation(paramet);
                    if ~isstruct(model)
                        error('Feature_Extraction:Incompability_error','Error using template_evaluation \nSecond input (model) must be a structure.')
                    end
                    %you might want to add some other guards here to insure
                    %that your model has the fields or the data type that
                    %you wish. 
                    obj.model=model;
                elseif (nargin==3)
                    obj=template_evaluation(paramet,models);
                    if ~(sum(isreport(reports))>0)
                        error('Feature_Extraction:Incompability_error','Error using template_evaluation \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('template_evaluation:Invalid_number_of_arguments','Invalid numer of arguments specified please read the template_evaluation class documentation.')
                end
            end
        end
    end
end
