classdef dictionary
    %Summary of DICTIONARY:
    %   The DICTIONARY class stores the information of methods and classes
    %   relative to data types and incompatibilities in an effort to
    %   automatize the introduction of new methods. Also as each
    %   method/function should have a correspondent dictionary class
    %   instance it will serve as index. The dictionary class is mainly
    %   used to define proprerties that are case dependent. This class also
    %   provides the information for the integrity simulation.
    %
    %   DICTIONARY properties:
    %   method - ...
    %   input - ...
    %   output - ...
    %   warnings - ...
    %
    %   DICTIONARY history:
    %   Date of creation: 08 May 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        method;  %FORMAT: string; DESCRIPTION: If the dictionary corresponds a method this fields corresponds to a a string 'method' otherwise method should the class of the element to which it belongs to.
        input; %FORMAT: struct: DESCRIPTION: Each structure field corresponds to an input, in wich the field name is the input description. This field in its turn corresponds to a PARAMETERS class object.
        output; %FORMAT: struct: DESCRIPTION: Each structure field corresponds to an output, in wich the field name is the output description. This field in its turn corresponds to a PARAMETERS class.
        warnings; %FORMAT: struct ; DESCRIPTION: One structure for each warning with three fields, procedure, output and description.
    end
    
    methods
        function obj = dictionary(method,input,output,warnings)
            if (nargin>0)
                if (nargin==2)
                    if ischar(method)
                        obj.method = method;
                    else
                        error('Method propriety is invalid, please read DICTIONARY class documentation');
                    end
                    if isstruct(input)
                        aux_names=fieldnames(input);
                        for i=1:numel(aux_names)
                            aux_parameters=input.(aux_names{i});
                            if isparameters(aux_parameters)
                                if strcmp(aux_parameters.status,'invalid')
                                    error(['Input propriety is invalid (' aux_names ' is not a  valid parameters class object), please read DICTIONARY class documentation']);
                                end
                            else
                                error(['Input propriety is invalid (' aux_names ' is not a parameters class object), please read DICTIONARY class documentation']);
                            end
                        end
                        obj.input =input;
                    else
                        error('Input propriety is invalid, please read DICTIONARY class documentation');
                    end
                    obj.output=struct([]);
                    obj.warnings=struct([]);
                elseif (nargin==3)
                    obj=dictionary(methods,input);
                    if isstruct(output)
                        aux_names=fieldnames(output);
                        for i=1:numel(aux_names)
                            aux_parameters=output.(aux_names{i});
                            if isparameters(aux_parameters)
                                if strcmp(aux_parameters.status,'invalid')
                                    error(['Output propriety is invalid (' aux_names ' is not a  valid parameters class object), please read DICTIONARY class documentation']);
                                end
                            else
                                error(['Output propriety is invalid (' aux_names ' is not a parameters class object), please read DICTIONARY class documentation']);
                            end
                        end
                        obj.output =output;
                    else
                        error('Output propriety is invalid, please read DICTIONARY class documentation');
                    end
                    obj.output=output;
                    obj.warnings=struct([]);
                elseif (nargin==4)
                    obj=dictionary(method,input,output);
                    if isstruct(warnings)
                        for i=1:numel(warnings)
                            if numel(fieldnames(warnings))~=3||isfield(warnings,'procedure')||isfield(warnings,'output')||isfield(warnings,'description')
                                 error('Warnings propriety is invalid, please read DICTIONARY class documentation');
                            else
                                if isempty(warnings.procedures)||isempty(warnings.description)||isempty(warnings.output)
                                     error('Warnings propriety is invalid, please read DICTIONARY class documentation');
                                end
                            end
                        end
                    else
                        error('Warnings propriety is invalid, please read DICTIONARY class documentation');
                    end
                else
                    error('Invalid number of arguments please consult DICTIONARY class documentation');
                end
            end
        end
    end
end