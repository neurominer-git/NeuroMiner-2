function rpt =io_compare(dict_ref,dict_real)
% IO_COMPARES (dictionary class)
%   report =IO_COMPARES(dictionary_ref,dictionary_real)
%
%   IO_COMPARES (dictionary class) function receives a reference dictionary
%   class and compares it with a data produced dictionary object (usually
%   produced based on real data) producing a report class object with the
%   information of the comparison.

%   See also DICTIONARY,REPORT.

%   IO_COMPARES (dictionary class) revision history:
%   Date of creation: 09 May 2014 beta (Helena)
%   Creator: Carlos Cabral


if nargin==2
    %% Overture: Input checking and mode definition
    if ~isdictionary(dict_ref)
        error(['Undefined function '' iocompares (dictionary class) '' for first input argument of type ''' class(dict_ref) ''' (First input argument must be a dictionary object).']);
    end
    if ~isdictionary(dict_real)
        error(['Undefined function '' iocompares (dictionary class) '' for second input argument of type ''' class(dict_real) ''' (Second input argument must be a dictionary object).']);
    end
    if isempty(dict_ref)
        error(['Undefined function '' iocompares (dictionary class) '' for first input argument of type ''' class(dict_ref) ''' (First input argument must be a dictionary object).']);
    end
    if isempty(dict_real)
        error(['Undefined function '' iocompares (dictionary class) '' for second input argument of type ''' class(dict_real) ''' (Second input argument must be a dictionary object).']);
    end
    %checking the status of the real data dictionary
    real_status=dict_real.status{1};
    if sum(strcmp(real_status,{'complete','ready'})>0)
       mode_i=3;
    elseif strcmp(real_status,'ready_input')
        mode_i=1;
    elseif strcmp(real_status,'ready_output')
        mode_i=2;
    else
       error(['Invalid status of the real data dictionary object '' ' real_status '']);
    end
    %checking the status of the reference dictionary
    ref_status=dict_ref.status{1};
    if sum(strcmp(ref_status,{'complete','ready'})>0)
        mode=mode_i;
    elseif strcmp(ref_status,'ready_input')
        if mode_i==1||mode_i==3
            mode=1;
        else
            error(['Status incompabitlity between the reference dictionary object (' ref_status ') and  the real data dictionary object (' real_status ')']);
        end
    elseif strcmp(ref_status,'ready_output')
        if mode_i==2||mode_i==3
            mode=2;
        else
            error(['Status incompabitlity between the reference dictionary object (' ref_status ') and  the real data dictionary object (' real_status ')']);
        end
    else
        error(['Invalid status of the reference dictionary object '' ' ref_status '']);
    end
%% Act: Checking 

    %dictionary property inputs
    rpt_input_method='input';
    rpt_input_flag=true;
    rpt_input_sub=report();
    rpt_input_descriptor=' ';
    if ~isempty(strfind(mode,'input'))
        aux_real_input=dict_real.input;
        if ~isempty(aux_real_input)
            aux_true_input=dict_ref.input;
            aux_obj=fieldnames(aux_real_input);
            if numel(aux_obj)~=numel(fieldnames(aux_true_input))
                rpt_input_flag=false;
                rpt_input_descriptor='The dimension of the dictionary class input property element is not consistent with the provided inputs.';
            else
                for j=1:numel(aux_obj)
                    aux_name=aux_obj{j};
                    if isfield(aux_true_input,aux_name)
                        if  ~strcmp(aux_real_input.(aux_name).data_type,aux_true_input.(aux_name).data_type)
                            rpt_input_flag=false;
                            rpt_input_descriptor=[rpt_input_descriptor '| The class of the input ' aux_name ' is not ' aux_true_input.(aux_name).data_type];
                        end
                        if strcmp(class(aux_real_input.(aux_name).dimension),class(aux_true_input.(aux_name).dimension));
                            if numel(aux_real_input.(aux_name).dimension)==aux_true_input.(aux_name).dimension
                                if isnumeric(aux_real_input.(aux_name).dimension)
                                    if sum(abs(aux_real_input.(aux_name).dimension-aux_true_input.(aux_name).dimension))~=0
                                        rpt_input_flag=false;
                                        rpt_input_descriptor=[rpt_input_descriptor '| The dimensions of the input ' aux_name ' ' num2str(obj_input.(aux_name)) ' are not in accordance with the dictionary class, ' num2str(aux_true_input.(aux_name).size)];
                                    end
                                elseif ischar(aux_real_input.(aux_name).dimension)
                                    if strcmp(aux_real_input.(aux_name).dimension,aux_true_input.(aux_name).dimension)==0
                                        rpt_input_flag=false;
                                        rpt_input_descriptor=[rpt_input_descriptor '| The dimensions of the input ' aux_name ' ' num2str(obj_input.(aux_name)) ' are not in accordance with the dictionary class, ' num2str(aux_true_input.(aux_name).size)];
                                    end
                                else
                                     rpt_input_flag=false;
                                     rpt_input_descriptor=[rpt_input_descriptor '| The data type of the dimensions of the input ' aux_name ' is not valid'];
                                end
                            else
                                rpt_input_descriptor=[rpt_input_descriptor '| The size of the dimensions of the input ' aux_name ' are not in accordance with the dictionary class'];
                            end
                        else
                            rpt_input_descriptor=[rpt_input_descriptor '| The data type of the dimensions of the input ' aux_name ' are not in accordance with the dictionary class'];
                        end
                        if isfield(aux_true_input.(aux_name).range)&&isfield(aux_real_input.(aux_name).range)
                            if ~strcmp(aux_true_input.(aux_name).range,'Not_applicable')
                                ref_range=aux_true_input.(aux_name).range;
                                real_range=aux_real_input.(aux_name).range;
                                %check the lower end of the range
                                flag_minimum=sum(real_range<ref_range(1))>0;
                                %check the upper end of the range
                                flag_maximum=sum(real_range>=ref_range(2))>0;
                                if flag_minimum||flag_maximum
                                    rpt_input_flag=false;
                                    rpt_input_descriptor=[rpt_input_descriptor '| The range of the input ' aux_name ' ' num2str(real_range) ' are not in accordance with the dictionary class, ' num2str(ref_range)];
                                end
                            end
                        end
                    else
                        rpt_input_flag=false;
                        rpt_input_descriptor=[rpt_input_descriptor '| The input field ' aux_name ' was not found in the dictionary class.'];
                    end
                end
            end
        else
            rpt_input_descriptor=[rpt_input_descriptor '| Input not defined'];
        end
    end
    rpt_input=report(rpt_input_method,rpt_input_sub,rpt_input_flag,rpt_input_descriptor);
    %dictionary property output
    rpt_output_method='output';
    rpt_output_flag=true;
    rpt_output_sub=report();
    rpt_output_descriptor=' ';
    if ~isempty(strfind(mode,'output'))
        aux_real_output=dict_real.output;
        if ~isempty(aux_real_output)
            %dictionary property output
            aux_true_output=dict_ref.output;
            aux_obj=fieldnames(aux_real_output);
            if numel(aux_obj)~=numel(fieldnames(aux_true_output))
                rpt_output_flag=false;
                rpt_output_descriptor='The dimension of the dictionary class output property element is not consistent with provided outputs.';
            else
                for j=1:numel(aux_obj)
                    aux_name=aux_obj{j};
                    if isfield(aux_true_output,aux_name)
                        if  ~strcmp(aux_real_output.(aux_name).data_type,aux_true_output.(aux_name).data_type)
                            rpt_output_flag=false;
                            rpt_output_descriptor=[rpt_output_descriptor '| The class of the output ' aux_name ' is not ' aux_true_output.(aux_name).data_type];
                        end
                        if strcmp(class(aux_real_output.(aux_name).dimension),class(aux_true_output.(aux_name).dimension));
                            if numel(aux_real_output.(aux_name).dimension)==aux_true_output.(aux_name).dimension
                                if isnumeric(aux_real_output.(aux_name).dimension)
                                    if sum(abs(aux_real_output.(aux_name).dimension-aux_true_output.(aux_name).dimension))~=0
                                        rpt_output_flag=false;
                                        rpt_output_descriptor=[rpt_output_descriptor '| The dimensions of the output ' aux_name ' ' num2str(obj_output.(aux_name)) ' are not in accordance with the dictionary class, ' num2str(aux_true_output.(aux_name).size)];
                                    end
                                elseif ischar(aux_real_output.(aux_name).dimension)
                                    if strcmp(aux_real_output.(aux_name).dimension,aux_true_output.(aux_name).dimension)==0
                                        rpt_output_flag=false;
                                        rpt_output_descriptor=[rpt_output_descriptor '| The dimensions of the input ' aux_name ' ' num2str(obj_output.(aux_name)) ' are not in accordance with the dictionary class, ' num2str(aux_true_output.(aux_name).size)];
                                    end
                                else
                                    rpt_output_flag=false;
                                    rpt_output_descriptor=[rpt_output_descriptor '| The data type of the dimensions of the output ' aux_name ' is not valid'];
                                end
                            else
                                rpt_output_descriptor=[rpt_output_descriptor '| The size of the dimensions of the output ' aux_name ' are not in accordance with the dictionary class'];
                            end
                        else
                            rpt_output_descriptor=[rpt_output_descriptor '| The data type of the dimensions of the output ' aux_name ' are not in accordance with the dictionary class'];
                        end
                        if isfield(aux_true_output.(aux_name).range)&&isfield(aux_real_output.(aux_name).range)
                            if ~strcmp(aux_true_output.(aux_name).range,'Not_applicable')
                                ref_range=aux_true_output.(aux_name).range;
                              real_range=aux_real_output.(aux_name).range;
                              %check the lower end of the range
                              flag_minimum=sum(real_range<ref_range(1))>0;
                              %check the upper end of the range
                              flag_maximum=sum(real_range>=ref_range(2))>0;
                              if flag_minimum||flag_maximum
                                 rpt_output_flag=false;
                                 rpt_output_descriptor=[rpt_output_descriptor '| The range of the output ' aux_name ' ' num2str(real_range) ' are not in accordance with the dictionary class, ' num2str(ref_range)];
                              end
                           end
                        end
                    else
                        rpt_output_flag=false;
                       rpt_output_descriptor=[rpt_output_descriptor '| The output field ' aux_name ' was not found in the dictionary class.'];
                    end
                end
            end
        else
            rpt_output_descriptor=[rpt_output_descriptor '| Output not defined'];
        end
    end
    rpt_output=report(rpt_output_method,rpt_output_sub,rpt_output_flag,rpt_output_descriptor);
    %% Finale: Assembles the Reports and decide the integrity flag value - 0 for false (data with consistency problems) 1 for true (data in agreement)
    rpt_method=dict_real.descriptor;
    rpt_sub=cat(1,rpt_input,rpt_output);
    rpt=report(rpt_method,rpt_sub);
    rpt=rpt.flag_decider;
else
   error('Not enough arguments for function '' io_compare (dictionary class). (less than 2 arguments provided)');
end