classdef results
    %Summary of RESULTS:
    %   The RESULTS class aims to standartize the outputs of the evaluation
    %   methos in NM2. To define a RESULTS class object all the properties
    %   need to be defined. 
    %
    %   RESULTS properties:
    %   hard_labels - ...
    %   soft_labels - ...
    %   dbcode - ...
    %   target_values - ...
    %   features - ...
    %   descriptor - ...
    %   evaluation_type - %FORMAT: string; DESCRIPTION: 
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
    %       'one_class_modeling' - target_values; 0 and 1 or -1 and 1
    %       targets, with 1 representing the positive class.
    %   classes - ...


    %
    %   RESULTS history:
    %   Date of creation: 08 September 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        hard_labels;  %FORMAT: cell array (NX1); DESCRIPTION: Discrete values outputed by the learning machine (if exist), where N is the number of examples. 
        soft_labels;  %FORMAT: doubel array (NXM) ; DESCRIPTION: Class membership outputed by the learning machine (if exist), N is the number of examples and M number of classes considered.
        dbcode; %FORMAT: cell array (Nx1): DESCRIPTION: List of the DataBase identifiers for each on of the examples (rows) in hard/soft labels. N is the number of examples.
        target_values; %FORMAT: cell array (Nx1); DESCRIPTION: Original target values, soft or hard and 1-D or N-D depending on the analysis purpose.
        features; %FORMAT: string; DESCRIPTION: Descriptor of the features used to generate the hard_labels ||/& soft_labels.
        descriptor; %FORMAT: string; DESCRIPTION: Methods used to generate the the hard_labels ||/& soft_labels (class).
        evaluation_type;%FORMAT: string;
        classes;%FORMAT: double array; DESCRIPTION: Set of values dependent of the EVALUATION_TYPE property, useful for obtaining performance measures. Result of the classes method for data_class element.
    end
    
    methods
        function obj = results(hard_labels,soft_labels,dbcode,target_values,features,descript,eval_type,cla)
            if (nargin>0)
                if (nargin==8)
                    %checking hard_labels
                    if iscell(hard_labels)
                        obj.hard_labels=hard_labels;
                    else
                        error('results:InputError','HARD_LABELS propriety is invalid, please read RESULTS class documentation');
                    end
                    %checking soft_labels
                    if ismatrix(soft_labels)
                        obj.soft_labels= soft_labels;
                    else
                        error('results:InputError','SOFT_LABELS propriety is invalid, please read RESULTS class documentation');
                    end
                    %checking db_code
                    if iscell(dbcode)
                       obj.dbcode =dbcode;
                    else
                        error('results:InputError','DBCODE propriety data type is invalid, please read RESULTS class documentation');
                    end
                    %checking target_values
                    if iscell(target_values)
                        obj.target_values=target_values;
                    else
                        error('results:InputError','TARGET_VALUES propriety is invalid, please read RESULTS class documentation');
                    end
                    % checking features
                    if ischar(features)
                        obj.features = features;
                    else
                        error('results:InputError','FEATURES propriety is invalid, please read RESULTS class documentation');
                    end
                    %checking descriptor
                    if ischar(descript)
                        obj.descriptor = descript;
                    else
                        error('results:InputError','EVALUATION propriety is invalid, please read EVALUATION class documentation');
                    end
                    %checking evaluation_type
                    if ischar(eval_type)
                        if any(strcmp(eval_type,{'binary_classification','multiclass_classification','multi_labelled','hierarchical','regression','unsupervised_learning','semisupervised_learning','one_class_modeling'}))
                            obj.evaluation_type = eval_type;
                        else
                            error('results:InputError','EVALUATION_TYPE propriety is not recognized,');
                        end
                    else
                        error('results:InputError','EVALUATION_TYPE propriety is invalid, please read RESULTS class documentation');
                    end
                    %checking classes
                    
                    if any(strcmp(eval_type,{'binary_classification','multiclass_classification','regression','semisupervised_learning','one_class_modeling'}))
                        if (isnumeric(cla)||islogical(cla))&&isvector(cla)
                            if any(strcmp(eval_type,{'binary_classification','regression','one_class_modeling'}))&&numel(cla)==2
                                obj.classes = cla;
                            elseif any(strcmp(eval_type,{'multiclass_classification'}))&&numel(cla)>2
                                obj.classes = cla;
                            elseif any(strcmp(eval_type,{'semisupervised_learning'}))
                                obj.classes = cla;
                            elseif numel(cla)==1&&numel(dbcode)==1
                                obj.classes = cla;
                            elseif numel(cla)==1&&numel(dbcode)==1;
                                obj.classes = cla;
                            else
                                error('results:InputError',['ClASSES propriety is not compatible with the provided EVALUATION_TYPE: ' eval_type '.']);
                            end
                        else
                            error('results:InputError',['ClASSES propriety is not compatible with the provided EVALUATION_TYPE: ' eval_type '.']);
                        end
                        %the other properties for the data_types are still
                        %on the wait
                    end
                    
                    %CHECKING INTEGRITY
                    if isempty(hard_labels)&&isempty(soft_labels)
                        error('results:IncompatibilityError','No valid LABELS found. Both HARD_LABELS and SOFT_LABELS are empty')
                    end
                    if ~((size(hard_labels,1)==size(soft_labels,1))&&(size(target_values,1)==size(dbcode,1))&&(size(hard_labels,1)==size(dbcode,1)))
                        error('results:IncompatibilityError','Dimension inconsistencies between HARD_LABELS, SOFT_LABELS, TARGET_VALUES and DBCODES.');
                    end
                else
                    error('results:InputError','Invalid number of arguments please consult RESULTS class documentation');
                end
            else
                obj.descriptor='info';
            end
        end
    end
end