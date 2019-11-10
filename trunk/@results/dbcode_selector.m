function result=dbcode_selector(result,dbcodes)
% DBCODE_SELECTOR (RESULTS class) selects a result subset from a result classs
% object based on the dbcodes.
%
%   RESULTS_OUTPUT=DBCODE_SELECTOR(RESULTS_INPUT,DBCODES) Retrieves the a subset of
%   the RESULTS_INPUT according to DBCODES these DBCODES correspond to the examples
%   that should be included in the RESULTS_OUTPUT.
%
%   RESULTS_INPUT is an array of results objects with the original result
%   from which you wish to select a subset.
%
%   DBCODES is an cellstring array with the DBCODES that should be
%   included in the output. DBCODES should contain unique values, by
%   default the program performs this operation.
%
%   RESULTS_OUTPUT is an array of results objects that contains, in the
%   respective positions, the subsets of RESULTS_INPUT defined by DBCODES.

%   See also selector, results.

%   DBCODE_SELECTOR (results class) revision history:
%   Date of creation: 14 September 2016 beta (Helena)
%   Creator: Carlos Cabral
if nargin==2
    %% Overture: Input checking.
    if any(isempty(result))
        error('dbcode_selector:Function_error','Empty results argument provided to function " dbcode_selector (results class) " ')
    end
    if iscellstr(dbcodes)
        dbcodes1=unique(dbcodes);
        if numel(dbcodes)~=numel(unique(dbcodes1))
            dbcodes=dbcodes1;
        end
    else
        error('dbcode_selector:Function_error',['Undefined function '' dbcode_selector (results class) '' arguments of type ''' class(indic) ''' (Second input argument must be cell array of strings).']);
    end
    %% Act: Selecting the examples from each results object in the result array
    % get the information
    for i=1:numel(result)
        aux=result(i).dbcode;
        aux=cellfun(@(x) find(strcmp(aux,x)),dbcodes,'UniformOutput',false);
        aux(cellfun(@isempty,aux))=[];
        if isempty(aux)
           result(i)=results; 
        else
        result(i)=result(i).selector(cell2mat(aux));
        end
    end
    %% Finale: No finalle the sky is the limit
else
    error('dbcode_selector:Function_error','Function '' dbcode_selector (results class) called with an invalid number of arguments. (2 argument should be provided)');
end
end