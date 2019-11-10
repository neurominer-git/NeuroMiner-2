function rep =data_reporter(data)
% DATA_REPORTER (DATA_CLASS class)
%   rep=DATA_REPORTER(data)
%
%   DATA_REPORTER (DATA_CLASS class) function receives a data_class object
%   and returns a structure with data properties. The fieldnames in the
%   structures are the properties descriptors. This descriptors can be used
%   in the definition of parameters ranges and sizes. Currently available
%   properties are:
%   'number_of_features'
%   'number_of_examples'
%   'matrix_rank'
%   'number_of_classes'
%   See also data_compare, data_class, report, data_fuser, parameters

%   DATA_REPORTER (data_class class) revision history:
%   Date of creation: 22 October 2014 beta (Helena)
%   Creator: Carlos Cabral
if nargin==1
    %% Overture: Input checking.
    if isempty(data)
        error('data_reporter:Function_error','Empty data_class argument provided to function " data_reporter (data_class class) " ')
    end
    for i=1:numel(data)
    %% Act: Extract the values
    number_of_features=size(data(i).data,2);
    number_of_examples=size(data(i).data,1);
    matrix_rank=rank(data(i).data);
    number_of_classes=data(i).classes;
    number_of_feature_groups=numel(data(i).feature_grouping);
    %% Finale: Assembling the structure
    rep(i)=struct('number_of_features',number_of_features,'number_of_examples',number_of_examples,'matrix_rank',matrix_rank,'number_of_classes',number_of_classes,'number_of_feature_groups',number_of_feature_groups);
    end
else
    error('data_reporter:Function_error','Function '' data_reporter (data_class class) called with an invalid number of arguments. (1 argument should be provided)');
end
end