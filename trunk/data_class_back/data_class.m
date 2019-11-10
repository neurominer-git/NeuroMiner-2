classdef data_class
    %Summary of DATA_CLASS:
    %   The DATA_CLASS class aims to standartize the data input and transfer
    %   into NM2 by estableshing a well define set of prorieties that all
    %   data should obbey. For the definition of a DATA_CLASS class element
    %   the first five properties of the class (data, type, dbcode,
    %   covariates, target_values) must be provided. The seventh property
    %   'classes' can be provided or let the class decide its value based
    %   on the target_values property. When the sixth and eight property
    %   are not provided the class will generate them automatically. 
    %
    % DATA_CLASS properties:
    %       data - FORMAT: 2D matrix;DESCRIPTION: Core data to be analyzed 
    %       by NM with rows representing examples and columns
    %       features. 
    %       (MANDATORY INPUT)
    %       type - FORMAT: string; DESCRIPTION: String identifying to which
    %       category does the class correspond to. Only data categories 
    %       with a dictionaire class like variable are accpeted. 
    %       (MANDATORY INPUT).
    %       dbcode - FORMAT: cell of strings (Nx1): DESCRIPTION: List of
    %       the DataBase identifiers for each on of the examples (rows) in
    %       Data (MANDATORY INPUT). If empty values are inputed, sequencial
    %       identifiers will be generated.
    %       covariates - FORMAT: struct; DESCRIPTION: Structure with the 
    %       covariates associated to each example (rows). The strucutre's 
    %       field names must be in agreement with the dictionnaire class 
    %       for covariates. 
    %       (MANDATORY INPUT)
    %       target_values - %FORMAT: cell array; DESCRIPTION: Target values
    %       to be used in the analysis. Possible values: 
    %           1 - empty Nx1 cell for unsupervised learning; 
    %           2 - Nxd cell of integers;
    %           (for binary classification (1 for positive class, -1 for the negative class) 
    %           3 - Nxd cell of doubles; 
    %           4 - Nxd cell of logicals (d>1);
    %           5 - Nxd cell of empty cells and integers
    %       (MANDATORY INPUT)
    %       evaluation_type - %FORMAT: string; DESCRIPTION: 
    %       Type of evaluation to be performed, this property is tightly 
    %       connected with the target_values property.
    %       Possible values are:
    %       'binary_classification' - target_values; data_type : integers
    %       (2 unique values).
    %       'multiclass_classification' - target_values; data_type :
    %       integers (n unique values - n= number of classes).
    %       'multi_labelled' - target_values; data_type cell of integers
    %       'hierarchical' - target_values; cell of logicals
    %       'regression' - target_values; double
    %       'unsupervised_learning' - target_values; empty
    %       'semisupervised_learning' - target_values; integers or empty
    %       features_descriptor - %FORMAT: cell of strings; DESCRIPTION: cell 
    %       array with the same number of elements as the number of features
    %       (columns) in the data field of the data_class object. Each cell
    %       array corresponds to a string with a description/name/designation 
    %       of the feature it corresponds to, if empty values are inputed
    %       sequencial feature descriptors will be generated.
    %       descriptor - FORMAT: string; DESCRIPTION: Data descriptor for this dataset.
    %       feature_grouping - FORMAT: int16; DESCRIPTION: integer array
    %       with the same number of elements as the number of features
    %       (columns) in the data field of the data_class object. Each
    %       position contains the group membership of the corresponding
    %       feature, if such is appliable, default value is 1 for all the
    %       positions.
    %
    %       USAGE:
    %       1 - data_class(data,type,dbcode,covariates,target_values,evaluation_type)
    %       
    %       Basic usage, features_descriptor and feature_grouping
    %       properties will be generated automatically for your data. The
    %       descriptor of each voxel will correpond to their position in
    %       the dataset. The descriptor property will be generated based on
    %       the property type and on the time and date of the data_class
    %       creation.
    %
    %       2 - data_class(data,type,dbcode,covariates,target_values,evaluation_type,features_descriptor)
    %
    %       Property features_descriptor is provided, the descriptor
    %       property and feature_grouping are automatically generated.
    %
    %       3 - data_class(data,type,dbcode,covariates,target_values,evaluation_type,features_descriptor,descriptor)
    %
    %       The property feature_grouping is automatically generated.
    %
    %       4 - data_class(data,type,dbcode,covariates,target_values,evaluation_type,features_descriptor,descriptor,feature_grouping)
    %
    %       All the properties are defined, nothing is estimated.
    %
    %   See also: feature_extraction,evaluation
    
    %   DATA_CLASS history:
    %   Date of creation: 17 February 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    %
    %   Date of Modification: 10 August 2015
    %   Modification: Introduction of feature_grouping property
    %   Modifier: Carlos Cabral
    properties
        data;%FORMAT: 2D matrix;
        type;%FORMAT: string;
        dbcode;%FORMAT: cell (Nx1);
        covariates;%FORMAT: struct;
        target_values;%FORMAT: cell array;
        evaluation_type;%FORMAT: string
        features_descriptor;%FORMAT: cell array;
        descriptor;%FORMAT: string;
        feature_grouping;%FORMAT:integer array (1XM)
    end
    
    methods
        function obj = data_class(data,type,dbcode,covariates,target_values,eval_type,features_descrip,descriptor,feat_group)
            if (nargin>0)
                if (nargin==6)
                    %% Data property
                    if ismatrix(data)
                        obj.data = data;
                    else
                        error('data_class:Class_error','Data property is invalid, please read DATA_CLASS class documentation');
                    end
                    %% Type property
                    if ischar(type)
                        obj.type = type;
                    else
                        error('data_class:Class_error','Type property is invalid, please read DATA_CLASS class documentation');
                    end
                    %% Dbcode property
                    if isempty(dbcode)
                        num_instances=size(data,1);
                        obj.dbcode=cellfun(@num2str,num2cell(1:num_instances),'UniformOutput',false);
                    elseif iscellstr(dbcode)
                        if numel(unique(dbcode))==numel(dbcode)
                            if numel(dbcode)==size(data,1)
                                aux_type=cellfun(@isempty,dbcode);
                              if ~any(aux_type)
                                 obj.dbcode=dbcode;
                              else
                                 error('data_class:Class_error','dbcode property is invalid, empty dbcode identifiers were found on your data, read DATA_CLASS class documentation'); 
                              end
                           else
                               error('data_class:Class_error','dbcode property is invalid, the number of dbcode identifiers does not match the number of instances on your data, read DATA_CLASS class documentation');
                           end
                        else
                            error('data_class:Class_error','dbcode property is invalid, repeated dbcode identifiers found, read DATA_CLASS class documentation');
                        end
                    else
                        error('data_class:Class_error','dbcode property data type is invalid a cell of strings was expected, please read DATA_CLASS class documentation');
                    end
                    %% Covariates property
                    if isstruct(covariates)
                       aux_size=true;
                       aux_fields=fieldnames(covariates);
                       for i=1:numel(aux_fields)
                           aux_covar=covariates.(aux_fields{i});
                           if size(aux_covar,1)~=size(data,1)
                              aux_size=false;
                           end
                       end
                       if aux_size
                          obj.covariates = covariates;
                       else
                          error('data_class:Class_error','covariates property is invalid, the number of covariates values does not match the number of instances on your data, read DATA_CLASS class documentation');                           
                       end
                    else
                        error('data_class:Class_error','Covariates property is invalid, please read DATA_CLASS class documentation');
                    end
                    %% Target_values property
                    if iscell(target_values)
                        aux_type=unique(cellfun(@class,target_values,'UniformOutput',false));
                        if numel(aux_type)==1
                            if numel(target_values)==size(data,1)
                               obj.target_values=target_values;
                            else
                               error('data_class:Class_error','target_values property is invalid, the number of target_values does not match the number of instances on your data, read DATA_CLASS class documentation');
                            end
                        else
                            error('data_class:Class_error','Target_values property values are inconsistent, please read DATA_CLASS class documentation');
                        end
                    else
                        error('data_class:Class_error','Target_values property is invalid, please read DATA_CLASS class documentation');
                    end
                    %% Features_descriptor property
                    num_features=size(data,2);
                    obj.features_descriptor=cellfun(@num2str,num2cell(1:num_features),'UniformOutput',false);
                    %descriptor property
                    td=clock; %current time and date to identify the analysis when no description is provided
                    aux_descriptor = [num2str(td(1)) '-' num2str(td(2)) '-' num2str(td(3)) '_' num2str(td(4)) '-' num2str(td(5)) '-' num2str(round(td(6)))];
                    obj.descriptor = [obj.type '_' aux_descriptor];
                    %% Features grouping property
                    obj.feature_grouping=int16(ones(1,num_features));
                    %% Evaluation_type property
                    
                    %Supported values:
                    % binary_classification 
                    % multiclass_classification
                    % multi_labelled
                    % hierarchical
                    % regression
                    % unsupervised_learning
                    % semisupervised_learning
                    % one_class_modeling
                    if ~ischar(eval_type)
                        error('data_class:Class_error',['Undefined class "data_class" for ' class(eval_type) ' data type of "evaluation_type" properties, please read DATA_CLASS class documentation']);
                    end
                    switch eval_type
                        case 'binary_classification'
                            if isnumeric(target_values{1})
                               aux_numel=unique(cellfun('size',target_values,2));
                               if numel(aux_numel)==1
                                  if aux_numel==1
                                     aux_values=unique(cell2mat(target_values));
                                     if numel(aux_values)<3
                                        if all(round(aux_values)==aux_values)
                                           if all(any(aux_values==1)&&any(aux_values==-1))
                                              obj.evaluation_type='binary_classification';
                                           else
                                              warning('data_class:IncompatibilityError','target_values provided for binary classification are not in the form 1 (positive class) -1 (negative class), the descending numerical sorting will be used.'); 
                                              obj.evaluation_type='binary_classification'; 
                                           end
                                        else
                                           error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, non-integers single target_value were detected, please read DATA_CLASS class documentation']); 
                                        end
                                     else
                                        error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, more or less than 2 classes found, please read DATA_CLASS class documentation']); 
                                     end
                                  else
                                      error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, single target_value are not unidimensional, please read DATA_CLASS class documentation']);
                                  end
                               else
                                   error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, multiple single target_value sizes detected, please read DATA_CLASS class documentation']);
                               end
                            else
                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, invalid single target_value data type, "' aux_type{1} '", please read DATA_CLASS class documentation']);
                            end
                        case 'multiclass_classification'
                            if isnumeric(target_values{1})
                                aux_numel=unique(cellfun('size',target_values,2));
                                if numel(aux_numel)==1
                                    if aux_numel==1
                                        aux_values=unique(cell2mat(target_values));
                                        if numel(aux_values)>2
                                            if all(round(aux_values)==aux_values)
                                                if ~strcmp(aux_type,'double')
                                                    obj.target_values=cell2fun(@double,target_values,'UniformOutput',false);
                                                end
                                                obj.evaluation_type='multiclass_classification';
                                            else
                                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, non-integers single target_value were detected, please read DATA_CLASS class documentation']);
                                            end
                                        else
                                            error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, less than 3 classes found, please read DATA_CLASS class documentation']);
                                        end
                                    else
                                        error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, single target_value are not unidimensional, please read DATA_CLASS class documentation']);
                                    end
                                else
                                    error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, multiple single target_value sizes detected, please read DATA_CLASS class documentation']);
                                end
                            else
                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, invalid single target_value data type, "' aux_type '", please read DATA_CLASS class documentation']);
                            end
                        case 'multi_labelled'
                            if isnumeric(target_values{1})
                                aux_numel=unique(cellfun('size',target_values,2));
                                if numel(aux_numel)~=1
                                    warning('data_class:IncompatibilityWarning',['target_values  and evaluation_type (' eval_type ') properties might have compatibility issues, multiple single target_value sizes detected, please read DATA_CLASS class documentation']);
                                end
                                if all(aux_numel)>1
                                    aux_values=unique(cell2mat(target_values));
                                    if all(round(aux_values)==aux_values)
                                        if ~strcmp(aux_type,'double')
                                            obj.target_values=cell2fun(@double,target_values,'UniformOutput',false);
                                        end
                                        obj.evaluation_type='multiclass_classification';
                                    else
                                        error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, non-integers single target_value were detected, please read DATA_CLASS class documentation']);
                                    end
                                else
                                    error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, single non multidimensional target_value were found, please read DATA_CLASS class documentation']);
                                end
                            else
                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, invalid single target_value data type, "' aux_type '", please read DATA_CLASS class documentation']);
                            end
                        case 'hierarchical'
                            if islogical(target_values{1})||isnumeric(target_values{1})
                                aux_numel=unique(cellfun('size',target_values,2));
                                if numel(aux_numel)~=1
                                    warning('data_class:IncompatibilityWarning',['target_values  and evaluation_type (' eval_type ') properties might have compatibility issues, multiple single target_value sizes detected, please read DATA_CLASS class documentation']);
                                end
                                if aux_numel>1
                                    if islogical(target_values{1})
                                        obj.evaluation_type='hierarchical';
                                    else
                                        aux_values=unique(cell2mat(target_values));
                                        if (numel(aux_values)==2)&&(numel(intersect(aux_values,[0 1]))==2);
                                            obj.target_values=cell2fun(@logical,target_values,'UniformOutput',false);
                                            obj.evaluation_type='hierarchical';
                                        else
                                            error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, non-logicals (0 or 1) single target_value were detected, please read DATA_CLASS class documentation']);
                                        end
                                    end
                                else
                                    error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, single target_value are not multidimensional, please read DATA_CLASS class documentation']);
                                end
                            else
                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, invalid single target_value data type, "' aux_type '", please read DATA_CLASS class documentation']);
                            end
                        case 'regression'
                            if strcmp(aux_type,'double')
                                aux_numel=unique(cellfun('size',target_values,2));
                                if numel(aux_numel)==1
                                    if aux_numel==1
                                        obj.evaluation_type='regression';
                                    else
                                        error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, multiple single target_value sizes detected, please read DATA_CLASS class documentation']);
                                    end
                                else
                                    error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, invalid single target_value data type, "' aux_type '", please read DATA_CLASS class documentation']);
                                end
                            end
                        case 'unsupervised_learning'
                            if isempty(target_values)||all(cellfun(@isempty,target_values))
                               obj.evaluation_type='unsupervised_learning';
                            else
                               error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, unsupervised learning does not require any labels, please read DATA_CLASS class documentation']); 
                            end
                        case 'semisupervised_learning'
                            if ~(isempty(target_values)||all(cellfun(@isempty,target_values)))
                               obj.evaluation_type='semisupervised_learning';
                            else
                               error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, semisupervised learning requires labels for at least a small percentage of examples, please read DATA_CLASS class documentation']); 
                            end
                        case 'one_class_modeling'
                            if islogical(target_values{1})||isnumeric(target_values{1})
                                aux_numel=unique(cellfun('size',target_values,2));
                                if numel(aux_numel)==1
                                    if aux_numel>1
                                        if islogical(target_values{1})
                                            obj.evaluation_type='one_class_modeling';
                                        else
                                            aux_values=unique(cell2mat(target_values));
                                            if (numel(aux_values)==2)&&(numel(intersect(aux_values,[0 1]))==2);
                                                obj.target_values=cell2fun(@logical,target_values,'UniformOutput',false);
                                                obj.evaluation_type='one_class_modeling';
                                            else
                                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, non logical (0 or 1) single target_value were detected, please read DATA_CLASS class documentation']);
                                            end
                                        end
                                    else
                                        error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, single target_value are not multidimensional, please read DATA_CLASS class documentation']);
                                    end
                                else
                                    error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, single target_value are not unidimensional, please read DATA_CLASS class documentation']);
                                end
                            else
                                error('data_class:IncompatibilityError',['target_values  and evaluation_type (' eval_type ') properties are not compatible, invalid single target_value data type, "' aux_type '", please read DATA_CLASS class documentation']);
                            end
                        otherwise
                            error('data_class:Class_error',['Undefined class "data_class" for ' eval_type ' "evaluation_type" property, please read DATA_CLASS class documentation']);
                    end
                elseif (nargin==7)
                    obj=data_class(data,type,dbcode,covariates,target_values,eval_type);
                    %% Features_descriptor property
                    if ~isempty(features_descrip)
                        if iscellstr(features_descrip)
                            if numel(features_descrip)==size(data,2)
                                empty_value=cellfun(@isempty,features_descrip);
                                if ~any(empty_value)
                                    obj.features_descriptor=features_descrip;
                                else
                                    error('data_class:Class_error','"features_descriptor " (data_class) property is invalid empty values found.');
                                end
                            else
                                error('data_class:Class_error',['"features_descriptor " property is invalid the number of features (' num2str(size(data,2)) ') and the number of features descriptors (' num2str(numel(features_descrip)) ') differ.']);
                            end
                            obj.features_descriptor = features_descrip;
                        else
                            error('data_class:Class_error',['"features_descriptor " property is invalid for ' class(features_descrip) ' a cell array should have been provided.']);
                        end
                    else
                        num_features=size(data,2);
                        obj.features_descriptor=cellfun(@num2str,num2cell(1:num_features),'UniformOutput',false);
                    end
                elseif (nargin==8)
                    obj=data_class(data,type,dbcode,covariates,target_values,eval_type,features_descrip);
                    %% Descriptor property
                    if ischar(descriptor)
                        obj.descriptor = descriptor;
                    else
                        error('data_class:Class_error','Descriptor property is invalid, please read DATA_CLASS class documentation');
                    end
                elseif (nargin==9)
                    obj=data_class(data,type,dbcode,covariates,target_values,eval_type,features_descrip,descriptor);
                    %% Descriptor property
                    if isa(feat_group,'int16')
                        if numel(feat_group)==size(data,2);
                        obj.feature_grouping = feat_group;
                        else
                            error('data_class:Class_error','feature_grouping property dimensions are invalid, please read DATA_CLASS class documentation');
                        end
                    else
                        error('data_class:Class_error','feature_grouping property data type is invalid, please read DATA_CLASS class documentation');
                    end
                else
                    error('data_class:Class_error','Invalid number of arguments please consult DATA_CLASS class documentation');
                end
            end
        end
    end
end