classdef validation
    %Summary of VALIDATION:
    %   The VALIDATION class controls the structure and information of the
    %   validation step in the NM2 machine learning pipeline. 
    %
    %   VALIDATION properties:
    %   method - ...
    %   design - ...
    %   reports - ...
    %
    %   VALIDATION history:
    %   Date of creation: 14 May 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        method;  %FORMAT: object in the validation_methods package; DESCRIPTION: Method to be used in the production of the validation design.
        reports; %FORMAT: reports classs object ; DESCRIPTION: Results obtained for the application of the validation method enclosed in method.
        design;  %FORMAT: array of validation_design object ; DESCRIPTION: Design of the validation scheme to be used
    end
    methods
        function obj = validation (methods,reports,designs)
            if (nargin>0)
                if (nargin==1)
                    obj=validation();
                    if is_package(class(methods),'validation_methods','classes')
                        obj.method=methods;
                    else
                        error('Validation:Class_error','Error using validation \nFirst input must be a class of validation_methods.')
                    end
                    obj.reports=report();
                    obj.design=validation_design();
                elseif (nargin==2)
                    obj=validation(methods);
                    if isreport(reports)
                        if numel(reports)==1
                            obj.reports=reports;
                        else
                            error('Validation:Class_error','Error using validation \n Property report must be a single report class object.')
                        end
                    else
                        error('Validation:Class_error','Error using validation \nSecond input must be a report class object.')
                    end
                    obj.design=validation_design();
                elseif (nargin==3)
                    obj=validation(methods,reports);
                    if isvalidation_design(designs)
                        obj.design=designs;
                    else
                        error('Validation:Class_error','Error using validation \n Third input must be validation_design class object.')
                    end
                else
                    error('Validation:Class_error','Invalid numer of arguments specified please read the validation class documentation.')
                end
            end
        end
    end
end