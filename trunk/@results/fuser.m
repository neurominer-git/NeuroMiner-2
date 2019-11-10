function res =fuser(r)
%FUSER (RESULTS class) fuses an array of RESULTS class objects into a
%single RESULTS class element.
% RES=FUSER (R) returns a RESULTS class object (RES) containing all the
% information encolsed in the RESULTS class array (R). The only constraint
% is that the number of classes in the soft_label property across
% (R) is the same.


%   RES=FUSER (R)
%   See also RESULTS, ACCURACY, ENSEMBLE_LEARNING

%   FUSER (RESULTS class)  revision history:
%   Date of creation: 27 of October 2014 beta (Helena)
%   Creator: Carlos Cabral
if numel(r)>1
    %% Overture: Initialization of the variables.
    aux_hard_labels=r(1).hard_labels;
    aux_soft_labels=r(1).soft_labels;
    aux_dbcode=r(1).dbcode;
    aux_target_values=r(1).target_values;
    aux_features=r(1).features;
    aux_descriptor=r(1).descriptor;
    aux_evaluation_type=r(1).evaluation_type;
    aux_cla=r(1).classes;
    for i=2:numel(r)
        aux=r(i);
        if strcmp(aux_evaluation_type,'regression')
            aux_cla=aux.classes;
        else
            aux_cla=unique([aux_cla;aux.classes]);
        end
        if ~isempty(aux)
            if isempty(setdiff(aux_evaluation_type,aux.evaluation_type))&&(isempty(setdiff(aux_cla,aux.classes))||numel(aux.classes)==1)
                if size(aux_soft_labels,2)==size(aux.soft_labels,2)
                    aux_hard_labels=cat(1,aux_hard_labels,aux.hard_labels);
                    aux_soft_labels=cat(1,aux_soft_labels,aux.soft_labels);
                    aux_dbcode=cat(1,aux_dbcode,aux.dbcode);
                    aux_target_values=cat(1,aux_target_values,aux.target_values);
                    if isempty(strfind(aux_features,aux.features))
                        aux_features=[aux_features '|' aux.features];
                    end
                    if isempty(strfind(aux_descriptor,aux.descriptor))
                        aux_descriptor=char(aux_descriptor,aux.descriptor);
                    end
                else
                    error('fuser:InputError','fuser (RESULTS class) is undifined for RESULTS class objects with different number of classes.')
                end
            else
                error('fuser:InputError','fuser (RESULTS class) is undifined for RESULTS class objects resulting from different evaluation types or distinct classes/regressing variables.')
            end
        else
            error('fuser:InputError','fuser (RESULTS class) is undifined for empty RESULTS class objects.')
        end
    end
    if strcmp(aux_evaluation_type,'regression')
    aux_cla=[min(cell2mat(aux_target_values)) max(cell2mat(aux_target_values))];
    end
    res=results(aux_hard_labels,aux_soft_labels,aux_dbcode,aux_target_values,aux_features,aux_descriptor,aux_evaluation_type,aux_cla);
else
    res=r;
end