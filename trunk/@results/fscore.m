function res =fscore(r,beta)
%FSCORE(RESULTS class) determines the fscore measure of one or more evaluation
%experiments results from an array of RESULTS classs objects.
%
%   RES=FSCORE(R,BETA) computes the fscore measure of an array of RESULTS class
%   objects (R) based on the CONFUSION_MATRIX of each one of them and the
%   BETA parameter, in case BETA is not provided BETA=1 will be used.
%   RES is a vector of the same size as R, each position of RES
%   represents the fscore measure of the correspondent element. 
%   Evaluation processes that do not correspond to evaluation are treated 
%   as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which FSCORE can be applied in
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
%   RES=FSCORE(R,BETA)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING CONFUSION_MATRIX

%   FSCORE(RESULTS class)  revision history:
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
if ~exist('beta','var')
   beta=1;
else
    beta=beta*beta;
end
for i=1:numel(r)
    %% Act: Computing the fscore measure
    
    if any(strcmp(r(i).evaluation_type,{'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'}))
        if numel(r(i).classes)==2
            precision=r(i).precision;
            recall=r(i).sensitivity;
        else
            precision=r(i).precision;
            recall=mean(r(i).accuracy_class);
        end
        res(i)=((1 + beta) *precision*recall)/(beta*(precision+recall));
    else
        res(i)=NaN;
        warning('fscore:IncompatibilityError',['fscore (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.'])
    end
end
else
%% Finale: Information regarding the measure
    res.evaluation_type={'binary_classification','multiclass_classification','semisupervised_learning','one_class_modeling'};
    res.optimal='greater';
end
end