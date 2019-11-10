function rep =classes(data)
% CLASSES (DATA_CLASS class) determines the classes present in a DATA_CLASS
% element if applicable.
%   RES=CLASSES(data) receives a DATA_CLASS object and if it corresponds to
%   an evaluation process of the types : 'binary_classification',
%   'multiclass_classification','one_class_modeling' and 
%   'semisupervised_learning' returns the classes present in numerical 
%   array format.
%
%   For evaluation type 'regression' CLASSES will return the range of the 
%   target_values property again in the form of a numeric array with two 
%   elements [low high]. 
%
%   For evaluation_type property 'hierarchical' and 'multi-labelled' CLASSES
%   returns a 2D cell. The first position contains a numerical array with
%   the single classes present in DATA and the second position a cell
%   containing all the distinct combinations that can be found in the
%   target_values field of DATA.
%
%   For evaluation_type property 'unsupervised_learning' CLASSES outpus is
%   empty.
%
%   See also DATA_CLASS, DATA_REPORTER

%   CLASSES (data_class class) revision history:
%   Date of creation: 28 November 2014 beta (Helena)
%   Creator: Carlos Cabral
if nargin==1
    %% Overture: Input checking.
    if numel(data)~=1
        error('classes:Function_error','The dimension of the argument provided to function " classes (data_class class) " is not valid (number of elements should be 1))')
    elseif isempty(data)
        error('classes:Function_error','Empty data_class argument provided to function " classes (data_class class) " ')
    end
    %% Act: Extract the values
    switch data.evaluation_type
        case 'binary_classification'
            rep=unique(cell2mat(data.target_values));
            rep=sort(rep,'descend');
        case 'multiclass_classification'
            rep=unique(cell2mat(data.target_values));
        case 'multi_labelled'
            ab=true;
            aux_targs=data.target_values;
            combs=cell(0);
            while ab
                combs{end+1}=aux_targs{1};
                %check the size of the first multidimensional label with the
                %rest of the labels
                aux_numel=cellfun('size',target_values,2);
                ref_numel=aux_numel==size(aux_targs{1},2);
                %selecting the multidimensinal labels that have the same
                %size as aux_targs{1}
                dummy_targa=aux_targs(~ref_numel);
                ref_numel=find(ref_numel);
                % from the ones with the same size find the ones that are
                % equal to aux_targs{1};
                [~,pos_label]=ismember(aux_targs{1},cell2mat(dummy_targa),'rows');
                aux_targs(ref_numel(pos_label))=[];
                if isempty(aux_targs)
                    ab=false;
                end
            end
            rep={unique(cell2mat(data.target_values)),combs};
        case 'hierarchical'
            ab=true;
            aux_targs=data.target_values;
            combs=cell(0);
            while ab
                combs{end+1}=aux_targs{1};
                %check the size of the first multidimensional label with the
                %rest of the labels
                aux_numel=cellfun('size',target_values,2);
                ref_numel=aux_numel==size(aux_targs{1},2);
                %selecting the multidimensinal labels that have the same
                %size as aux_targs{1}
                dummy_targa=aux_targs(~ref_numel);
                ref_numel=find(ref_numel);
                % from the ones with the same size find the ones that are
                % equal to aux_targs{1};
                [~,pos_label]=ismember(aux_targs{1},cell2mat(dummy_targa),'rows');
                aux_targs(ref_numel(pos_label))=[];
                if isempty(aux_targs)
                    ab=false;
                end
            end
            rep={[true false],combs};
        case 'regression'
            rep=[min(cell2mat(data.target_values)) max(cell2mat(data.target_values))];
        case 'unsupervised_learning'
            rep=[];
        case 'semisupervised_learning'
            aux_rep=cellfun(@isempty,data.target_values);
            aux_rep=data.target_values(aux_rep);
            rep=unique(cell2mat(aux_rep));
            if numel(rep)==2
                rep=sort(rep,'descend');
            end
        case 'one_class_modeling'
            rep=[true false];
    end
    %% Finale: No finale the sky is the limit
else
    error('classes:Function_error','Function '' classes (data_class class) called with an invalid number of arguments. (1 argument should be provided)');
end
end