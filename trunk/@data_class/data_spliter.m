function data_out=data_spliter(data,mode)
% DATA_SPLITER (DATA_CLASS class) splits a data_class object into an array
% of data_class objects.
%
%   DATA_OUTPUT=DATA_SPLITER (DATA_INPUT) Splits the data class
%   object, DATA_INPUT into as many data_class objects as unique values
%   found in its "target_values", property, hence each of the produced
%   data_class object in DATA_OUTPUT corresponds to the data of a single
%   class.
%
%   DATA_INPUT is a data_class object with the original data
%   that you wish to split.
%
%   DATA_OUTPUT is a data_class objects that contains the results of the
%   spliting of DATA_INPUT
%
%   DATA_OUTPUT=DATA_SPLITER (DATA_INPUT,MODE) Splits the data class
%   object, DATA_INPUT, according to the mode defined by MODE. 
%   If the "target_values" is selected DATA_SPLITER splits DATA_INPUT into
%   as many data_class objects as unique values found in its
%   "target_values", property, hence each of the produced data_class object
%   in DATA_OUTPUT corresponds to the data of a single class.
%   If the "feature_grouping" mode is selected DATA_SPLITER splits the
%   DATA_INPUT into as many unique values as found in its
%   "feature_grouping" property,hence each of the produced data_class
%   object in DATA_OUTPUT corresponds to the data of a a single group of
%   features.
%
%   MODE is an string defining the selection mode, two values are possible:
%   "target_values" (default) and "feature_grouping". 

%   See also data_compare, data_class, data_prunner, data_selector.

%   DATA_SPLITER (data_class class) revision history:
%   Date of creation: 17 August 2015 beta (Helena)
%   Creator: Carlos Cabral

if nargin==1||nargin==2
    if nargin==1
       mode='target_values';
    end
    %% Overture: Input checking.
    if numel(data)>1
        error('data_spliter:Function_error','The dimension of the argument provided to function " data_spliter (data_class class) " is not valid (number of elements should be 1))')
    end
    if ~ischar(mode)
        error('data_spliter:Function_error',['Undefined function '' data_spliter (data_class class) '' arguments of type ''' class(mode) ''' (Third input argument must be a string).']);
    elseif ~any(strcmp({'target_values','feature_grouping'},mode))
        error('data_spliter:Function_error',['Undefined function '' data_spliter (data_class class) '' for mode ''' mode ''' (Possible modes are "instances" and "features").'])
    end
    %% ACT 1: Getting the data sets to be defined
    if strcmp(mode,'target_values')
        if strcmp(data.evaluation_type,'binary_classification')
           [unique_vals,~,positions]=unique(cell2mat(data.target_values));
        else
           error('data_spliter:Function_error',['Undefined function '' data_spliter (data_class class) '' for mode ''' mode ''' for evaluation type " ' data.evaluation_type ' Further development is necessary".']) 
        end
    else
       [unique_vals,~,positions]=unique(data.feature_grouping); 
    end
    %% Finnale: find the subsets and Applying the final selection
    for i=1:numel(unique_vals)
        vec=positions==i;
        if strcmp(mode,'target_values')
           data_out(i)=data.data_selector(vec,'instances');
        else
           data_out(i)=data.data_selector(vec,'features');
        end
        data_out(i).type=[data_out(i).type '_' num2str(unique_vals(i))];
    end
else
    error('data_spliter:Function_error','Function '' data_spliter (data_class class) called with an invalid number of arguments. (1 or 2 argument should be provided)');
end
end