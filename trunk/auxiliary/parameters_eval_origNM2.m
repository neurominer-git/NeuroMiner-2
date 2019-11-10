function parameter_ref=parameters_eval(parameter_ref,data)
%PARAMETERS_EVAL Calculates parameters that depend on the data.
%   PARAMETER_REF=PARAMETERS_EVAL(PARAMETER,DATA) defines the
%   parameters in the PARAMETERS class object or structure of PARAMETERS
%   class objects PARAMETERS_REF that can be data dependent based on the
%   DATA_CLASS object data predifined characteristics (more details about
%   the predifined data characteristics can be found in DATA_REPORTER
%   (DATA_CLASS method) documentation.
%
%   Usage:
%   1 - PARAMETER_REF=PARAMETERS_EVAL(PARAMETER) - PARAMETERS are not data
%   dependent.
%   2 - PARAMETER_REF=PARAMETERS_EVAL(PARAMETER,DATA) - PARAMETERS are data
%   dependent.

%   PARAMETER=PARAMETERS_EVAL(PARAMETER,DATA)
%   See also data_class, data_reporter, parameters, parameters_checker

%   PARAMETERS_EVAL revision history:
%   Date of creation: 26 of November 2014 beta (Helena)
%   Creator: Carlos Cabral

if nargin==2||nargin==1
    %% Overture - Input checking
    if ~isempty(parameter_ref)
        %parameter_ref
        if ~(isstruct(parameter_ref)||isparameters(parameter_ref)) %checking data type
            error('parameters_eval:Function_error',['Undefined function '' PARAMETERS_EVAL '' for the input argument of type ''' class(parameter_ref) ''' (First input argument must be a parameter class object or a structure).']);
        else
            if isstruct(parameter_ref) % checking if the fields in the structure are parameter class objects
                aux_names_parameter_ref=fieldnames(parameter_ref);
                for i=1:numel(aux_names_parameter_ref)
                    aux_parameter_struct=parameter_ref.(aux_names_parameter_ref{i});
                    if ~isparameters(aux_parameter_struct)
                        error('parameters_eval:Function_error',['Undefined function '' PARAMETERS_EVAL '' for the first input structure field ''' aux_names_parameter_ref{i} ''' of type ''' class(aux_parameter_struct) ''' (First input structure fields must be a parameter class object).']);
                    end
                end
            end
        end
        data_flag=false;
        if nargin==2
            if ~(isdata_class(data)) %checking data type
                error('parameters_eval:Function_error',['Undefined function '' PARAMETERS_EVAL '' for the input argument of type ''' class(data) ''' (Third input argument must be a data_class class object).']);
            end
            if ~(numel(data)==1) %checking number of elements
                error('parameters_eval:Function_error','Undefined function '' PARAMETERS_EVAL '' for DATA_CLASS array '' (Third input argument must be a single data_class class object).');
            end
            rep=data.data_reporter;
            aux_rep=fieldnames(rep);
            for i=1:numel(aux_rep)
                eval([aux_rep{i} '=rep.(aux_rep{i});']);
            end
            data_flag=true;
        end
        %% Act
        %checking the integrity
        if isparameters(parameter_ref)
            %check values
            if ischar(parameter_ref.value)
                try eval(['parameter_ref.value=' parameter_ref.value ';'])
                catch err
                    rethrow(err);
                end
            end
            %check dimensions
            if ischar(parameter_ref.dimension)
                try eval(['parameter_ref.dimension=' parameter_ref.dimension ';'])
                catch err
                    rethrow(err);
                end
            end
            %check range
            if ischar(parameter_ref.range)
                try eval(['parameter_ref.range=' parameter_ref.range ';'])
                catch err
                    rethrow(err);
                end
            end
        else
            % in the case that inputs are  structures each parameter will be
            % checked independently
            for i=1:numel(aux_names_parameter_ref)
                if data_flag
                    try parameter_ref.(aux_names_parameter_ref{i})=parameters_eval(parameter_ref.(aux_names_parameter_ref{i}),data);
                    catch err
                        rethrow(err);
                    end
                else
                    try parameter_ref.(aux_names_parameter_ref{i})=parameters_eval(parameter_ref.(aux_names_parameter_ref{i}));
                    catch err
                        rethrow(err);
                    end
                end
            end
        end
        %% Finale: No finale the sky is the limit
    end
else
    error('parameters_eval:Function_error','Invalid numer of arguments specified (1 or 2 expected) please read the PARAMETER_EVAL function documentation.')
end
end