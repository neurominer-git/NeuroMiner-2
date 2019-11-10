function res =status(r)
%STATUS (PARAMETERS class) determines the status of a
%PARAMETERS (PARAM) object or array of PARAM objects.
% RES=STATUS (R) returns a cell array with the same number of elements and in
%   the same order as r. Each position in the cell array contains a string
%   describing the status of the correspendent PARAMETERS class object.
%   Possible values are:
%
%       1 - 'empty' - for empty PARAMETERS class objects.
%       2 - 'hypothetical' - for properties dimension and range depending
%       on variables (strings to be evaluated). 
%       3 - 'usage_ready' - for PARAMETERS classs objects that are ready to
%       be used in a single model construction.
%       4 - 'multiple_values' - multiple values detected, meaning that
%       model selection is needed. 
%       5 - 'invalid' - any other case.


%   RES=STATUS (R)
%   See also PARAMETERS, ISPARAMETERS

%   STATUS (PARAMETERS class)  revision history:
%   Date of creation: 10 July 2014 beta (Helena)
%   Creator: Carlos Cabral
res=cell(1,numel(r));
for i=1:numel(r)
    aux=r(i);
    %% Overture: Checking if the feature_extraction object/array is empty
    %defining the numeric data types
    numeric_types={'single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'};
    if sum(isempty(aux))>0
        aux_name='empty';
    else
    %% Act: Reading the status of the models and the processes reported
        aux_values=aux.value;
        aux_dimension=aux.dimension;
        aux_range=aux.range;
        aux_data_type=aux.data_type;
        flag_dimension=false;
        % checking the hypothetical hyphotesis
        aux_hypo=ischar(aux_range)||ischar(aux_dimension);
        %% Finale: Deciding the status
        if aux_hypo
            aux_name='hypothetical';
        else
            if strcmp(aux_data_type,'char')
                if iscell(aux_range)
                    aux_type=true;
                    aux_size=true;
                    aux_allowed=true;
                    % in the case of the strings having variable lengths
                    if iscell(aux_dimension)
                       flag_dimension=true;
                       aux_1=strcmp(aux_dimension,'variable');
                       aux_dimension_prunned=zeros(1,numel(aux_dimension));
                       for j=1:numel(aux_1)
                           if ~aux_1
                              aux_dimension_prunned(j)=aux_dimension{j};
                           end
                       end
                       aux_dimension_prunned(aux_1)=[];
                       aux_dimension=cell2mat(aux_dimension_prunned);
                    end
                    
                    for j=1:numel(aux_values)
                        %data_type verification
                        aux_type=aux_type&&isa(aux_values{j},aux_data_type);
                        %dimension verification
                        aux_value_size=size(aux_values{j});
                        if flag_dimension
                            aux_value_size(aux_1)=[];
                        end
                        if numel(aux_value_size)==numel(aux_dimension)
                            aux_size=aux_size&&(sum(abs(aux_value_size-aux_dimension))==0);
                        else
                            aux_size=aux_size&&false;
                        end
                        %range verification
                        aux_allowed=aux_allowed&&(sum(strcmp(aux_values{j},aux_range))>0);
                    end
                    if aux_type&&aux_size&&aux_allowed;
                        if j==1
                            aux_name='usage_ready';
                        elseif j>1
                            aux_name='multiple_values';
                        else
                            aux_name='invalid';
                        end
                    else
                        aux_name='invalid';
                    end
                else
                    aux_name='invalid';
                end
            elseif sum(strcmp(aux_data_type,numeric_types))>0
                if isnumeric(aux_dimension)||isnumeric(aux_range)
                    aux_type=true;
                    aux_size=true;
                    aux_allowed=true;
                    for j=1:numel(aux_values)
                        %data_type verification
                        aux_type=aux_type&&isa(aux_values{j},aux_data_type);
                        %dimension verification
                        aux_value_size=size(aux_values{j});
                        if numel(aux_value_size)==numel(aux_dimension)
                            aux_size=aux_size&&(sum(abs(aux_value_size-aux_dimension))==0);
                        else
                            aux_size=aux_size&&false;
                        end
                        %range verification
                        aux_value_vector=aux_values{j}(:);
                        %low range
                        great_val=unique(aux_value_vector>aux_range(1));
                        great_val=numel(great_val)==1&&sum(great_val)>0;
                        %high range
                        lower_val=unique(aux_value_vector<aux_range(2));
                        lower_val=numel(lower_val)==1&&sum(lower_val)>0;
                        aux_allowed=aux_allowed&&lower_val&&great_val;
                    end
                    if aux_type&&aux_size&&aux_allowed;
                        if j==1
                            aux_name='usage_ready';
                        elseif j>1
                            aux_name='multiple_values';
                        else
                            aux_name='invalid';
                        end
                    else
                        aux_name='invalid';
                    end
                else
                    aux_name='invalid';
                end
            else
                aux_name='invalid';
            end
        end
    end
    res{i}=aux_name;
end
end