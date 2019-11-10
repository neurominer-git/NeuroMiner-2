function rpt=data_compare(data)
% DATA_COMPARE (DATA_CLASS class)
%   DATA_COMPARE (DATA_CLASS class) function receives a data_class class
%   array with at least 2 elements and compares them producing report with
%   information relative to the compabilitiy of the two datasets.
%
%   RPT=DATA_COMPARE(DATA)
%   DATA_COMPARE compares the single data_class elements in the data_class
%   array DATA and outputs the result of the comparison to RPT.
%
%   DATA is an array of data_class objects.
%
%   RPT is a structure with two fields: instances and examples. Each field
%   contains a report class element that summarizes the compatibility the
%   the elements in DATA to be fused in the feature dimension (increasing
%   the feature dimensionality) or in the instance dimension (increasing
%   the instance dimensionality). For each one of the two fusion modes
%   there are four possible results, ready for fusing (report.flag=true, 
%   report.descriptor='ready', ready for fusing with loss of information(
%   report.flag=true, report.descriptor='purge_features'), ready for fusion
%   with redundanct information (report.flag=true, report.descriptor=
%   'redundanct' and finally not suitable for fusing (report.flag=false).

%   See also report, data_class, report, fuser.

%   DATA_COMPARE (DATA_CLASS class) revision history:
%   Date of creation: 13 May 2014 beta (Helena)
%   Creator: Carlos Cabral

%   Date of Modification: 10 of August 2015
%   Modification: Integration of the concepts of features description,
%   feature_grouping and evaluation_type
%   Modifier: Carlos Cabral
if nargin==1
    %% Overture: Input checking.
    if numel(data)<2
        error('data_compare:Input_error','The dimension of the argument provided to function " data_compare (data_class class) " is not valid (number of elements should be >1))')
    elseif sum(isempty(data))==numel(data)
        error('data_compare:Input_error','Empty data_class argument provided to function " data_compare (data_class class) " ')
    end
    if ~islogical(mode)
        error('data_selector:Function_error',['Undefined function '' data_selector (data_class class) '' arguments of type ''' class(mode) ''' (Third input argument must be a string).']);
    elseif ~any(strcmp({'instances','features'},mode))
        error('data_selector:Function_error',['Undefined function '' data_selector (data_class class) '' for mode ''' mode ''' (Possible modes are "instances" and "features").'])
    end
    if isnumeric(indic)||islogical(indic)
        if isempty(indic)
            error('data_selector:Function_error','Empty indices argument provided to function " data_selector (data_class class) " ')
        elseif numel(size(indic))~=2||sum(size(indic)==1)==0
            error('data_selector:Function_error',['Invalid dimensions of the indices argument provided to function " data_selector (data_class object) "  ' num2str(size(indic)) ''])
        end
    else
        error('data_selector:Function_error',['Undefined function '' data_selector (data_class class) '' arguments of type ''' class(indic) ''' (Second input argument must be numeric or logical).']);
    end
    %% ACT 1: Get the information of all the datasets in data
    dbcodes_all=data(1).dbcode;
    covariates_all=fieldnames(data(1).covariates);
    target_values_all=data(1).target_values;
    evaluation_type={data(1).evaluation_type};
    features_descriptor=data(1).features_descriptor;
    feature_grouping=data(1).feature_grouping;
    for i=2:numel(data)
        dbcodes_all=cat(1,dbcodes_all,data(i).dbcode);
        covariates_all=cat(1,covariates_all,fieldnames(data(i).covariates));
        target_values_all=cat(1,target_values_all,data(i).target_values);
        evaluation_type=cat(1,evaluation_type,{data(i).evaluation_type});
        features_descriptor=cat(2,features_descriptor,data(i).features_descriptor);
        feature_grouping=cat(2,feature_grouping,data(i).feature_grouping);
    end
    %% ACT 2: Check if the evaluation type is the same, otherwise fusion is not possible
    if numel(unique(evaluation_type))~=1
       descriptor='incompatible - evaluation_type';
       rpt.features=report('data_compare',report,false,descriptor);
       rpt.instances=report('data_compare',report,false,descriptor);
       return
    end
    %% ACT 3: Check the dbcodes present
    %check which elements are present in all datasets
    %dbcodes
    [dbcodes_unique,~,code_grouping]=unique(dbcodes_all);
    dbcodes_count=hist(code_grouping,1:numel(dbcodes_unique));
    dbcodes_shared=dbcodes_unique(dbcodes_count==numel(data));
    %% ACT 4: Check the features present
    % check which features overlap
    [features_unique,~,code_grouping]=unique(features_descriptor);
    features_count=hist(code_grouping,1:numel(features_unique));
    features_shared=features_unique(features_count==numel(data));
    %% ACT 5: Check the overlap between shared dbcodes target values
    if ~isempty(dbcodes_shared)
        decision=zeros(1,numel(dbcodes_shared));
        for i=1:numel(dbcodes_shared)
            aux_pos=strcmp(dbcodes_all,dbcodes_shared{i});
            aux_vals=target_values_all(aux_pos);
            ref_val=aux_vals{1};
            decision(i)=numel(unique(cellfun(@isequal,ref_val,aux_vals)));
        end
        if numel(unique(decision))~=1
            descriptor='incompatible - target_values';
            rpt.features=report('data_compare',report,false,descriptor);
            rpt.instances=report('data_compare',report,false,descriptor);
            return
        end
    end
    %% ACT 6: Check the overlap between covariates of shared dbcodes.
    flag_originial_covariates=~isempty(covariates_all);
    if flag_originial_covariates
        [covariates_unique,~,code_grouping]=unique(covariates_all);
        covariates_count=hist(code_grouping,1:numel(covariates_unique));
        covariates_shared=covariates_unique(covariates_count==numel(data));
        flag_final_covariates=~isempty(covariates_shared);
    else
        flag_final_covariates=false;
    end
    if ~isempty(dbcodes_shared)
        if flag_final_covariates
            covariate_flag=true;
            for i=1:numel(dbcodes_shared)
                aux_val=dbcodes_shared{i};
                for j=1:numel(data)
                    data_db=strcmp(data(j).dbcodes,aux_val);
                    for k=1:numel(covariates_shared)
                        if j==1
                            aux_struct.(covariates_shared{k})=data(j).covariates.(covariates_shared{k})(data_db);
                        else
                            if ~isequal(aux_struct.(covariates_shared{k}),data(j).covariates.(covariates_shared{k})(data_db))
                                covariate_flag=false;
                            end
                        end
                    end
                end
            end
            if covariate_flag
                descriptor='incompatible - covariates';
                rpt.features=report('data_compare',report,false,descriptor);
                rpt.instances=report('data_compare',report,false,descriptor);
                return
            end
        end
    end
    %% ACT 7: Feature grouping consitency between shared features
    if ~isempty(features_shared)
        decision=zeros(1,numel(features_shared));
        for i=1:numel(features_shared)
            aux_pos=strcmp(features_descriptor,features_shared{i});
            decision(i)=numel(feature_grouping(aux_pos));
        end
        if numel(unique(decision))~=1
            descriptor='incompatible - feature_grouping';
            rpt.features=report('data_compare',report,false,descriptor);
            rpt.instances=report('data_compare',report,false,descriptor);
            return
        end
    end  
    %% Finale: Deciding the flag,the descriptor and producing the report
    % feature dimension
    if numel(dbcodes_shared)<2
        fuse_flag=false;
        descriptor='incompatible - no shared dbcodes';
    else
        fuse_flag=true;
        %check if the dbcodes
        flag_dbcode=numel(dbcodes_shared)==numel(dbcodes_unique);
        %check if all covariates are present
        flag_covariates=numel(covariates_shared)==numel(covariates_unique);
        %check if there is no feature overlap
        flag_features=isempty(features_shared);
        
        if flag_covariates&&flag_dbcode&&flag_features
            descriptor='ready';
        else
            descriptor='purged ';
            if ~flag_covariates
                descriptor=[descriptor ' covariates'];
            end
            if ~flag_dbcode
                descriptor=[descriptor ' instances'];
            end
            if ~flag_features
                descriptor=[descriptor ' features'];
            end
        end

    end
    rpt.features=report('data_compare',report,fuse_flag,descriptor);
    % instance dimension
    if numel(features_shared)<2
        fuse_flag=false;
        descriptor='incompatible - no shared features';
    else
        fuse_flag=true;
        %check the features
        flag_features=numel(features_shared)==numel(features_unique);
        %check if there is no subject overlap
        flag_dbcode=isempty(dbcodes_shared);
        %check if the same covariates are present in all the data_sets
        flag_covariates=numel(covariates_shared)==numel(covariates_unique);
        if flag_features&&flag_dbcode
            descriptor='ready';
        else
            descriptor='purged ';
            if ~flag_dbcode
                descriptor=[descriptor ' instances'];
            end
            if ~flag_features
                descriptor=[descriptor ' features'];
            end
             if ~flag_covariates
                descriptor=[descriptor ' covariates'];
            end
        end
    end
    rpt.instances=report('data_compare',report,fuse_flag,descriptor);
else
    error('data_compare:Input_error','Function '' data_compare (data_class class) called with an invalid number of arguments. (1 argument should be provided)');
end
end