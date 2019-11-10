function res =reporters(identifier)
%REPORTERS  Returns information about the performance measures in NM2.
%   RES =REPORTERS(IDENTIFIER) returns the information about the
%   performance measures IDENTIFIER.
%
%   REPORTERS will check if the performance measure IDENTIFIER (string) is
%   a performance measured installed in NM2 and returns a structure that
%   encapsulates the information about that measure.
%
%   RES is a structure, empty for non existent performance measures and
%   with three fields for the existent ones. 
%    - evaluation_type - evaluation type to which IDENTIFIER can be applied in
%   accordance with NM2 standard, see data_class documentation
%   - multiclass - TRUE for multiclass methods, FALSE for methods only
%   applicable to binary experiments.
%   - optimal - string indicating the optimal direction of the criteria,
%   possible values are 'less' and 'greater'. Eg. For classification
%   accuracy the greater the value the better while for classification
%   error the inverse is true, the less the better.


%   RES =REPORTERS(IDENTIFIER)

%   REPORTERS revision history:
%   Date of creation: 24 November 2014 beta (Helena)
%   Creator: Carlos Cabral

if nargin==1
    if ischar(identifier)
    %% Overture: Initialization
    aux_res=results();
    aux_res.evaluation='info';
    %% Act : Check if the function exists as a performance method
    aux_what=what('results');
    aux_1=strcmp(aux_what.m,[identifier '.m']);
    %% Finale: Producing the performance measure report
    if any(aux_1)
        try res=feval(identifier,aux_res);
        catch err
            rethrow(err)
        end
    else
        res=struct([]);
        warning('REPORTERS:InputError',['Performance measure ' identifier ' not found in NM2 framework, please make sure that you introduce a valid performance measure function.'])
    end
    else
       error('REPORTERS:InputError',['Undefined function '' reporters '' for the input argument of type ''' class(identifier) ''' (First and only input argument must be a string).']) 
    end
else
    error('REPORTERS:InputError','Invalid numer of arguments specified please read the REPORTERS function documentation.')
end
end