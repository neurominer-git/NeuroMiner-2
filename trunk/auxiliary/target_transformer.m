function target=target_transformer(target_orig,evaluation_type,mode,classes)
% TARGET_TRANSFORMER 
%   TARGET=TARGET_TRANSFORMER(target,mode,classes,evaluation_type)
%
%   TARGET_TRANSFORMER function receives a TARGET_ORIG (cell array,
%   logical array, numerical array or character array), a functioning MODE 
%   (string) an EVALUATION_TYPE (string) and for evaluation_type 'classification'
%   also the CLASSES in the classification experiment (cell array)and 
%   transforms the TARGET_ORIG accordingl. For each one of the 
%   EVALUATION_TYPE possibilities (data_class classes property values +
%   classification) are allowed modes that will transform the input target
%   values to a certain format. Transformations have always an inverse 
%   transformation impletemented, to make possible the transformation to 
%   and from NM2 allowed target format.
%   The motivation behind this functions is the different labels format 
%   that classification functions may take. By developing a function that 
%   transforms NM2 target_values format to several types of target_values
%   representation we aim to facilitate the integration of methods 
%   in the NM2 framework.
%
%   TARGET configuration and data type depend primarily on the
%   EVALUATION_TYPE and secondly on the MODE, valid options are:
%
%   EVALUATION_TYPE: 'classification'
%       MODE:'cell2array' - From NM2 target_values format (cell) to an
%       array of integers or characters depending on the original targets
%       data type.
%       MODE:'array2cell' - From an array of integers or characteres to
%       NM2 target_values format (cell).
%       MODE:'charcell2doublearray' - From NM2 target_values (cell) of
%       characteres to an array of doubles. Requires the classes present in
%       the classification experiment. Let 'doublearray' represent the array
%       of doubles, 'charcell' the cell of characteres arrays and 'classes'
%       a cell with the classes involved in the classification experiment.
%       'doublearray' and 'charcell' will have the same size and the
%       'doublearray(i)' corresponds to the position of 'charcell(i)' in
%       'classes'.
%       MODE:'doublearray2charcell' - From an array of doubles to NM2
%       target_values format (cell). Requires the classes present in the
%       classification experiment. The process is the inverse of the one
%       described for the mode 'charcell2doublearray'.
%   
%   EVALUATION_TYPE: 'regression','ranking','multi_dimensional_regression'
%       MODE:'cell2array' - From NM2 target_values format (cell) to an
%       array of doubles (regression and multi_dimensional_regression) or 
%       logicals (ranking).
%       MODE:'array2cell' - From an array of doubles (regression and 
%       multi_dimensional_regression) or logicals (ranking) to NM2 
%       target_values format (cell).

%   See also data_class, evaluation.

%   TARGET_TRANSFORMER revision history:
%   Date of creation: 29 October 2014 beta (Helena)
%   Creator: Carlos Cabral

if nargin==4||nargin==3
    %% Overture: Input checking.
    if ~ischar(evaluation_type)
       error('target_transformer:InputError',['Undefined function '' target_transformer  '' for evaluation_type  input argument of type ''' class(evaluation_type) ''' (Second input argument must be string).']);
    elseif ~any(strcmp(evaluation_type,{'classification','regression','multi_dimensional_classification','multi_dimensional_regression','ranking'}))
        error('target_transformer:InputError',['Undefined function '' target_transformer  '' for the evaluation type ''' evaluation_type '''.']);
    end
    if ~ischar(mode)
       error('target_transformer:InputError',['Undefined function '' target_transformer  for mode arguments of type ''' class(mode) ''' (Third input argument must be string).']);
    end
    if isempty(mode)
        error('target_transformer:Function_error','Undifined mode provided to function " target_transformer " ')
    end
    switch evaluation_type
        case 'classification'
            switch mode
                case 'cell2array'
                    if iscell(target_orig)
                        target=cat(1,target_orig{:});
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                case 'array2cell'
                    if isnumeric(target_orig)
                        target=num2cell(int16(target_orig),2);
                    elseif ischar(target_orig)
                        target=num2cell(target_orig,2);
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                case 'charcell2doublearray'
                    if isnumeric(target_orig{1})
                        target=double(cat(1,target_orig{:}));
                    elseif ischar(target_orig{1})
                        if ~exist('classes','var')
                            error('target_transformer:InputError',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " in the absence of the fourth input argument.'])
                        elseif ~iscell(classes)
                            error('target_transformer:InputError',['Undefined function '' target_transformer  for classes argument of type ''' class(classes) ''' (Fourth input argument must be a cell).']);
                        elseif ~isempty(setdiff(target_orig,classes))
                            error('target_transformer:InputError',['Fucntion " target_transformer " , evaluation_type " ' evaluation_type ' " , mode " ' mode ' " incompatible classes and target_values.'])
                        end
                        target=zeros(numel(target_orig),1);
                        for i=1:numel(target_orig)
                            target(i)=find(strcmp(classes,target_orig{i}));
                        end
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                case 'doublearray2charcell'
                    if ~exist('classes','var')
                        error('target_transformer:InputError',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " in the absence of the fourth input argument.'])
                    elseif ~iscell(classes)
                        error('target_transformer:InputError',['Undefined function '' target_transformer  for classes argument of type ''' class(classes) ''' (Fourth input argument must be a cell).']);
                    end
                    aux_val=round(double(target_orig));
                    if sum(aux_val-target_orig)~=0
                       warning('target_transformer:InputError',['In fucntion " target_transformer " , evaluation_type " ' evaluation_type ' " , mode " ' mode ' " decimal values were found for the original targets variable, round values will be used.'])
                       target_orig=round(target_orig);
                    end
                    if any(target_orig)<1||any(target_orig>numel(classes))
                       error('target_transformer:InputError',['Fucntion " target_transformer " , evaluation_type " ' evaluation_type ' " , mode " ' mode ' " incompatible classes and target_values.'])
                    end
                    target=cell(size(target_orig,1),1);
                    for i=1:size(target_orig,1)
                        target{i}=classes{target_orig(i)};
                    end
                otherwise
                    error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " for the mode " ' mode ' " '])
            end
        case 'regression'
            switch mode
                case 'cell2array'
                    if iscell(target_orig)
                       target=cat(1,target_orig{:});
                    else
                      error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])  
                    end
                case 'array2cell'
                    if isdouble(target_orig)
                        target=num2cell(target_orig);
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                otherwise
                    error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " for the mode " ' mode ' " '])
            end
        case 'ranking'
            switch mode
                case 'cell2array'
                    if iscell(target_orig)
                        target=cat(1,target_orig{:});
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                case 'array2cell'
                    if islogical(target_orig)
                        target=num2cell(target_orig,2);
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                otherwise
                    error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " for the mode " ' mode ' " '])
            end
        case 'multi_dimensional_regression'
            switch mode
                case 'cell2array'
                    if iscell(target_orig)
                        target=cat(1,target_orig{:});
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                case 'array2cell'
                    if isdouble(target_orig)
                        target=num2cell(target_orig,2);
                    else
                        error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " and mode " ' mode ' " for targets of type " ' class(target_orig) ' "  '])
                    end
                otherwise
                    error('target_transformer:Function_error',['Undifined fucntion " target_transformer "  for the evaluation_type " ' evaluation_type ' " for the mode " ' mode ' " '])
            end
        case 'multi_dimensional_classification'
            error('target_transformer:Function_error','Undifined fucntion " target_transformer "  for the evaluation_type " multi_dimensional_classification " please contact the development team.')
    end
else
    error('target_transformer:InputError','Function '' target_transformer called with an invalid number of arguments. (3 or 4 argument should be provided)');
end
end