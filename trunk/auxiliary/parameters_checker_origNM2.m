function reports=parameters_checker(parameter_ref,parameter,data)
%PARAMETERS_CHECKER  Checks the integrity of a parameter set.
%   REPORT =PARAMETERS_CHECKER(PARAMETER_REF,PARAMETER) checks if the
%   values enclosed in PARAMETER are valid accordingly to PARAMETER_REF.
%
%   In the case that PARAMETER_REF and PARAMETER are both parameter class
%   objects PARAMETERS_CHECKER verifies if the values in PARAMETER are in
%   agreement with PARAMETER_REF properties returning a REPORT class object
%   resuming the result of the verification process.
%
%   In the case that PARAMETER_REF and PARAMETER are structures with the
%   same fields and in which each field correspond to a parameter class
%   object PARAMETERS_CHECKER checks the if fields with the same names in
%   each one of the structures are in agreement and produces a REPORT class
%   object resuming the result of the verification process.
%
%   REPORT =PARAMETERS_CHECKER(PARAMETER_REF,PARAMETER,DATA) checks if the
%   values enclosed in PARAMETER are valid accordingly to PARAMETER_REF and
%   predifined characteristics of the DATA data_class object (more details
%   about the predifined data characteristics can be found in
%   DATA_REPORTER (DATA_CLASS method) documentation.
%

%   REPORT=PARAMETERS_CHECKER(PARAMETER_REF,PARAMETER,DATA)

%   PARAMETERS_CHECKER revision history:
%   Date of creation: 22 of October 2014 beta (Helena)
%   Creator: Carlos Cabral

if nargin==3||nargin==2
    %% Overture - Input checking
    if ~(isempty(parameter_ref)&&isempty(parameter))
        %parameter_ref
        if ~(isstruct(parameter_ref)||isparameters(parameter_ref)) %checking data type
            error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the input argument of type ''' class(parameter_ref) ''' (First input argument must be a parameter class object or a structure).']);
        else
            if isstruct(parameter_ref) % checking if the fields in the structure are parameter class objects
                aux_names_parameter_ref=fieldnames(parameter_ref);
                for i=1:numel(aux_names_parameter_ref)
                    aux_parameter_struct=parameter_ref.(aux_names_parameter_ref{i});
                    if ~isparameters(aux_parameter_struct)
                        error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the first input structure field ''' aux_names_parameter_ref{i} ''' of type ''' class(aux_parameter_struct) ''' (First input structure fields must be a parameter class object).']);
                    end
                end
            end
        end
        
        %parameter
        if ~(isstruct(parameter)||isparameters(parameter)) %checking data type
            error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the input argument of type ''' class(parameter) ''' (Second input argument must be a parameter class object or a structure).']);
        else
            if isstruct(parameter) % checking if the fields in the structure are parameter class objects
                aux_names_parameter=fieldnames(parameter);
                for i=1:numel(aux_names_parameter)
                    aux_parameter_struct=parameter.(aux_names_parameter{i});
                    if ~isparameters(aux_parameter_struct)
                        error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the first input structure field ''' aux_names_parameter{i} ''' of type ''' class(aux_parameter_struct) ''' (Second input structure fields must be a parameter class object).']);
                    end
                end
            end
        end
        if nargin==3
            if ~(isdata_class(data)) %checking data type
                error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the input argument of type ''' class(data) ''' (Third input argument must be a data_class class object).']);
            end
            rep=data.data_reporter;
            aux_rep=fieldnames(rep);
            for i=1:numel(aux_rep)
                eval([aux_rep{i} '=rep.(aux_rep{i});']);
            end
            data_flag=true;
        else
            data_flag=false;
        end
        %checking both parameter together
        if isstruct(parameter) %if the parameter variable is a structure parameter_ref also needs to be a structure and it must contain at least the same fields as parameter
            if isstruct(parameter_ref)
                for i=1:numel(aux_names_parameter)
                    flag_field=sum(strcmp(aux_names_parameter{i},aux_names_parameter_ref))==0;
                    if flag_field
                        error('parameters_cheker:Function_error',['Error in function '' PARAMETERS_CHECKER '' parameter ''' aux_names_parameter{i} ''' not found in the parameters references.']);
                    end
                end
            else
                error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the first input ''' class(parameter_ref) ''' when the second input is a structure (First input must be a structure).']);
            end
        end
        
        if isstruct(parameter_ref) %if the parameter_ref variable is a structure parameter also needs to be a structure
            if ~isstruct(parameter)
                error('parameters_cheker:Function_error',['Undefined function '' PARAMETERS_CHECKER '' for the second input ''' class(parameter) ''' when the first input is a structure (Second input must be a structure).']);
            end
        end
        
        %% Act
        %checking the integrity
        if isparameters(parameter_ref)
            %check if empty values are allowed.
            if isempty(parameter.value{1})
                if ~isempty(parameter_ref.comment)
                    aux_empty=strfind(parameter_ref.comment,'empty values allowed');
                    if ~isempty(aux_empty)
                        flag_data_type=true;
                        flag_dimension=true;
                        flag_range=true;
                    else
                        flag_data_type=false;
                        flag_dimension=false;
                        flag_range=false;
                    end
                    flag_empty=true;
                else
                    flag_empty=false;
                end
            else
                flag_empty=false;
            end
            if ~flag_empty
                %check the data_type
                flag_data_type=strcmp(parameter.data_type,parameter_ref.data_type);
                %dimension
                sz=parameter_ref.dimension;
                if ischar(sz)
                    if data_flag
                        eval(['sz=' parameter_ref.dimension ';']);
                        dimension_check=true;
                    else
                        dimension_check=false;
                    end
                else
                    dimension_check=true;
                end
                if dimension_check
                    aux_variable=sz==Inf;
                    sz=sz(aux_variable==0);
                    
                    aux_sz=parameter.dimension;
                    if isnumeric(aux_sz)
                        aux_sz=aux_sz(aux_variable==0);
                    end
                    %check if the size can be variable
                    flag_variable_sz=~isempty(strfind(parameter_ref.comment,'Size variable'));
                    if numel(aux_sz)==numel(sz)
                        if flag_variable_sz
                            if all(sz>=aux_sz)
                                flag_dimension=true;
                            else
                                flag_dimension=false;
                            end
                        else
                            if sum(abs(sz-aux_sz))==0
                                flag_dimension=true;
                            else
                                flag_dimension=false;
                            end
                        end
                    else
                        flag_dimension=false;
                    end
                else
                    flag_dimension=true;
                end
                %range
                flag_range=true;
                rng=parameter_ref.range;
                if isnumeric(parameter.value{1})
                    for i=1:numel(parameter.value)
                        if ischar(rng)
                            if data_flag
                                eval(['rng=' parameter_ref.range ';']);
                                range_check=true;
                            else
                                range_check=false;
                            end
                        else
                            range_check=true;
                        end
                        if range_check
                            if iscell(rng)
                                flag_aux=false(zeros(1,numel(rng)));
                                for j=1:numel(rng)
                                    try flag_aux(j)=isequal(parameter.value{i},rng{j});
                                    catch err
                                        rethrow(err)
                                    end
                                end
                                if ~any(flag_aux)
                                    flag_range=false;
                                end
                            else
                                aux_val=parameter.value{i}(:);
                                for j=1:numel(aux_val)
                                    if aux_val(j)>=rng(1)&&aux_val(j)<=rng(2)
                                        flag_range=true&&flag_range;
                                    else
                                        flag_range=false&&flag_range;
                                    end
                                end
                            end
                        else
                            flag_range=true;
                        end
                    end
                elseif ischar(parameter.value{1})
                    for i=1:numel(parameter.value)
                        aux_parameter=strcmp(parameter.value{i},parameter_ref.range);
                        if sum(aux_parameter)==0
                            flag_range=false;
                        end
                    end
                end
            end
        else
            % in the case that inputs are  structures each parameter will be
            % checked independently
            for i=1:numel(aux_names_parameter)
                if data_flag
                    try aux_sub_process=parameters_checker(parameter_ref.(aux_names_parameter{i}),parameter.(aux_names_parameter{i}),data);
                    catch err
                        rethrow(err);
                    end
                else
                    try aux_sub_process=parameters_checker(parameter_ref.(aux_names_parameter{i}),parameter.(aux_names_parameter{i}));
                    catch err
                        rethrow(err);
                    end
                end
                aux_sub_process.process=[aux_names_parameter{i}];
                if i==1
                    sub_process=aux_sub_process;
                else
                    sub_process=[sub_process;aux_sub_process];
                end
            end
        end
        
        %% Finale: Report writing
        if isparameters(parameter_ref)
            flag_final=[flag_data_type;flag_dimension;flag_range];
            descript_global={'data_type','dimensions','range'};
            aux_flag_final=find(~flag_final);
            if isempty(aux_flag_final)
                flag_final=true;
                descript='correct';
            else
                flag_final=false;
                descript=['Wrong ' descript_global{aux_flag_final(1)} ','];
                if numel(aux_flag_final)>1
                    for i=2:numel(aux_flag_final)
                        descript=[descript ' Wrong ' descript_global{i} ','];
                    end
                end
                descript=descript(1:end-1);
            end
            reports=report('parameters_check',report(),flag_final,descript);
        else
            reports=(report('parameters_check',sub_process,true));
            reports=flag_decider(reports);
        end
    else
       reports=report('parameters_check',report(),true,'no parameters to be checked'); 
    end
else
    error('parameters_cheker:Function_error','Invalid numer of arguments specified please read the PARAMETER_CHECKER function documentation.')
end
end