function res =auc(r)
%AUC (RESULTS class) determines the AUC (AREA UNDER THE CURVE) of one or
%   more evaluation experiments results from an array of RESULTS classs objects.
%   RES=AUC (R) computes the AUC of an array of RESULTS class
%   objects (R) based on the evaluation results of each one of them.
%
%   RES is a vector of the same size as R, each position of RES
%   represents the AUC of the correspondent component of R
%   (scalar), evaluation processes that do not correspond to binary
%   classification are treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which AUC can be applied in
%   accordance with NM2 standard, see data_class documentation
%   - multiclass - TRUE for multiclass methods, FALSE for methods only
%   applicable to binary experiments.
%   - optimal - string indicating the optimal direction of the criteria,
%   possible values are 'less' and 'greater'. Eg. For classification
%   accuracy the greater the value the better while for classification
%   error the inverse is true, the less the better.
%   To automatically obtain the reporting structure of a performance methed
%   use the function reporter. reporters('name of the function').
%
%   RES=AUC (R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING CONFUSION_MATRIX

%   AUC (RESULTS class)  revision history:
%   Date of creation: 14 November 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Getting the confusion matrices
info_crit=false;
if numel(r)==1
    if strcmp(r.descriptor,'info');
        info_crit=true;
    end
end
if ~info_crit
    res=zeros(size(r));
    for i=1:numel(r)
        %% Act: Computing the AUC
        if any(strcmp(r(i).evaluation_type,{'binary_classification','semisupervised_learning','one_class_modeling'}))
            if numel(r(i).classes)==2
                [~,~,~,aux]=perfcurve(cell2mat(r(i).target_values),cell2mat(r(i).hard_labels),r(i).classes(1));
                res(i)=aux;
            else
                res(i)=NaN;
            end
        else
            res(i)=NaN;
            warning('AUC:IncompatibilityError',['AUC (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.'])
        end
    end
else
    %% Finale: Information regarding the measure
    res.evaluation_type={'binary_classification','semisupervised_learning','one_class_modeling'};
    res.optimal='greater';
end
end