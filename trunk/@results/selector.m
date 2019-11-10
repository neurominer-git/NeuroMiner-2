function result=selector(result,indic)
% DATA_SELECTOR (DATA_CLASS class) selects a data subset from a data classs
% object
%
%   DATA_OUTPUT=DATA_SELECTOR (DATA_INPUT,INDIC) Retrieves the a subset of
%   the DATA_INPUT according to INDIC these indices correspond to the examples
%   that should be included in the DATA_OUTPUT.
%
%   DATA_INPUT is an array of results objects with the original data
%   from which you wish to select a subset.
%
%   INDIC array of logicals (0 for exclusion 1 for inclusion), same size as
%   the number of instances on DATA_INPUT or int16 (position to be
%   included) that define the positions to be selected, maximum value is
%   the number of instances in DATA_INPUT.
%
%   DATA_OUTPUT is an array of results objects that contains, in the
%   respective positions, the subsets of DATA_INPUT defined by INDIC.

%   See also data_compare, results, report, get_train, get_test.

%   DATA_SELECTOR (results class) revision history:
%   Date of creation: 13 September 2016 beta (Helena)
%   Creator: Carlos Cabral
if nargin==2
    %% Overture: Input checking.
    if any(isempty(result))
        error('selector:Function_error','Empty results argument provided to function " selector (results class) " ')
    end
    if isnumeric(indic)||islogical(indic)
        if isempty(indic)
            error('selector:Function_error','Empty indices argument provided to function " selector (results class) " ')
        elseif numel(size(indic))~=2||sum(size(indic)==1)==0
            error('selector:Function_error',['Invalid dimensions of the indices argument provided to function " selector (results object) "  ' num2str(size(indic)) ''])
        end
    else
        error('selector:Function_error',['Undefined function '' selector (results class) '' arguments of type ''' class(indic) ''' (Second input argument must be numeric or logical).']);
    end
    flag_size=false;
    if isnumeric(indic)
        max_indice=max(indic);
        for i=1:numel(result)
            if size(result(i).dbcode,1)<max_indice
                flag_size=true;
            end
        end
        if min(indic)<1
            flag_size=true;
        end
    else
        for i=1:numel(result)
            if numel(indic)~=numel(result(i).dbcode)
                flag_size=true;
            end
        end
    end
    if flag_size
        error('selector:Function_error','Indices provided to the function '' selector (results class) ''not compatible with the number of examples');
    end
    %% Act: Selecting the examples from each results object in the data array
    % get the information
    for i=1:numel(result)
        %dbcodes
        result(i).dbcode=result(i).dbcode(indic);
        %hard_labels
        result(i).hard_labels=result(i).hard_labels(indic);
        %soft_labels
        result(i).soft_labels=result(i).soft_labels(indic,:);
        %target_values
        result(i).target_values=result(i).target_values(indic);
    end
    %% Finale: No finalle the sky is the limit
else
    error('selector:Function_error','Function '' selector (results class) called with an invalid number of arguments. (2 argument should be provided)');
end
end