function data=dbcode_selector(data,dbcodes)
% DBCODE_SELECTOR (DATA_CLASS class) selects a data subset from a data classs
% object based on the dbcodes.
%
%   DATA_OUTPUT=DBCODE_SELECTOR(DATA_INPUT,DBCODES) Retrieves the a subset of
%   the DATA_INPUT according to DBCODES these DBCODES correspond to the examples
%   that should be included in the DATA_OUTPUT.
%
%   DATA_INPUT is an array of data_class objects with the original data
%   from which you wish to select a subset.
%
%   DBCODES is an cellstring array with the DBCODES that should be
%   included in the output. DBCODES should contain unique values, by the
%   default the program performs this operation.
%
%   DATA_OUTPUT is an array of data_class objects that contains, in the
%   respective positions, the subsets of DATA_INPUT defined by DBCODES.

%   See also data_selector, data_class.

%   DBCODE_SELECTOR (data_class class) revision history:
%   Date of creation: 14 September 2016 beta (Helena)
%   Creator: Carlos Cabral
if nargin==2
    %% Overture: Input checking.
    if any(isempty(data))
        error('dbcode_selector:Function_error','Empty data_class argument provided to function " dbcode_selector (data_class class) " ')
    end
    if iscellstr(dbcodes)
        dbcodes1=unique(dbcodes);
        if numel(dbcodes)~=numel(unique(dbcodes1))
            dbcodes=dbcodes1;
        end
    else
        error('dbcode_selector:Function_error',['Undefined function '' dbcode_selector (data_class class) '' arguments of type ''' class(indic) ''' (Second input argument must be cell array of strings).']);
    end
    %% Act: Selecting the examples from each data_class object in the data array
    % get the information
    for i=1:numel(data)
        aux=data(i).dbcode;
        aux=cellfun(@(x) find(strcmp(aux,x)),dbcodes,'UniformOutput',false);
        aux(cellfun(@isempty,aux))=[];
        if isempty(aux)
           data(i)=data_class; 
        else
        data(i)=data(i).data_selector(cell2mat(aux));
        end
    end
    %% Finale: No finalle the sky is the limit
else
    error('dbcode_selector:Function_error','Function '' dbcode_selector (data_class class) called with an invalid number of arguments. (2 argument should be provided)');
end
end