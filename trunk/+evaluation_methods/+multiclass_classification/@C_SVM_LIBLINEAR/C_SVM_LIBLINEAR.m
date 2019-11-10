classdef C_SVM_LIBLINEAR
    %   Summary of C_SVM_LIBLINEAR:
    %   The C_SVM_LIBLINEAR class integrates the multi-class support vector
    %   classification by Crammer and Singer implementation of LIBLINEAR in
    %   NM2 for more www.csie.ntu.edu.tw/~cjlin/liblinear.
    %
    %   C_SVM_LIBLINEAR properties:
    %   parameters - %FORMAT: struct; Description : Structure with the
    %   parameters to be used by C_SVM_LIBLINEAR. Each field in the
    %   parameters structure is a parameter class object and corresponds
    %   to a single parameter,hence should be named accordingly, the
    %   required paramaters and their description is the following:
    %
    %    - cost : data_type 'double' : dimension [1 1] : range [0 Inf]
    %      Description: set the parameter C of C-SVC
    %      Default value - 1.
    %    - epsilon : data_type 'double' : dimension [1 1] :range [0 1]
    %      Description: set tolerance of termination criterion.
    %      Default value : type 7 -> 0.1 type 0 and 6 ->0.01.
    %    - class_weight :data_type 'double' : dimension [1 number of classes] : range [0 Inf]
    %      Description: set the parameter C of class i to weight*C, for C-SVC
    %      Default value - 1 for all classes.
    %    - bias : data_type 'double' : dimension [1 1] :range [-Inf Inf]
    %      Description: bias : if bias >= 0, instance x becomes [x; bias];
    %      if < 0, no bias term added (default -1)
    %      Default value : -1.
    %    - train_eval :data_type 'logical' : dimension [1 1] : range [true false]
    %      Description: whether to use to evaluate the model with the
    %      training set. (default 1).
    %      Default value - True.
    %    - param_eval :data_type 'logical' : dimension [1 1] : range [true false]
    %      Description: whether to use to check the parameters when
    %      applying the method to new data. (default 1).
    %      Default value - True.
    %
    %   If no parameters are provided the the C_SVM_LIBLINEAR object
    %   will inherite the built-in values predefined for this class.
    %
    %   If parameters are provided the program will assess if they are
    %   valid based on the built-in parameters. ...
    %   model - %FORMAT: struct; DESCRIPTION : Model estimated using the
    %   method defined in the C_SVM_LIBLINEAR class. If empty
    %   the model will be estimated, else applied. Fields in the model
    %   are:
    %   -Parameters: Parameters
    %   -nr_class: number of classes; = 2 for regression
    %   -nr_feature: number of features in training data (without including the bias term)
    %   -bias: If >= 0, we assume one additional feature is added to the end
    %   of each data instance.
    %   -Label: label of each class; empty for regression
    %   -w: a nr_w-by-n matrix for the weights, where n is nr_feature
    %   or nr_feature+1 depending on the existence of the bias term.
    %   nr_w is 1 if nr_class=2 .
    %   reports - %FORMAT: report class object ; DESCRIPTION: Report class
    %   object that describes the status and incidences in the model
    %   estimation/application process
    %       USAGE:
    %       1 - C_SVM_LIBLINEAR
    %
    %       Basic usage, the class will inherit the built-in parameters and
    %       the models and reports fields will be empty. The status of this
    %       object is 'estimation_ready'.
    %
    %       2 - C_SVM_LIBLINEAR(parameters)
    %
    %       User defined parameters, the class will take the provided
    %       parameters and check if they are in agreement with the built-in
    %       definition of the parameters. All the parameters should be
    %       provided. The status of the this object is 'estimation_ready'.
    %
    %       3 - C_SVM_LIBLINEAR(parameters,model,report)
    %
    %       The complete model is provided, the status of this object is
    %       'application_ready'.
    %
    %
    %   C_SVM_LIBLINEAR revision history:
    %   Date of creation: 19 March 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct
        model;%FORMAT: struct
        reports; %FORMAT: report class object ;
    end
    
    methods
        function obj =C_SVM_LIBLINEAR(paramet,model,reports)
            import evaluation_methods.*
            if nargin==0
               %VERY IMPORTANT built-in parameters definition. Each
               %parameter is a parameter class object (for more information
               %read the parameter class documentation).             
               
               %cost : set the parameter C  (default 1)
               %cost :data_type 'double' : dimension [1 1] : [0 Inf] :
               %value {1} : comment : description of the values; 
               cost=parameters({[]},'double',int16([1 1]),[0 Inf],'set the parameter C of C-SVC (default 1)\n empty values allowed, default will be used.');
               
               
               %epsilon : set tolerance of termination criterion (default 0.001)
               %epsilon :data_type 'double' : dimension [1 1] : [0 1] :
               %value {0.0001} : comment : description of the values; 
               epsilon=parameters({[]},'double',int16([1 1]),[0 1],'set tolerance of termination criterion (default type 7 -> 0.1 type 0 and 6 ->0.01)\n empty values allowed, default will be used.');
                              
               %class_weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
               %class_weight :data_type 'double' : dimension [1 number_of_classes] : [0 Inf] :
               %value {'ones(1,number_of_classes)'} : comment : description of the values; 
               class_weight=parameters({[]},'double','int16([1 number_of_classes])',[0 Inf],'set the parameter C of class i to weight*C (default 1)\n empty values allowed, default will be used.\n empty values allowed Size Variable');
               
               %bias : if bias >= 0, instance x becomes [x; bias]; if < 0, no bias term added (default -1)
               %bias :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               bias=parameters({[]},'double',int16([1 1]),[-Inf Inf],'if bias >= 0, instance x becomes [x; bias]; if < 0, no bias term added (default -1)\n empty values allowed, default will be used.');
                
               %train_eval: whether to use to evaluate the model with the
               %training set. (default 1).
               %train_eval :data_type 'logical' : dimension [1 1] : [true false] :
               %value {false} : comment : description of the values; 
               train_eval=parameters({true},'logical',int16([1 1]),[true false],'whether to use to evaluate the model with the training set. (default 1), 0 or 1 (default 1)\n ');
               
               %param_eval: whether to use to check the parameters when
               %applying the method to new data. (default 1).
               %param_eval :data_type 'logical' : dimension [1 1] : [true false] :
               %value {false} : comment : description of the values; 
               param_eval=parameters({true},'logical',int16([1 1]),[true false],'whether to use to check the parameters when applying the method to new data. (default 1), 0 or 1 (default 1)\n ');

               
               %assembling the parameters
               paramet=struct('cost',cost,'epsilon',epsilon,'class_weight',class_weight,'bias',bias,'train_eval',train_eval,'param_eval',param_eval);
               obj.parameters=paramet;
               obj.model=struct([]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=binary_classification.C_SVM_LIBLINEAR();
                    if isstruct(paramet)
                        try reporta=parameters_checker(obj.parameters,paramet);
                        catch err
                            rethrow(err)
                        end
                        if reporta.flag
                            obj.parameters=paramet;
                        else
                            error(['C_SVM_LIBLINEAR:Class_error','Error using C_SVM_LIBLINEAR \n Invalid parameters provided. \n ' reporta.descriptor]);
                        end
                    else
                        error(['C_SVM_LIBLINEAR:Class_error','Error using C_SVM_LIBLINEAR \n First input (parameters) must be a structure.']);
                    end
                elseif (nargin==3)
                    obj=binary_classification.C_SVM_LIBLINEAR(paramet);
                    if ~isstruct(model)
                        error('C_SVM_LIBLINEAR:Incompability_error','Error using C_SVM_LIBLINEAR \nSecond input (model) must be a structure.')
                    end
                    % -Parameters: Parameters
                    % -nr_class: number of classes; = 2 for regression
                    % -nr_feature: number of features in training data (without including the bias term)
                    % -bias: If >= 0, we assume one additional feature is added to the end
                    % of each data instance.
                    % -Label: label of each class; empty for regression
                    % -w: a nr_w-by-n matrix for the weights, where n is nr_feature
                    % or nr_feature+1 depending on the existence of the bias term.
                    % nr_w is 1 if nr_class=2 .
                    list_of_fields={'Parameters','nr_class','nr_feature','bias','Label','w'};
                    for i=1:numel(list_of_fields)
                        if ~isfield(model,list_of_fields{i})
                           error('C_SVM_LIBLINEAR:Incompability_error',['Error using C_SVM_LIBLINEAR \nSecond input (model) does not contain the ' list_of_fields{i} ' field.'])
                        end
                    end
                    obj.model=model;
                    if ~(sum(isreport(reports))>0)
                        error('C_SVM_LIBLINEAR:Incompability_error','Error using C_SVM_LIBLINEAR \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('C_SVM_LIBLINEAR:Invalid_number_of_arguments','Invalid numer of arguments specified please read the C_SVM_LIBLINEAR class documentation.')
                end
            end
        end
    end
end
