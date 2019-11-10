function val_output=decomposition(val,mode)
%DECOMPOSITION (VALIDATION_DESIGN class) performs the multi-class
%decomposition.
%   VAL_OUTPUT=DECOMPOSITION(VAL,MODE) transforms the VALIDATION_DESIGN
%   object VAL accordingly with the decomposition method specified the
%   string MODE.
%
%   MODE defines the functioning mode, possible values are 'pairwise' and
%   'one_vs_all', if no valus for MODE is provided the program will use as
%   default 'pairwise'.
%
%   RES is a 2D array of VALIDATION_DESIGN objects. With rows corresponding
%   to folds and columns to decomposition of a single folder partition.

%   VAL_OUTPUT=DECOMPOSITION(VAL,MODE)

%   DECOMPOSITION (VALIDATION_DESIGN class)  revision history:
%   Date of creation: 04 November 2014 beta (Helena)
%   Creator: Carlos Cabral
if nargin==2||nargin==1
    %% Overture: Input checking
    if ~all(isvalidation_design(val))
        error('decomposition:FunctionError',['Undefined function '' decomposition (validation_design class) '' for the first input argument of type ''' class(val) ''' (First input argument must be a validation_design class object).']);
    elseif all(isempty(validation_design))
        val_output=val;
        return
    end
    if strcmp(val.evaluation_type,'multiclass_classification')
       classes=unique(cell2mat(val.target_values));
    else
        warning('decomposition:FunctionWarning',['Undefined function '' decomposition (validation_design class) '' for ' val.evaluation_type ' evaluation types (Method only valid for multi-class classification ) \n Nothing do to, original validation_desing returned.']);
        return
    end
    if nargin==2
        if ~ischar(mode)
            error('decomposition:FunctionError','Error using decomposition (validation_design class) \n Third input, "mode" is invalid, input is not a character class element or array.')
        elseif ~any(strcmp(mode,{'pairwise','ones_vs_all'}))
            error('decomposition:FunctionError','Error using decomposition (validation_design class) \n Mode is invalid. Possible values are "pairwise" and "one_vs_all"')
        end
    else
        mode='pairwise';
    end
    switch mode
        case 'pairwise'
            comb=nchoosek(1:numel(classes),2);
        case 'one_vs_all'
            numb_comb=numel(classes);
    end
    %% Act: Looping over the validation_class array and performing the decomposition procedure
    val_output=validation_design.empty(numel(val),0);
    for i=1:numel(val)
        aux=val(i);
        switch mode
            case 'pairwise'
                aux_output=validation_design.empty(0,size(comb,1));
                for j=1:size(comb,1)
                    aux_comb=comb(j,:);
                    targs=((aux.target_values==classes(aux_comb(1)))+aux.target_values==aux.classes(aux_comb(2)))>0;
                    aux_output(j)=validation_design(aux.train&targs,aux.test&targs,aux.target_values,classes(aux_comb),decomposition(aux.design,mode),aux.depth);
                end
            case 'one_vs_all'
                aux_output=validation_design.empty(0,numb_comb);
                for j=1:numb_comb
                    targs=double(aux.target_values==aux.classes(j));
                    targs(targs==0)=-1;
                    aux_output(j)=validation_design(aux.train,aux.test,targs,[1 -1],decomposition(aux.design,mode),aux.depth);
                end
        end
        %% Finale: Producing the completed validation_design element.
        val_output(i,:)=aux_output;
    end
else
    error('decomposition:FunctionError','Invalid number of arguments for function '' decomposition (validation_design class).');
end
end