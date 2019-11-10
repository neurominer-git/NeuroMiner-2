function res =mse(r)
%MSE (RESULTS class) determines the MSE (Mean Standard Error of Regression)
%   of one or more regression experiments results from an array of RESULTS
%   classs objects. RES=MSE (R) computes the MSE of an array of RESULTS
%   class objects (R) based on the evaluation results of each one of them.

%   RES is a vector of the same size as R, each position of RES
%   represents the MSE of the correspondent component of R
%   (scalar), evaluation processes that do not correspond to regression are
%   treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which MSE can be applied in
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
%   RES=MSE (R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING

%   MSE (RESULTS class)  revision history:
%   Date of creation: 24 November 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Initialization
info_crit=false;
if numel(r)==1
    if strcmp(r.descriptor,'info');
        info_crit=true;
    end
end
if ~info_crit
    res=zeros(size(r));
    for i=1:numel(r)
        %% Act: Computing the MSE
        if strcmp(r(i).evaluation_type,'regression')
            expected=cell2mat(r(i).target_values);
            predicted=cell2mat(r(i).hard_labels);
            total = size(expected,1);
            sumerr = sum((predicted-expected).*(predicted-expected));
            res(i)=sumerr/total;
        else
            res(i)=NaN;
            warning('MSE:IncompatibilityError',['MSE (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.']')
        end
    end
else
    %% Finale: Information regarding the measure
    res.evaluation_type={'regression'};
    res.optimal='less';
end
end