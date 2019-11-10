function profile=profiler(data)
% PROFILER (DATA_CLASS class) performs the a characterization of the data
% in a data_class element or array.
%
%   PROFILE=PROFILER (DATA_INPUT) performs a set of operations aiming to
%   characterize the data before further analysis. These operations are
%   divided in 4 types.
%   1 - Feature/Label Interaction
%       1.1 - Correlation between features and label (Spearman)
%       1.2 - Correlation between features and label (Pearson)
%       1.3 - MutualInformation between features and label (needs mi toolbox in the path)
%       1.4 - Mean and STD of each feature for each study group. For
%       "unsupervised learning"  problems the overall mean is returned and
%       for "regression" problems the label is splitted in 10 bins and the
%       the reporting is done for each one of these 10 bins.
%   2 - Feature/Feature Interaction
%       2.1 - Correlation matrix between features (Spearman)
%       2.2 - Correlation matrix between features (Pearson)
%       2.3 - MutualInformation between features (needs mi toolbox in the
%       path)
%   3 - Feature/Covariate Interaction
%       3.1 - Correlation between features and covariates (Spearman)
%       3.2 - Correlation between features and covariates (Pearson)
%       3.3 - MutualInformation betweenn features and covariates(needs mi toolbox in the path)
%       3.4 - Interaction Information between feature, label and covariate
%       (needs mi toolbox in the path), not applicable to "unsupervised
%       learning" problems.
%   4 - Instance/Instance interaction
%       4.1 - Correlation matrix between instances (Spearman)
%       4.2 - Correlation matrix between instances (Pearson)
%       4.3 - MutualInformation between instances (needs mi toolbox in the
%       path)
%
%   DATA_INPUT is a data_class array of objects.
%
%   PROFILE is a structure or array of structures with as many elements as
%   DATA_INPUT. The fields and subfields of each element mimic the
%   organization structure described in the this function documentation.
%
%   See also data_compare, data_class, report, data_fuser, data_reporter

%   PROFILER (data_class class) revision history:
%   Date of creation: 10 February 2015 beta (Helena)
%   Creator: Carlos Cabral
%% Overture: Input checking
if ~nargin==1
    error('profiler:Function_error','Function '' profiler (data_class class) called with an invalid number of arguments. (1 argument should be provided)');
end
%check if the information package is available
if isempty(which('information'))||isempty('condinformation')
   flag_info=false;
   warning('profiler:Function_error','No information package found on the path. Skyping the information therory measures');
else
   flag_info=true;
end
for i=1:numel(data)
    current_data=data(i);
    if isinteger(current_data.data(1))
        mod_data='discrete';
    else
        mod_data='continuous';
    end
    % case that the label carries no information
    if strcmp(current_data.evaluation_type,'unsupervised_learning')||strcmp(current_data.evaluation_type,'hierarchical')||strcmp(current_data.evaluation_type,'multi_labelled')||strcmp(current_data.evaluation_type,'semisupervised_learning')
       mod_eval=true;
    elseif all((cellfun(@(x) isequal(x,current_data.target_values{1}),current_data.target_values)))
        mod_eval=true;
    else
        mod_eval=false;
    end
    %% ACT: 1: Feature Label interaction
    if mod_eval
        % estimating mean and std
        for j=1:numel(current_data.features_descriptor)
            x=current_data.data(j,:);
            mean_std=nan(numel(current_data.features_descriptor),2);
            mean_std(j,1)=mean(x);
            mean_std(j,2)=std(x);
        end
        profile(i).feature_label.spearman_correlation=[];
        profile(i).feature_label.pearson_correlation=[];
        profile(i).feature_label.mutual_information=[];
        profile(i).feature_label.mean_std.mean_std=mean_std;
        profile(i).feature_label.mean_std.groups=[];
    else
        label=cell2mat(current_data.target_values);% extracting the label
        %defining the structure and the binarization of the label based on
        %the type of evaluation predefined.
        minL=min(label);
        maxL=max(label);
        deltaL=(maxL-minL)/(length(label)-1);
        if strcmp(current_data.evaluation_type,'regression')
            ncellL=ceil(length(L)^(1/3));
            descriptorL=[minL-deltaL/2,maxL+deltaL/2,ncellL];
            [~,groups,places]=histcounts(label,10);
            groups=groups+((groups(2)-groups(1))/2);
            groups=groups(1:end-1);
        else
            descriptorL=[minL,maxL,0];
            [groups,~,places]=unique(label);
        end
        % initializing variables
        aux_pearson=nan(1,numel(current_data.features_descriptor));
        aux_spearman=nan(1,numel(current_data.features_descriptor));
        aux_mi=nan(1,numel(current_data.features_descriptor));
        mean_std=nan(numel(current_data.features_descriptor),2,numel(groups));
        for j=1:numel(current_data.features_descriptor)
            %defining the structure and the binarization of the feature based on the data type.
            x=current_data.data(:,j);
            minx=min(x);
            maxx=max(x);
            deltax=(maxx-minx)/(length(x)-1);
            if strcmp(mod_data,'continuous')
                ncellx=ceil(length(x)^(1/3));
                descriptorx=[minx-deltax/2,maxx+deltax/2,ncellx];
            else
                descriptorx=[minx,maxx,0];
            end
            % Spearman Correlation
            aux_spearman(j)=corr(x,label,'type','Spearman');
            % Pearson Correlation
            aux_pearson(j)=corr(x,label,'type','Pearson');
            % Mutual Information
            if flag_info
            aux_mi(j)=information(x',label',[descriptorx;descriptorL]);
            end
            % Mean and Std across groups
            for k=1:numel(groups)
                mean_std(j,1,k)=mean(x(places==k));
                mean_std(j,2,k)=std(x(places==k));
            end
        end
        profile(i).feature_label.spearman_correlation=aux_spearman;
        profile(i).feature_label.pearson_correlation=aux_pearson;
        profile(i).feature_label.mutual_information=aux_mi;
        profile(i).feature_label.mean_std.mean_std=mean_std;
        profile(i).feature_label.mean_std.groups=groups; %#ok<*AGROW>
    end
    %% ACT 2: Feature/Feature interaction
    %initializing the variables
    aux_pearson=nan(numel(current_data.features_descriptor));
    aux_spearman=nan(numel(current_data.features_descriptor));
    aux_mi=nan(numel(current_data.features_descriptor));
    for j=1:numel(current_data.features_descriptor)
         %defining the structure and the binarization of the feature based on the data type.
        x=current_data.data(:,j);
        minx=min(x);
        maxx=max(x);
        deltax=(maxx-minx)/(length(x)-1);
        if strcmp(mod_data,'continuous')
            ncellx=ceil(length(x)^(1/3));
            descriptorx=[minx-deltax/2,maxx+deltax/2,ncellx];
        else
            descriptorx=[minx,maxx,0];
        end
        for k=j:numel(current_data.features_descriptor)
             %defining the structure and the binarization of the feature based on the data type.
            y=current_data.data(:,k);
            miny=min(y);
            maxy=max(y);
            deltay=(maxy-miny)/(length(y)-1);
            if strcmp(mod_data,'continuous')
                ncelly=ceil(length(y)^(1/3));
                descriptory=[miny-deltay/2,maxy+deltay/2,ncelly];
            else
                descriptory=[miny,maxy,0];
            end
             % Spearman Correlation
            aux_spearman(j,k)=corr(x,y,'type','Spearman');
            % Pearson Correlation
            aux_pearson(j,k)=corr(x,y,'type','Pearson');
            % Mutual Information 
            if flag_info
                aux_mi(j,k)=information(x',y',[descriptorx;descriptory]);
            end
        end
    end
    profile(i).feature_feature.spearman_correlation=aux_spearman;
    profile(i).feature_feature.pearson_correlation=aux_pearson;
    profile(i).feature_feature.mutual_information=aux_mi;
    %% ACT 3: Feature/Covariate interaction
    %defining the structure and the binarization of the covariates based on the data type.
    cov_names=fieldnames(current_data.covariates);
    descriptorc=zeros(numel(cov_names),3);
    aux_numeric=true(size(cov_names));
    for j=1:numel(cov_names)
        if isinteger(current_data.covariates.(cov_names{j})(1))||islogical(current_data.covariates.(cov_names{j})(1)) 
            mod_cov='discrete';
        elseif isfloat(current_data.covariates.(cov_names{j})(1))
            mod_cov='continuous';
        else
            aux_numeric(j)=false;
        end
        if aux_numeric(j)
        c=current_data.covariates.(cov_names{j});
        minc=min(c);
        maxc=max(c);
        deltac=(maxc-minc)/(length(c)-1);
        if strcmp(mod_cov,'continuous')
            ncellc=ceil(length(c)^(1/3));
            descriptorc(j,:)=[minc-deltac/2,maxc+deltac/2,ncellc];
        else
            descriptorc(j,:)=[minc,maxc,0];
        end
        end
    end
    cov_names=cov_names(aux_numeric);
    descriptorc=descriptorc(aux_numeric,:);
    if ~isempty(cov_names)
    if mod_eval% case the label carries no information
        profile(i).feature_covariates.interaction=[];
    else
        
        label=cell2mat(current_data.target_values);%extracting the label
        %defining the structure and the binarization of the label based on
        %the type of evaluation predefined.
        minL=min(label);
        maxL=max(label);
        deltaL=(maxL-minL)/(length(label)-1);
        if strcmp(current_data.evaluation_type,'regression')
            ncellL=ceil(length(L)^(1/3));
            descriptorL=[minL-deltaL/2,maxL+deltaL/2,ncellL];
        else
            descriptorL=[minL,maxL,0];
        end
    end
    % initializing vectors
    aux_pearson=nan(numel(cov_names),numel(current_data.features_descriptor));
    aux_spearman=nan(numel(cov_names),numel(current_data.features_descriptor));
    aux_mi=nan(numel(cov_names),numel(current_data.features_descriptor));
    aux_cmi=nan(numel(cov_names),numel(current_data.features_descriptor));
    for j=1:numel(current_data.features_descriptor)
        %defining the structure and the binarization of the feature based on the data type.
        x=current_data.data(:,j);
        minx=min(x);
        maxx=max(x);
        deltax=(maxx-minx)/(length(x)-1);
        if strcmp(mod_data,'continuous')
            ncellx=ceil(length(x)^(1/3));
            descriptorx=[minx-deltax/2,maxx+deltax/2,ncellx];
        else
            descriptorx=[minx,maxx,0];
        end
        for k=1:numel(cov_names)
            % Spearman Correlation
            aux_spearman(k,j)=corr(x,current_data.covariates.(cov_names{k}),'type','Spearman');
            % Pearson Correlation
            aux_pearson(k,j)=corr(x,current_data.covariates.(cov_names{k}),'type','Pearson');
            % Mutual Information
            if flag_info
                aux_mi(k,j)=information(x',current_data.covariates.(cov_names{k})',[descriptorx;descriptorc(k,:)]);
                if ~mod_eval
                    % Conditional Mutual Information (feature,label,covariate)
                    aux_cmi(k,j)=condinformation(x',label',current_data.covariates.(cov_names{k})',[descriptorx;descriptorL;descriptorc(k,:)]);
                end
            end
        end
    end
    for k=1:numel(cov_names)
        profile(i).feature_covariates.spearman_correlation.(cov_names{k})=aux_spearman(k,:);
        profile(i).feature_covariates.pearson_correlation.(cov_names{k})=aux_pearson(k,:);
        profile(i).feature_covariates.mutual_information.(cov_names{k})=aux_mi(k,:);
        if ~mod_eval
            profile(i).feature_covariates.interation_information.(cov_names{k})=aux_cmi(k,:)-aux_mi(k,:);
        end
    end
    else
        profile(i).feature_covariates.spearman_correlation=[];
        profile(i).feature_covariates.pearson_correlation=[];
        profile(i).feature_covariates.mutual_information=[]; 
        profile(i).feature_covariates.interation_information=[];
    end
    %% ACT 4: Instance/Instance interaction
    %initializing the variables
    aux_pearson=nan(numel(current_data.dbcode));
    aux_spearman=nan(numel(current_data.dbcode));
    aux_mi=nan(numel(current_data.dbcode));
    for j=1:numel(current_data.dbcode)
        %defining the structure and the binarization of the feature based on the data type.
        x=current_data.data(j,:);
        minx=min(x);
        maxx=max(x);
        deltax=(maxx-minx)/(length(x)-1);
        if strcmp(mod_data,'continuous')
            ncellx=ceil(length(x)^(1/3));
            descriptorx=[minx-deltax/2,maxx+deltax/2,ncellx];
        else
            descriptorx=[minx,maxx,0];
        end
        for k=j:numel(current_data.dbcode)
             %defining the structure and the binarization of the feature based on the data type.
            y=current_data.data(k,:);
            miny=min(y);
            maxy=max(y);
            deltay=(maxy-miny)/(length(y)-1);
            if strcmp(mod_data,'continuous')
                ncelly=ceil(length(y)^(1/3));
                descriptory=[miny-deltay/2,maxy+deltay/2,ncelly];
            else
                descriptory=[miny,maxy,0];
            end
             % Spearman Correlation
            aux_spearman(j,k)=corr(x',y','type','Spearman');
            % Pearson Correlation
            aux_pearson(j,k)=corr(x',y','type','Pearson');
            % Mutual information
            try aux_mi(j,k)=information(x,y,[descriptorx;descriptory]);
            catch err
                aux_mi(i,j)=NaN;
                warning(err.message)
            end
        end
    end
    profile(i).instance_instance.spearman_correlation=aux_spearman;
    profile(i).instance_instance.pearson_correlation=aux_pearson;
    profile(i).instance_instance.mutual_information=aux_mi;
end
end