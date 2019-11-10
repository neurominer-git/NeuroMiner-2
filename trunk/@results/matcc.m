function res =matcc(r)
%MATCC (RESULTS class) determines the MATCC (Matthew's correlation coefficient) 
%   of one or more evaluation experiments results from an array of RESULTS 
%   classs objects. RES=MATCC(R) computes the MCC of an array of RESULTS 
%   class objects (R) based on the evaluation results of each one of them. 
%
%   RES is a vector of the same size as R, each position of RES
%   represents the MATCC the correspondent component of R 
%   (scalar), evaluation processes that do not correspond to binary 
%   classification are treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which MATCC can be applied in
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
%   RES=MATCC(R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING CONFUSION_MATRIX

%   MATCC (RESULTS class)  revision history:
%   Date of creation: 24 November 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Getting the confusion matrices
info_crit=false;
if numel(r)==1
   if strcmp(r.evaluation,'info');
      info_crit=true;
   end
end
if ~info_crit
res=zeros(size(r));
confusion=r.confusion_matrix;
for i=1:numel(r)
    %% Act: Computing the MATCC
    if any(strcmp(r(i).evaluation_type,{'binary_classification','semisupervised_learning','one_class_modeling'}))
        if numel(r(i).classes)==2
            TP =confusion{i}(1,1);
            FP = confusion{i}(2,1);
            TN = confusion{i}(2,2);
            FN = confusion{i}(1,2);
            aux= (TP * TN - FP * FN) / sqrt( (TP+FP) * (TP+FN) * (TN+FP) * (TN+FN) );
            res(i)=aux;
        else
            res(i)=NaN;
            warning('MATCC:IncompatibilityError','MATCC (RESULTS class) is undifined for empty objects and multiclass_classification evaluation types.')
        end
    else
        res(i)=NaN;
        warning('MATCC:IncompatibilityError',['MATCC (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.'])
    end
end
else
%% Finale: Information regarding the measure
    res.evaluation_type={'binary_classification','semisupervised_learning','one_class_modeling'};
    res.optimal='greater';
end
end