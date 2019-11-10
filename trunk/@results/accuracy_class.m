function res =accuracy_class(r)
%ACCURACY_CLASS (RESULTS class) determines the class accuracy of one or more evaluation
%experiments results from an array of RESULTS classs objects.
%   RES=CLASS_ACCURACY (R) computes the class accuracy of an array of RESULTS class
%   objects (R) based on the CONFUSION_MATRIX of each one of them. 
%
%   RES is a cell of the same size as R, each position of RES
%   represents the class accuracy of the correspondent component of R 
%   (Number of classes by 1 vector), evaluation processes that do not 
%   correspond to evaluation are treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which ACCURACY_CLASS can be applied in
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
%   RES=CLASS_ACCURACY (R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING CONFUSION_MATRIX

%   CLASS_ACCURACY (RESULTS class)  revision history:
%   Date of creation: 5 November 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Getting the confusion matrices
info_crit=false;
if numel(r)==1
   if strcmp(r.descriptor,'info');
      info_crit=true;
   end
end
if ~info_crit
res=cell(size(r));
confusion=r.confusion_matrix;
for i=1:numel(r)
    %% Act: Computing the class accuracy
    if any(strcmp(r(i).evaluation_type,{'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'}))
        res{i}=diag(confusion{i})./(sum(confusion{i},2)+eps);
    else
        res{i}=NaN;
        warning('class_accuracy:IncompatibilityError',['class_accuracy (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.'])
    end
end
else
%% Finale: Information regarding the measure
    res.evaluation_type={'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'};
    res.optimal='greater';
end
end