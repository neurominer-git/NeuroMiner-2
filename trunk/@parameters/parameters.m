classdef parameters
       %Summary of PARAMETERS:
    %   The PARAMETERS class defines a standatized way to represent,
    %   transfer and document parameters in NM2. 
    %   
    %   USAGE: 
    %   1 - PARAMETERS(VALUE,DATA_TYPE,DIMENSION,RANGE)
    %   2 - PARAMETERS(VALUE,DATA_TYPE,DIMENSION,RANGE,COMMENT)
    %   
    %   PARAMETERS properties:
    %   data_type - ...
    %   dimension - ...
    %   range - ...
    %   value - ...
    %   comment - ...
    
    %   PARAMETERS revision history:
    %   Date of creation: 10 July 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        value; %FORMAT: cell array; Description: Each position in the cell array contains a value that obbeys to the information in rest of the parameters property.
        data_type; % FORMAT: string; Description: Data type
        dimension; %FORMAT: numeric array or string that can evaluated; Description: Information about the dimension of the parameter. For fixed sizes a numeric array (if one of the dimensions is variable should be Inf). If an expression needs to evaluated then a string to that can evaluated.
        range;% FORMAT: numeric array, cell or string that can be evaluated; Description: Allowed values for the parameter. For numeric values numeric array and for strings cells. If an expression needs to evaluated then a string to that can evaluated.
        comment; %Format: String: Description: Optional property consisting of a string that describes the parameter. Usefull for the definition of built-in parameters and interface. If the sub string "empty values allowed " is present the program will allow for empty values for this parameter also if the sub string 'Size variable' is present the program will allow for different sizes within the provided dimension range.
    end
    
    methods
        function obj = parameters(values,datatype,dime,ranges,comment)
            if (nargin==1)
                if ~isempty(values)
                    if iscell(values)
                        if numel(values)>1
                            aux_data_type=cellfun(@class,values,'UniformOutput',false);
                            aux_data_type=unique(aux_data_type);
                            if numel(aux_data_type)>1
                                error('parameters:Class_error','Invalid values property \n elements in the cell array do not belong to the same data type');
                            end
                        end
                        obj=parameters(values,class(values{1}),size(values{1}),'Not applicable');
                    else
                        obj=parameters({values},class(values),size(values),'Not applicable');
                    end
                else
                    error('parameters:Class_error','Error using parameters class \n Invalid values property.');
                end
            elseif (nargin==4)
                if ~isempty(datatype)&&ischar(datatype)
                   obj.data_type=datatype;
                else
                    error(['parameters:Class_error','Error using parameters class \n Invalid data_type property.']);
                end 
                if ~isempty(dime)&&(isnumeric(dime)||iscell(dime)||ischar(dime))&&size(dime,1)==1
                   obj.dimension=dime; 
                else
                    error(['parameters:Class_error','Error using parameters \n Invalid dimension property.']); 
                end
                if ~isempty(ranges)&&(isnumeric(ranges)||islogical(ranges)||ischar(ranges)||iscell(ranges))&&size(ranges,1)==1
                   obj.range=ranges; 
                else
                    error(['parameters:Class_error','Error using parameters \n Invalid range property.']); 
                end
                if ~isempty(values)&&iscell(values)
                    obj.value=values;
                else
                    error(['parameters:Class_error','Error using parameters \n Invalid value property.']);
                end
            elseif (nargin==5)
                if isempty(comment)
                    obj=parameters(values,datatype,dime,ranges);
                elseif ischar(comment)
                    obj=parameters(values,datatype,dime,ranges);
                    obj.comment=comment;
                else
                    error(['parameters:Class_error','Error using parameters \n Invalid comment property.']);
                end
            else
                error('parameters:Class_error','Invalid numer of arguments specified please read the parameters class documentation.')
            end
        end
    end
end