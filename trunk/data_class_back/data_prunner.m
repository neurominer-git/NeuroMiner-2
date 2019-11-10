function data=data_prunner(data,rpt,mode)
% DATA_PRUNNER (DATA_CLASS class) prunnes an array of data_class objects,
% based in a report class object provided by the data_compare method,
% returning an array of data_class objects ready to fuse.
%
%   DATA_OUTPUT=DATA_PRUNNER(DATA_INPUT,RPT,MODE) Prunnes the data class
%   objects in DATA_INPUT according with the information provided by RPT so
%   the DATA_OUTPUT is ready for fusion in the mode defined by MODE.
%   DATA_PRUNNER also asures that there is no redundancy on the data the
%   maximal ammount of compatible information is kept.
%
%   DATA_INPUT is an array of data_class objects with the original data
%   that you wish to fuse.
%
%   DATA_OUTPUT is an array of  data_class objects with ready to fuse data.
%
%   RPT is a report class object generated by the data_class method
%   "data_compare".
%
%   MODE is an string defining the selection mode, two values are possible:
%   "instances" (default) and "features". 

%   See also data_compare, data_class, report, data_selector, data_sorter.

%   DATA_PRUNNER (data_class class) revision history:
%   Date of creation: 14 May 2014 beta (Helena)
%   Creator: Carlos Cabral
%
%   Date of Modification: 12 of August 2015
%   Modification: Integration of features mode, general redesign
%   Modifier: Carlos Cabral

if nargin==3
    %% Overture: Input checking.
    if numel(data)<2
        error('data_prunner:Function_error','The dimension of the argument provided to function " data_prunner (data_class class) " is not valid (number of elements should be >1))')
    elseif sum(isempty(data))==numel(data)
        error('data_prunner:Function_error','Empty data_class argument provided to function " data_prunner (data_class class) " ')
    end
    if ~isa(rpt,'report')
        error('data_prunner:Function_error',['Undefined function '' data_prunner (data_class class) '' arguments of type ''' class(rpt) ''' (Third input argument must be a report class object).']);
    elseif ~rpt.flag
        error('data_prunner:Function_error','Undefined function '' data_prunner (data_class class) '' for reports with a false flag property).')
    end
    if ~ischar(mode)
        error('data_prunner:Function_error',['Undefined function '' data_prunner (data_class class) '' arguments of type ''' class(mode) ''' (Third input argument must be a string).']);
    elseif ~any(strcmp({'instances','features'},mode))
        error('data_prunner:Function_error',['Undefined function '' data_prunner (data_class class) '' for mode ''' mode ''' (Possible modes are "instances" and "features").'])
    end
    %% ACT 1: Determining the mode 
    descriptor=rpt.descriptor;
    if ~isempty(strfind(descriptor,'purged'))||strcmp(descriptor,'ready')
        if ~isempty(strfind(descriptor,'covariates'))
            covariates_all=fieldnames(data(1).covariates);
            for i=2:numel(data)
                covariates_all=cat(2,covariates_all,fieldnames(data(i).covariates));
            end
            [covariates_unique,~,code_grouping]=unique(covariates_all);
            covariates_count=hist(code_grouping,1:numel(covariates_unique));
            covariates_shared=covariates_unique(covariates_count==numel(data));
        else
            covariates_shared=fieldnames(data(1).covariates);
        end
        if ~isempty(strfind(descriptor,'instances'))
            dbcodes_all=data(1).dbcode;
            for i=2:numel(data)
                dbcodes_all=cat(2,dbcodes_all,data(i).dbcode);
            end
            [dbcodes_unique,~,code_grouping]=unique(dbcodes_all);
            dbcodes_count=hist(code_grouping,1:numel(dbcodes_unique));
            dbcodes_shared=dbcodes_unique(dbcodes_count==numel(data));
        else
            dbcodes_shared=data(1).dbcode;
        end
        if ~isempty(strfind(descriptor,'features'))
            features_descriptor=data(1).features_descriptor;
            for i=2:numel(data)
                features_descriptor=cat(2,features_descriptor,data(i).features_descriptor);
            end
            [features_unique,~,code_grouping]=unique(features_descriptor);
            features_count=hist(code_grouping,1:numel(features_unique));
            features_shared=features_unique(features_count==numel(data));
        else
            features_shared=data(1).features_descriptor;
        end
    else
        error('data_prunner:Function_error','Undefined function '' data_prunner (data_class class) '' for reports that are not generated by data_compare method).')
    end
    %% Act: 2 "instances" mode
    if strcmp('instances',mode)
       dbcode_ini=data(1).dbcode;
       for i=1:numel(data)
           % getting the features in the correct order
           featvector=zeros(1,numel(features_shared));
           for j=1:numel(features_shared)
               featvector(j)=find(strcmp(data(i).features_descriptor,features_shared{j}));
           end
           instancevector=zeros(1,numel(data(i).dbcode));
           % getting the non repeated instances
           if i~=1
               for j=1:numel(data(i).dbcode)
                   instancevector(j)=~any(strcmp(dbcode_ini,data(i).dbcode{j}));
               end
               instancevector=instancevector>0;
           else
               instancevector=ones(1,numel(data(i).dbcode))>0;
           end
           % prunning redundant instances
           data(i)=data_selector(data(i),instancevector,'instances');
           % pruning non shared features and reorder them
           data(i)=data_sorter(data(i),featvector,'features');
           %pruning non shared covariates
           aux_covar=fieldnames(data(i).covariates);
           for j=1:numel(aux_covar)
               if ~any(strcmp(covariates_shared,aux_covar{j}))
                  data(i).covariates=rmfield(data(i).covariates,aux_covar{j});
               end
           end
       end
    end
    %% Act: 3 "features" mode
    if strcmp('features',mode)
        % defining the final instance set, shared by all the datasets
        features_descriptor_ini=data(1).features_descriptor;
        for i=1:numel(data)
            % getting the features in the correct order
            instancevector=zeros(1,numel(dbcodes_shared));
            for j=1:numel(dbcodes_shared)
                instancevector(i)=find(strcmp(data(i).dbcodes,dbcodes_shared{j}));
            end
            featvector=zeros(1,numel(data(i).dbcodes));
            % getting the non repeated instances
            if i~=1
                for j=1:numel(data(i).features_descriptor)
                    featvector(j)=~any(strcmp(features_descriptor_ini,data(i).feature_descriptor{j}));
                end
                featvector=featvector>0;
            else
                featvector=ones(1,numel(data(i).dbcodes))>0;
            end
            % prunning redundant features
            data(i)=data_selector(data(i),featvector,'features');
            % pruning non shared instances and reorder them
            data(i)=data_sorter(data(i),instancevector,'instances');
            %pruning non shared covariates
            aux_covar=fieldnames(data(i).covariates);
            for j=1:numel(aux_covar)
                if ~any(strcmp(covariates_shared,aux_covar{j}))
                    data(i).covariates=rmfield(data(i).covariates,aux_covar{j});
                end
            end
        end
    end
    %% FINALE: No finale, the sky is the limit!
else
    error('data_prunner:Function_error','Function '' data_prunner (data_class class) called with an invalid number of arguments. (3 argument should be provided)');
end
end