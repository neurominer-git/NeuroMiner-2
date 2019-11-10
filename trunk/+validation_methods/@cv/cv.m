classdef cv
       %Summary of CV:
    %   The CV class defines a double/singlecross validation process.
    %
    %   CV properties:
    %   parameters - ...
    %   reports - ...
    
    %   CV revision history:
    %   Date of creation: 9 September 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct; Description : Field 'number_of_folds' 
        %corresponds to a ND vector (positive integers) in wich the first 
        %position corresponds to number of folds in the outter loop and the
        %second position to the number of folds in the inner loop and so on
        %If you only wish N-M layers provide a N-M vector. Field 'mode'
        %corresponds to a string defining the functioning mode.Currently
        %available is only 'class'.
        
        reports; %FORMAT: report class object ; DESCRIPTION: Report class 
        %object that describes the status and incidences in the model 
        %estimation/application process
    end
    
    methods
        function obj = cv(parameter,reports)
            import validation_methods.*
            if (nargin==0)
                %number_of_folds :data_type 'integer' : dimension [1 1] : range from 1 to Inf :
                %value : {[]},no comment; example for a regular numeric parameter
                %without dependencies on the data.
                number_of_folds=parameters({[10 10]},'int16','[1 number_of_examples-1]','int16([2 number_of_examples])','Size variable');
                
                %mode :data_type 'char' : dimension [1 Inf] :
                %value : {0,1,2,3,4,5}, comment : 'Functioning Mode'; example for a regular character parameter
                %without dependencies on the data.
                mode=parameters({'class balanced'},'char',[1 Inf],{'class balanced','none'},'Functioning Mode');
                
                parameter=struct('number_of_folds',number_of_folds,'mode',mode);
                obj.parameters=parameter;
                obj.reports=report;
            elseif (nargin==1)
                obj=cv();
                if isstruct(parameter)
                    try reporta=parameters_checker(obj.parameters,parameter);
                    catch err
                        rethrow(err)
                    end
                    if reporta.flag
                        obj.parameters=parameter;
                    else
                        error('cv:Class_error',['cv:Class_error','Error using cv \n Invalid parameters provided. \n ' reporta.descriptor]);
                    end
                else
                    error('cv:Class_error','Error using cv \n First input must (parameters) be a structure.');
                end
            elseif (nargin==2)
                obj=cv(parameter);
                if ~(sum(isreport(reports))>0)
                    error('cv:Incompability_error','Error using cv \nThird (reports) must be a report class object.')
                else
                    obj.reports=reports;
                end
            else
                error('cv:Incompability_error','Invalid numer of arguments specified please read the cv class documentation.')
            end
        end
    end
end