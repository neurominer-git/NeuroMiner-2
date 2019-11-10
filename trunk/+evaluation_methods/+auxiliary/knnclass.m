function [soft_label,hard_label] =knnclass(train,test,train_l,n,distance,p,labels)
%KNNCLASS applies the supervised classifier kNN.
%[soft_label,hard_label]=KNNCLASS(train,test,train_l,n,distance)
%returns 2 classification outputs resulting from the classification of the
%TEST set: SOFT_LABEL (the probability of each TEST example to belong to
%each onE of the classes) and the HARD_LABEL (the class with the higher
%support for each example in the TEST set).
%
% TRAIN and TEST are matrices provenient from a validation process applied
% to a data set.
%
% TRAIN_L  is a cell array corresponding to the TRAIN label vectors.
%
% N is a sclar representing the number of neighbours to consider in the
% classification process.
%
% DISTANCE to be used in the classification process, choices are:
%
%       'euclidean'   - Euclidean distance (default)
%       'seuclidean'  - Standardized Euclidean distance. Each coordinate
%                       difference between rows in X is scaled by dividing
%                       by the corresponding element of the standard
%                       deviation S=NANSTD(X). To specify another value for
%                       S, use D=PDIST(X,'seuclidean',S).
%       'cityblock'   - City Block distance
%       'minkowski'   - Minkowski distance. The default exponent is 2. To
%                       specify a different exponent, use
%                       D = PDIST(X,'minkowski',P), where the exponent P is
%                       a scalar positive value.
%       'chebychev'   - Chebychev distance (maximum coordinate difference)
%       'mahalanobis' - Mahalanobis distance, using the sample covariance
%                       of X as computed by NANCOV. To compute the distance
%                       with a different covariance, use
%                       D =  PDIST(X,'mahalanobis',C), where the matrix C
%                       is symmetric and positive definite.
%       'cosine'      - One minus the cosine of the included angle
%                       between observations (treated as vectors)
%       'correlation' - One minus the sample linear correlation between
%                       observations (treated as sequences of values).
%       'spearman'    - One minus the sample Spearman's rank correlation
%                       between observations (treated as sequences of values).
%       'hamming'     - Hamming distance, percentage of coordinates
%                       that differ
%       'jaccard'     - One minus the Jaccard coefficient, the
%                       percentage of nonzero coordinates that differ
%
% P (optional) is the exponent of the minkowski distance.
%   [soft_label,hard_label]=KNNCLASS(train,test,train_l,n,distance)

%   KNNCLASS  revision history:
%   Date of creation: 22 of October 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Initialization
nclass=numel(labels);
soft_label=zeros(size(test,1),nclass);
hard_label=zeros(size(test,1),1);
if ~exist('p','var')||isempty(p)
    p=2;
end
%% Act : Classification process
for i=1:size(test,1)
    
    %get the distance matrices
    if ~strcmp(distance,'minkowski')
        dif=pdist2(test(i,:),train,distance);
    else
        dif=pdist2(test(i,:),train,distance,p);
    end
    hip=zeros(1,n);
    voli=zeros(1,n);
    for k=1:n
        [gh,pos]=min(dif);
        voli(k)=1/(gh+eps);
        hip(k)=train_l(pos);
        dif(pos)=Inf;
    end
    kmax=zeros(1,nclass);
    final_decision=zeros(1,nclass);
    for m=1:nclass
        clo=hip==labels(m);
        final_decision(m)=sum(clo);
        kmax(m)=sum(voli.*clo);
    end
    soft_label(i,:)=kmax/(sum(voli)+eps);
    [maxi, pos]=max(final_decision);
    aux_maxi=final_decision==maxi;
    if sum(aux_maxi)>1
        aux_prob=soft_label(i,:).*aux_maxi;
        [~, pos]=max(aux_prob);
    end
    hard_label(i)=labels(pos);
end
%% Finale: No finale, sky is the limit
end