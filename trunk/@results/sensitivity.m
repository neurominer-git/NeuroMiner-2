function res =sensitivity(r)
%SENSITIVITY (RESULTS class) determines the sensitivity of one or more evaluation
%experiments results from an array of RESULTS classs objects.
%   RES=SENSITIVITY (R) computes the sensitivity of an array of RESULTS class
%   objects (R) based on the CONFUSION_MATRIX of each one of them. 
%
%   RES is a vector of the same size as R, each position of RES
%   represents the sensitivity of the correspondent component of R 
%   (scalar), evaluation processes that do not correspond to binary 
%   classification are treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which SENSITIVITY can be applied in
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
%   RES=SENSITIVITY (R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING CONFUSION_MATRIX

%   SENSITIVITY (RESULTS class)  revision history:
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
aux=r.accuracy_class;
for i=1:numel(r)
    %% Act: Computing the sensitivity
   if any(strcmp(r(i).evaluation_type,{'binary_classification','semisupervised_learning','one_class_modeling'}))
        if numel(aux{i})==2
            res(i)=aux{i}(1);
        else
            res(i)=NaN;
             warning('sensitivity:IncompatibilityError','sensitivity (RESULTS class) is undifined for empty objects and multiclass_classification evaluation types.')
        end
    else
        res(i)=NaN;
        warning('sensitivity:IncompatibilityError',['sensitivity (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.'])
    end
end
else
%% Finale: Information regarding the measure
    res.evaluation_type={'binary_classification','semisupervised_learning','one_class_modeling'};
    res.optimal='greater';
end
end