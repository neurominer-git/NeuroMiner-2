function data_out=data_fuser(data,mode)
% DATA_FUSER (DATA_CLASS class) fuses two data class objects.
%
%   DATA_OUTPUT=DATA_FUSER (DATA_INPUT,MODE) Fuses the data class objects
%   in DATA_INPUT according to the mode defined by MODE. If the "instances"
%   mode is selected the instances in all the DATA_INPUT elements will be
%   fused in the DATA_OUTPUT, DATA_FUSER looks for shared features and
%   covariates returning DATA_OUTPUT without instance redundancy and with
%   the maximum shared information selected, moreover DATA_FUSER also
%   checks for inconsistencies in the target values and covariates of
%   shared instances.If the "features"
%   mode is selected the features in all the DATA_INPUT elements will be
%   fused in the DATA_OUTPUT, DATA_FUSER looks for shared instances,
%   returning DATA_OUTPUT without features redundancy and with the maximum
%   shared information selected, moreover DATA_FUSER also checks for
%   inconsistencies in the feature groupinng of shared features.
%
%   DATA_INPUT is an array of data_class objects with the original data
%   that you wish to fuse.
%
%   DATA_OUTPUT is a data_class objects that contains the fused dataset.
%
%   MODE is an string defining the selection mode, two values are possible:
%   "instances" (default) and "features". 

%   See also data_compare, data_class, data_prunner, data_selector.

%   DATA_FUSER (data_class class) revision history:
%   Date of creation: 22 May 2014 beta (Helena)
%   Creator: Carlos Cabral
%
%   Date of Modification: 12 of August 2015
%   Modification: Integration of features mode, basic usage still available
%   Modifier: Carlos Cabral
if nargin==1||nargin==2
    if nargin==1
       mode='instances';
    end
    %% Overture: Input checking.
    if numel(data)<2
        error('data_fuser:Function_error','The dimension of the argument provided to function " data_fuser (data_class class) " is not valid (number of elements should be >1))')
    end
    if ~ischar(mode)
        error('data_fuser:Function_error',['Undefined function '' data_fuser (data_class class) '' arguments of type ''' class(mode) ''' (Third input argument must be a string).']);
    elseif ~any(strcmp({'instances','features'},mode))
        error('data_fuser:Function_error',['Undefined function '' data_fuser (data_class class) '' for mode ''' mode ''' (Possible modes are "instances" and "features").'])
    end
    %% ACT 1: Check the data compatibility for the selected mode
    try rpt=data_compare(data);
    catch err
        rethrow(err);
    end
    rpt=rpt.(mode);
    if ~rpt.flag
        error('data_fuser:Function_error',['The data_class elements provided to function " data_fuser (data_class class) " are not compatible for fusing : ' rpt.descriptor '.'])
    end
    %% Act: 2: Apply Prunning if necessary as determined by data_compare
    try data=data_prunner(data,rpt,mode);
    catch err
        rethrow(err);
    end
    %% ACT: 3: Fusing the datasets
    %initializing the data_class parameters
    if strcmp('instances',mode)
        type_ini=data(1).type;
        data_ini=data(1).data;
        covariates_ini=data(1).covariates;
        covariates_names=fieldnames(covariates_ini);
        target_values_ini=data(1).target_values;
        descriptor_ini=[ data(1).descriptor '_instances' num2str(size(data(1).data,2))];
        dbcode_ini=data(1).dbcode;
        evaluation_type=data(1).evaluation_type;
        features_descriptor_ini=data(1).features_descriptor;
        feature_grouping_ini=data(1).feature_grouping;
        for i=2:numel(data)
            data_ini=cat(1,data_ini,data(i).data);
            descriptor_ini=[descriptor_ini ' | ' data(i).descriptor '_instances' num2str(size(data(i).data,1))];
            target_values_ini=cat(1,target_values_ini,data(i).target_values);
            dbcode_ini=cat(1,dbcode_ini,data(i).dbcode);
            for j=1:numel(covariates_names)
                covariates_ini.(covariates_names{j})=cat(1,covariates_ini.(covariates_names{j}),data(i).covariates.(covariates_names{j}));
            end
        end
    else
        type_ini=data(1).type;
        data_ini=data(1).data;
        covariates_ini=data(1).covariates;
        target_values_ini=data(1).target_values;
        descriptor_ini=[ data(1).descriptor '_features' num2str(size(data(1).data,2))];
        dbcode_ini=data(1).dbcode;
        evaluation_type=data(1).evaluation_type;
        features_descriptor_ini=data(1).features_descriptor;
        feature_grouping_ini=data(1).feature_grouping;
        for i=2:numel(data)
            data_ini=cat(2,data_ini,data(i).data);
            type_ini=[ type_ini ' | ' data(i).type];
            descriptor_ini=[ descriptor_ini ' | ' data(i).descriptor '_features' num2str(size(data(i).data,1))];
            features_descriptor_ini=cat(2,features_descriptor_ini,data(i).features_descriptor);
            feature_grouping_ini=cat(2,feature_grouping_ini,data(i).feature_grouping);
        end
    end
    %% Finale: Producing the fused data class element
    try  data_out=data_class(data_ini,type_ini,dbcode_ini,covariates_ini,target_values_ini,evaluation_type,features_descriptor_ini,descriptor_ini,feature_grouping_ini);
    catch err
        rethrow(err);
    end
else
    error('data_fuser:Function_error','Function '' data_fuser (data_class class) called with an invalid number of arguments. (1 or 2 argument should be provided)');
end
end