function stru=class2struct(cla,mode)
% CLASS2STRUCT
%   STRUCT=CLASS2STRUCT(CLASSE,MODE)
%
%   CLASS2STRUCT function receives a a Matlab object and return a structure
%   with fields corresponding to the properties. If MODE is true the
%   program will transform the numeric and logical values to strings, if
%   MODE is false or undefined no process will be done.

%   See also reporter.

%   CLASS2STRUCT revision history:
%   Date of creation: 23 of October 2014 beta (Helena)
%   Creator: Carlos Cabral
if nargin==1||nargin==2
    if ~isobject(cla)
        error('class2struct:FunctionError','Undefined function '' class2struct '' for non MATLAB objects as first input');
    end
    if nargin==2
        if ~islogical(mode)
            error('class2struct:FunctionError','Undefined function '' class2struct '' for non logical as second input');
        end
    else
        mode=false;
    end
    if numel(cla)==1
        aux_fields=properties(cla);
        for i=1:numel(aux_fields)
            if ~isempty(cla.(aux_fields{i}))
                if isobject(cla.(aux_fields{i}))
                    stru.(aux_fields{i})=class2struct(cla.(aux_fields{i}),mode);
                else
                    if mode
                        if isnumeric(cla.(aux_fields{i}))||islogical(cla.(aux_fields{i}))
                            stru.(aux_fields{i})=num2str(cla.(aux_fields{i}));
                        elseif islogical(cla.(aux_fields{i}))
                            stru.(aux_fields{i})=num2str(cla.(aux_fields{i}));
                        else
                            if iscell(cla.(aux_fields{i}))
                                uniq=unique(cellfun(@class,iscell(cla.(aux_fields{i})),'UniformOutput',false));
                                if numel(uniq)==1
                                    if strcmp(uniq{1},char)
                                        aux_val=cla.(aux_fields{i}){1};
                                        if numel(cla.(aux_fields{i}))>1
                                            for j=2:numel(cla.(aux_fields{i}))
                                                aux_val=[aux_val ' ' cla.(aux_fields{i}){j}];
                                            end
                                        end
                                        stru.(aux_fields{i})=aux_val;
                                    elseif isnumeric(cla.(aux_fields{i}){1})
                                        stru.(aux_fields{i})=cell2mat(cla.(aux_fields{i}));
                                    else
                                        stru.(aux_fields{i})=cla.(aux_fields{i});
                                    end
                                else
                                    stru.(aux_fields{i})=cla.(aux_fields{i});
                                end
                            else
                                stru.(aux_fields{i})=cla.(aux_fields{i});
                            end
                        end
                    else
                        stru.(aux_fields{i})=cla.(aux_fields{i});
                    end
                end
            end
        end
    else
        for i=1:numel(cla)
            stru.(genvarname(cla(i).process))=class2struct(cla(i),mode);
        end
    end
else
    error('class2struct:FunctionError','Invalid number of arguments for function '' class2strict. (number of arguments is 1 or 2)');
end
end