function data_out=match_instances(data,covars,num_rep,maxselect)
% MATCH_INSTANCES (DATA_CLASS class) matches the instances of two
% data_class objects.
%
%   DATA_OUTPUT=MATCH_INSTANCES (DATA_INPUT,COVARS) Match the instances in
%   the data_class objects in DATA_INPUT with the script nk_MatchOne2One.m
%   and based on the covariates COVARS. The output of the function is then
%   an array of matched data_class objects. Important, the method threats
%   covariates as continuous variables, further development is necessary
%   to include categorical non binary variables in the matching process.
%   The algorithm will select from the data_class object with more examples
%   a subsect, with same number of examples as the data_object with less
%   examples. If the number of examples in the data_class objects is the
%   same nothing is done.
%
%   DATA_INPUT is a two element array of data_class objects with the two datasets
%   that should be matched.
%
%   COVARS is a cell of strings with the covariates that should be used for
%   the macthing.
%
%   DATA_OUTPUT is a two element data_class objects array with the matched samples.
%   The least represented sampled will not be changed while the most
%   represented sample will be reduced to the number of examples of the
%   least represented class.
%
%   DATA_OUTPUT=MATCH_INSTANCES (DATA_INPUT,COVARS,NUM_REP) Match the
%   instances in the data_class objects in DATA_INPUT with the script
%   nk_MatchOne2One.m based on the covariates COVARS and repeats the
%   process NUM_REP times. The output of the function is then a matrix of
%   matched data_class objects. Important, the method threats covariates as
%   continuous variables, further development is necessary to include
%   categorical non binary variables in the matching process. The algorithm
%   will select from the data_class object with more examples a subset,
%   with same number of examples as the data_object with less examples. If
%   the number of examples in the data_class objects is the same nothing is
%   done.
%
%   NUM_REP is a scalar representing the number of repetitions of the
%   matching process.
%
%   DATA_OUTPUT is a NUM_REPx2 data_class objects array with the matched samples.
%   The least represented sampled will not be changed while the most
%   represented sample will be reduced to the number of examples of the
%   least represented class.
%
%   DATA_OUTPUT=MATCH_INSTANCES (DATA_INPUT,COVARS,NUM_REP,MAX_SELECT)
%   Match MAX_SELECT instances of the first element of the array of
%   data_class object DATA_INPUT with the second element of DATA_INPUT with
%   the script nk_MatchOne2One.m based on the covariates COVARS and
%   repeates this procedure NUM_REP times. The output of the function is
%   then a matrix of matched data_class objects. Important, the method
%   threats covariates as continuous variables, further development is
%   necessary to include categorical non binary variables in the matching
%   process.
%
%   MAX_SELECT is a scalar corresponding to the the number of elements to
%   be select from the population that undergoes the matching. This number
%   should have values between 0 and the number of less examples in the
%   less represented class.


%   See also data_compare, data_class, data_prunner, data_selector.

%   MATCH_INSTANCES (data_class class) revision history:
%   Date of creation: 29 October 2015 beta (Helena)
%   Creator: Carlos Cabral
if nargin==1||nargin==2||nargin==3||nargin==4
    %% Overture: Input checking.
    if numel(data)~=2
        error('match_instances:Function_error','The dimension of the argument provided to function " match_instances (data_class class) " is not valid (number of elements should be 2))')
    end
    %checking covars
    covar_1=fieldnames(data(1).covariates);
    covar_2=fieldnames(data(2).covariates);
    covars_possible=intersect(covar_1,covar_2);
    if isempty(covars_possible)
        error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for data_class objects that share no covariates names.']);
    end
    if ~exist('covars','var')
        covars=covars_possible;
    elseif isempty(covars)
        covars=covars_possible;
    end
    if ~iscellstr(covars)
        error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for arguments of type ''' class(covars) ''' (Second input argument must be a  cell of strings).']);
    elseif isempty(covars)
        error('match_instances:Function_error','Undefined function '' match_instances (data_class class) '' for empty COVARS arguments');
    elseif numel(intersect(covars_possible,covars))~=numel(covars)
        error('match_instances:Function_error','Undefined function '' match_instances (data_class class) '' for COVARS variables that can not be found in the covariates property of both data_class elements.')
    end
    %checking num_rep
    if ~exist('num_rep','var')
        num_rep=1;
    elseif isempty(num_rep)
        num_rep=1;
    end
    if ~isnumeric(num_rep)
        error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for arguments of type ''' class(num_rep) ''' (Third input argument must be an integer scalar).']);
    elseif numel(num_rep)~=1
        error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for NUM_REP arguments with  ' num2str(numel(num_rep)) ' elements (Third input argument must be an integer scalar).']);
    elseif num_rep~=round(num_rep)&&~num_rep>0
        error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for non positive integer NUM_REP arguments ''' num2str(num_rep) ''' (Third input argument must be an integer scalar).']);
    end
    % check maxselect
    if exist('maxselect','var')
        if ~isnumeric(maxselect)
            error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for arguments of type ''' class(maxselect) ''' (Fourth input argument must be an integer scalar).']);
        elseif numel(maxselect)~=1
            error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for MAX_SELCtT arguments with  ' num2str(numel(maxselect)) ' elements (Fourth input argument must be an integer scalar).']);
        elseif maxselect~=round(maxselect)&&~maxselect>0;
            error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for positive non integer MAX_SELECT arguments ''' num2str(maxselect) ''' (Fourth input argument must be an integer scalar).']);
        end
        mode=false;
    else
        mode=true;
    end
    %% ACT 1: Assemble the covariates
    %size of the covariates
    [pos_a,pos_b]=data.data_reporter.number_of_examples;
    if mode
        % define the more/less represented population
        if pos_a>pos_b
            most_obj=1;
            less_obj=2;
        elseif pos_b>pos_a
            most_obj=2;
            less_obj=1;
        else
            data_out=data;
            warning('match_instances:Function_warning','The provided data_class elements have the same number of examples, nothing to do.')
            return
        end
    else
        most_obj=1;
        less_obj=2;
        mini=min([pos_a,pos_b]);
        if maxselect>mini
            error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for  MAX_SELECT arguments ''' num2str(maxselect) ''' bigger then the number of elements in the less represented population ''' num2str(mini) '''.']);
        end
    end
    % building the covariates matrices
    for i=1:numel(covars)
        if ~(isnumeric(data(1).covariates.(covars{i}))&&isnumeric(data(2).covariates.(covars{i})))
            error('match_instances:Function_error',['Undefined function '' match_instances (data_class class) '' for non numerical COVARS variables (' covars{i} ') in the covariates property of any of the data_class elements.'])
        end
        if i==1
            most_covars=data(most_obj).covariates.(covars{i});
            less_covars=data(less_obj).covariates.(covars{i});
        else
            most_covars=[most_covars data(most_obj).covariates.(covars{i})];
            less_covars=[less_covars data(less_obj).covariates.(covars{i})];
        end
    end
    %% ACT 2 : Applying the nk_matchOne2One
    if mode
        aux_pos=nk_MatchOne2One(most_covars,less_covars,data(most_obj).dbcode,num_rep);
    else
        aux_pos=nk_MatchOne2One(most_covars,less_covars,data(most_obj).dbcode,num_rep,maxselect);
    end
    %% Finale: Producing the matched data class element
    for i=1:num_rep
        aux_data=data;
        aux_data(most_obj)=aux_data(most_obj).data_selector(aux_pos(:,i));
        if i==1
            data_out=aux_data;
        else
            data_out=[data_out;aux_data];
        end
    end
else
    error('match_instances:Function_error','Function '' match_instances (data_class class) called with an invalid number of arguments. (1 or 2 argument should be provided)');
end
end
% =========================================================================
% FORMAT function [ID, SNAME, SVARS] = nk_MatchOne2One(S, T, Sid, repet)
% =========================================================================
% performs one-2-one matching of two groups where one group
% serves as target and one group as source
%
% Inputs:
% -------
% S = Source Matrix => [n rows x c columns], n = subjects, c = covariates
% T = Target Matrix => [m rows x c columns], m = subjects, c = covariates
% Sid = IDs of matched subjects
% repet = repetitions of matching
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Nikolaos Koutsouleris, 05/2011
function [ID, SNAME, SVARS] = nk_MatchOne2One(S, T, Sid, repet, maxsel)

nT = size(T,1);
nS = size(S,1);
ST = [S; T];
mY= size(ST,1); nY = size(ST,2);
minY = min(ST,[],1); % compute the columns' minimums
maxY = max(ST,[],1); % and the maxmimums

% Scale EACH FEATURE in the data to [0, 1]
if size(T,2)>=2
    sST = (ST - repmat(minY,mY,1)) * spdiags(1./(maxY-minY)', 0, nY, nY);
else
    sST = ST;
end

if ~exist('repet','var') || isempty(repet), repet = 1; end
ID = zeros(nT,repet);

if ~exist('maxsel','var'), maxsel = []; end

% Loop through all target subjects
SVARS = [];

for h=1:repet
    
    ind = 1:nS;
    sS = sST(1:nS,:) ; sT = sST(nS+1:end,:);
    
    for i=1:nT
        
        % Loop through source subjects
        
        sTi = sT(i,:); minsum = Inf;
        indperm = randperm(size(sS,1));
        for j=1:size(sS,1)
            sSj     = sS(indperm(j),:);
            
            % Compute absolute difference between current target and source
            % subject
            diffsum = sum(abs(sTi-sSj));
            
            if diffsum < minsum
                rj = indperm(j);
                minsum = diffsum;
            end
        end
        try
            fprintf('\nMinimum difference between target sample %g and source sample %g: %g',i, ind(rj), minsum)
        catch
            fprintf('\nerror')
        end
        for k=1:size(T,2)
            fprintf('\nVariable %g: Target: %g, Source: %g', k, T(i,k), S(ind(rj),k))
        end
        
        ID(i,h) = ind(rj); sS(rj,:) = []; ind(rj) = [];
        
    end
    
    fprintf('\n\nRemaining differences between groups:')
    
    for i=1:size(T,2)
        fprintf('\n\nVariable %g:',i)
        fprintf('\nTarget: %g, Source: %g', mean(T(:,i)), mean(S(ID(:,h),i)))
        P(h) = anova1([S(ID(:,h),i); T(:,i)],[ones(length(ID(:,h)),1); 2*ones(nT,1)],'off');
        fprintf('\nSignificance of difference: P=%0.3f',P)
    end
    
    if exist('Sid','var') && ~isempty(Sid) && nargout>=2
        if repet > 1
            SNAME{h} = char(Sid(ID(:,h)));
        else
            SNAME = char(Sid(ID));
        end
    else
        SNAME = [];
    end
    
    if nargout == 3
        if repet > 1
            SVARS = [SVARS S(ID(:,h),:)];
        else
            SVARS = S(ID,:);
        end
    end
end

%Select randomly among matched observation
if ~isempty(maxsel)
    selind = randperm(nT);
    selind = selind(1:maxsel);
    ID = ID(selind,:);
    if nargout == 2
        if repet > 1
            for h=1:repet
                SNAME{h} = SNAME{h}(selind);
            end
        else
            SNAME = SNAME(selind,:);
        end
    end
    if nargout == 3
        SVARS = SVARS(selind,:);
    end
    fprintf('\n\nSignificant differences across matching variables after random subsample selection')
    for i=1:size(T,2)
        fprintf('\n\nVariable %g:',i)
        fprintf('\nTarget: %g, Source: %g', mean(T(:,i)), mean(S(ID(:,h),i)))
        P(h) = anova1([S(ID(:,h),i); T(:,i)],[ones(length(ID(:,h)),1); 2*ones(nT,1)],'off');
        fprintf('\nSignificance of difference: P=%0.3f',P)
    end
    
end
end
