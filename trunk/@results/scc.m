function res =scc(r)
%SCC (RESULTS class) determines the SCC (Squared Correlation Coefficient)
%   of one or more regression experiments results from an array of RESULTS 
%   classs objects. RES=SCC (R) computes the SCC of an array of RESULTS 
%   class objects (R) based on the evaluation results of each one of them. 
%
%   RES is a vector of the same size as R, each position of RES
%   represents the SCC of the correspondent component of R 
%   (scalar), evaluation processes that do not correspond to regression are
%   treated as NaN.
%
%   In the very particular case in which R is a single RESULTS class object
%   with an evaluation descriptor string 'info' the program enters in
%   reporting mode and RES is in this case a structure with three fields:
%   - evaluation_type - evaluation type to which SCC can be applied in
%   asccordance with NM2 standard, see data_class documentation
%   - multiclass - TRUE for multiclass methods, FALSE for methods only
%   applicable to binary experiments.
%   - optimal - string indicating the optimal direction of the criteria,
%   possible values are 'less' and 'greater'. Eg. For classification
%   asccuracy the greater the value the better while for classification
%   error the inverse is true, the less the better.
%   To automatically obtain the reporting structure of a performance methed
%   use the function reporter. reporters('name of the function').
%
%   RES=SCC (R)
%   See also RESULTS, EVALUATION, ENSEMBLE_LEARNING

%   SCC (RESULTS class)  revision history:
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
aux_cc=r.cc;
for i=1:numel(r)
    %% Act: Computing the SCC
    
        if ~isnan(aux_cc(i))               
           res(i)=aux_cc(i)^2;
        else
            res(i)=NaN;
            warning('SCC:IncompatibilityError',['SCC (RESULTS class) is undifined for empty objects and ' r(i).evaluation_type ' results.']')
        end

end
else
%% Finale: Information regarding the measure
    res.evaluation_type={'regression'};
    res.optimal='less';
end
end