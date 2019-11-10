function data=data_selector(data,indic,mode)
% DATA_SELECTOR (DATA_CLASS class) selects a data subset from a data classs
% object
%
%   DATA_OUTPUT=DATA_SELECTOR (DATA_INPUT,INDIC) Retrieves the a subset of
%   the DATA_INPUT according to INDIC these indices correspond to the examples
%   that should be included in the DATA_OUTPUT.
%
%   DATA_INPUT is an array of data_class objects with the original data
%   from which you wish to select a subset.
%
%   INDIC array of logicals (0 for exclusion 1 for inclusion), same size as
%   the number of instances on DATA_INPUT or int16 (position to be
%   included) that define the positions to be selected, maximum value is
%   the number of instances in DATA_INPUT.
%
%   DATA_OUTPUT is an array of data_class objects that contains, in the
%   respective positions, the subsets of DATA_INPUT defined by INDIC.
%
%   DATA_OUTPUT=DATA_SELECTOR (DATA_INPUT,INDIC.MODE) Retrieves the a
%   subset of DATA_INPUT object according to the provided INDIC and
%   MODE. For "instances" mode, INDIC correspond to the examples that 
%   should be included in the DATA_OUTPUT, while for "features"
%   mode, INDIC correspond to the features that should be included in
%   DATA_OUTPUT
% 
%
%   MODE is an string defining the selection mode, two values are possible:
%   "instances" (default) and "features". 
%   For "instance" mode:
%      INDIC array of logicals (0 for exclusion 1 for inclusion), same size
%      as the number of instances on DATA_INPUT or int16 (position to be
%      included) that define the positions to be selected, maximum value is
%      the number of instances in DATA_INPUT.
%   For "features" mode:
%      INDIC array of logicals (0 for exclusion 1 for inclusion), same size
%      as the number of features in DATA_INPUT or int16 (position to be
%      included) that define the positions to be selected, maximum value is
%      the number of instances in DATA_INPUT.

%   See also data_compare, data_class, report, get_train, get_test.

%   DATA_SELECTOR (data_class class) revision history:
%   Date of creation: 22 May 2014 beta (Helena)
%   Creator: Carlos Cabral
%
%   Date of Modification: 12 of August 2015
%   Modification: Integration of features mode, basic usage still available
%   Modifier: Carlos Cabral
if nargin==2||nargin==3
   if nargin==2
      mode='instances';
   end
    %% Overture: Input checking.
    if any(isempty(data))
        error('data_selector:Function_error','Empty data_class argument provided to function " data_selector (data_class class) " ')
    end
    if ~ischar(mode)
        error('data_selector:Function_error',['Undefined function '' data_selector (data_class class) '' arguments of type ''' class(mode) ''' (Third input argument must be a string).']);
    elseif ~any(strcmp({'instances','features'},mode))
        error('data_selector:Function_error',['Undefined function '' data_selector (data_class class) '' for mode ''' mode ''' (Possible modes are "instances" and "features").'])
    end
    if isnumeric(indic)||islogical(indic)
        if isempty(indic)
            error('data_selector:Function_error','Empty indices argument provided to function " data_selector (data_class class) " ')
        elseif numel(size(indic))~=2||sum(size(indic)==1)==0
            error('data_selector:Function_error',['Invalid dimensions of the indices argument provided to function " data_selector (data_class object) "  ' num2str(size(indic)) ''])
        end
    else
        error('data_selector:Function_error',['Undefined function '' data_selector (data_class class) '' arguments of type ''' class(indic) ''' (Second input argument must be numeric or logical).']);
    end
    flag_size=false;
    if isnumeric(indic)
        max_indice=max(indic);
        if strcmp(mode,'instances')
            for i=1:numel(data)
                if size(data(i).dbcode,1)<max_indice
                    flag_size=true;
                end
            end
        else
            for i=1:numel(data)
                if size(data(i).features_descriptor,2)<max_indice
                    flag_size=true;
                end
            end
        end
        if min(indic)<1
           flag_size=true;
        end
    else
       if strcmp(mode,'instances') 
       for i=1:numel(data)
           if numel(indic)~=numel(data(i).dbcode)
              flag_size=true;
           end
       end
       else
           for i=1:numel(data)
               if numel(indic)~=numel(data(i).features_descriptor)
                   flag_size=true;
               end
           end
       end
    end
    if flag_size
        error('data_selector:Function_error','Indices provided to the function '' data_selector (data_class class) ''not compatible with the number of examples');
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
                data(i).covariates.(aux_names{j})=data(i).covariates.(aux_names{j})(indic,:);
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
    error('data_selector:Function_error','Function '' data_selector (data_class class) called with an invalid number of arguments. (2 argument should be provided)');
end
end