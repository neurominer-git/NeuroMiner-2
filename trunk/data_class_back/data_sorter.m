function data=data_sorter(data,indic,mode)
% DATA_SORTER (DATA_CLASS class) selects a data subset from a data classs
% object
%
%   DATA_OUTPUT=DATA_SORTER (DATA_INPUT,INDIC) Retrieves a reordered
%   version of DATA_INPUT according to INDIC these indices correspond to
%   the new examples' order in the DATA_OUTPUT. The reordering can work as
%   a selection since the dimensions of DATA_OUTPUT and DATA_INPUT can
%   differ. 
%
%   DATA_INPUT is an array of data_class objects with the original data
%   that you wish to reorder.
%
%   INDIC array of doubles that defines the order of DATA_OUTPUT based on
%   DATA_INPUT positions.
%
%   DATA_OUTPUT is an array of data_class objects that contains, in the
%   respective positions, the reordered sets of DATA_INPUT defined by INDIC.
%
%   DATA_OUTPUT=DATA_SORTER (DATA_INPUT,INDIC.MODE) Retrieves the reordered
%   version of DATA_INPUT object according to the provided INDIC and
%   MODE. For "instances" mode, INDIC correspond to reordering of  examples that 
%   should be present in the DATA_OUTPUT, while for "features"
%   mode, INDIC correspond to the features order that should be present in
%   DATA_OUTPUT
%
%   MODE is an string defining the selection mode, two values are possible:
%   "instances" (default) and "features". 
%   For "instance" mode:
%      INDIC array of int16 (position to be included) that define the
%      positions to be selected, maximum value is the number of instances
%      in DATA_INPUT.
%   For "features" mode:
%      INDIC array of int16 (position to be included) that define the
%      positions to be selected, maximum value is the number of instances
%      in DATA_INPUT.

%   See also data_compare, data_class, report, get_train, get_test.

%   DATA_SORTER (data_class class) revision history:
%   Date of creation: 11 August 2015 beta (Helena)
%   Creator: Carlos Cabral
if nargin==2||nargin==3
   if nargin==2
      mode='instance';
   end
    %% Overture: Input checking.
    if any(isempty(data))
        error('data_sorter:Function_error','Empty data_class argument provided to function " data_sorter (data_class class) " ')
    end
    if isnumeric(indic)
        if isempty(indic)
            error('data_sorter:Function_error','Empty indices argument provided to function " data_sorter (data_class class) " ')
        elseif numel(size(indic))~=2||sum(size(indic)==1)==0
            error('data_sorter:Function_error',['Invalid dimensions of the indices argument provided to function " data_sorter (data_class object) "  ' num2str(size(indic)) ''])
        end
    else
        error('data_sorter:Function_error',['Undefined function '' data_sorter (data_class class) '' arguments of type ''' class(indic) ''' (Second input argument must be numeric or logical).']);
    end
    flag_size=false;
    if strcmp(mode,'instances')
        max_indice=max(indic);
        for i=1:numel(data)
            if size(data(i).db_code,1)<max_indice
                flag_size=true;
            end
        end
        if min(indic)<1
            flag_size=true;
        end
    else
        max_indice=max(indic);
        for i=1:numel(data)
            if size(data(i).features_descriptor,1)<max_indice
                flag_size=true;
            end
        end
        if min(indic)<1
            flag_size=true;
        end
    end
    if flag_size
        error('data_sorter:Function_error','Indices provided to the function '' data_sorter (data_class class) '' not compatible with the data dimensionality');
    end
    if ~ischar(mode)
        error('data_sorter:Function_error',['Undefined function '' data_sorter (data_class class) '' arguments of type ''' class(mode) ''' (Third input argument must be a string).']);
    elseif ~any(strcmp({'instances','features'},mode))
        error('data_sorter:Function_error',['Undefined function '' data_sorter (data_class class) '' for mode ''' mode ''' (Possible modes are "instances" and "features").'])
    end
    %% Act: Selecting the examples from each data_class object in the data array
    % get the information
    for i=1:numel(data)
        if strcmp(mode,'instances')
            %dbcodes
            data(i).dbcode=data(i).dbcode(indic);
            %data
            data(i).data=data(i).data(indic,:);
            %covariates
            aux_names=fieldnames(data(i).covariates);
            for j=1:numel(aux_names)
                data(i).covariates.(aux_names{j})=data(i).covariates.(aux_names{j})(indic);
            end
            %target_values
            data(i).target_values=data(i).target_values(indic);
        else
            %features_descriptors
            data(i).features_descriptor=data(i).features_descriptor(indic);
            %data
            data(i).data=data(i).data(:,indic);
            %features_grouping
            data(i).feature_grouping=data(i).feature_grouping(indic);
        end
    end
    %% Finale: No finalle the sky is the limit
else
    error('data_sorter:Function_error','Function '' data_sorter (data_class class) called with an invalid number of arguments. (2 argument should be provided)');
end
end