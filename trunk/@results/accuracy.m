function res =accuracy(r)
%ACCURACY (RESULTS class) determines the accuracy of one or more evaluation
%experiments results from an array of RESULTS classs objects.
%   RES=ACCURACY (R) computes the accuracy of an array of RESULTS class
%   objects (R) based on the CONFUSION_MATRIX of each one of them.
%
%   RES is a double vector of the same size as R, each position of RES
%   represents the accuracy of the correspondent component of R, evaluation
%   processes that do not correspond to classification processes are treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which ACCURACY can be applied in
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
%   RES=ACCURACY (R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING CONFUSION_MATRIX
%
%   ACCURACY (RESULTS class)  revision history:
%   Date of creation: 5 November 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Initialization and Getting the confusion matrices
info_crit=false;
if numel(r)==1
    if strcmp(r.descriptor,'info');
        info_crit=true;
    end
end
if ~info_crit
    res=zeros(size(r));
    confusion=r.confusion_matrix;
    for i=1:numel(r)
        %% Act: Computing the accuracy
        if any(strcmp(r(i).evaluation_type,{'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'}))
            res(i)=sum(diag(confusion{i}))/sum(confusion{i}(:)+eps);
        else
            res(i)=NaN;
            warning('accuracy:IncompatibilityError',['accuracy (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.'])
        end
    end
    %% Finale: No Finalle the sky is the limit
else
    %% Finale: Information regarding the measure
    res.evaluation_type={'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'};
    res.optimal='greater';
end
end