classdef C_SVM_LIBSVM
       %Summary of C_SVM_LIBSVM:
    %   The C_SVM_LIBSVM class integrates the C-SVM implementation
    %   of LIBSVM in NM2 for more info consult www.csie.ntu.edu.tw/~cjlin/libsvm.
    %
    %   C_SVM_LIBSVM properties:
    %   parameters - %FORMAT: struct; Description : Structure with the
    %   parameters to be used by C_SVM_LIBSVM. Each field in the
    %   parameters structure is a parameter class object and corresponds
    %   to a single parameter,hence should be named accordingly, the
    %   required paramaters and their description is the following:
    %   - kernel_type : data_type 'integer' : dimension [1 1] : range
    %      {0,1,2,3} :
    %      Description: Kernel to be used in the nu-SVM
    %      0 -- linear: u''*v
    %      1 -- polynomial: (gamma*u''*v + coef0)^degree
    %      2 -- radial basis function: exp(-gamma*|u-v|^2)
    %      3 -- sigmoid: tanh(gamma*u''*v + coef0)
    %      Default  value - 0;
    %    - degree : data_type 'double' : dimension [1 1] : range [-Inf Inf]
    %      Description: degree of the polynomial kernel to be used by the
    %      nu-SVM (only valid if kernel_type value is 2.
    %      Default value - 3;
    %    - gamma : data_type 'double' : dimension [1 1] : range [0 Inf]
    %      Description: set gamma in the kernel function (only valid if
    %      kernel_type value is 2 or 3).
    %      Default value - 1/(number of features).
    %    - coef0 : data_type 'double' : dimension [1 1] : range [-Inf Inf]
    %      Description: set coef0 in the kernel function (only valid if
    %      kernel_type value is 1 or 3).
    %      Default value - 0.
    %    - cost : data_type 'double' : dimension [1 1] : range [0 Inf]
    %      Description: set the parameter C of C-SVC
    %      Default value - 1.
    %    - cachesize : data_type 'double' : dimension [1 1] : range [1 Inf]
    %      Description: set cache memory size in MB
    %      Default value - 100.
    %    - epsilon : data_type 'logical' : dimension [1 1] :range [true false]
    %      Description: set tolerance of termination criterion.
    %      Default value - 0.0001.
    %    - shrinking :data_type 'logical' : dimension [1 1] : range [true false]
    %      Description: whether to use the shrinking heuristics
    %      Default value - True.
    %    - probability_estimates :data_type 'logical' : dimension [1 1] : range [true false]
    %      Description: whether to train a SVC or SVR model for probability estimates
    %      Default value - False.
    %    - weight_data_instances :data_type 'double' : dimension [1 numberof examples/instances] : range [0 Inf]
    %      Description: set the parameter C of data instance i to weight*C,
    %      for C-SVC.
    %      Default value - 1 for all instances/examples.
    %    - class_weight :data_type 'double' : dimension [1 number of classes] : range [0 Inf]
    %      Description: set the parameter C of class i to weight*C, for C-SVC
    %      Default value - 1 for all classes.
    %    - train_eval :data_type 'logical' : dimension [1 1] : range [true false]
    %      Description: whether to use to evaluate the model with the
    %      training set. (default 1).
    %      Default value - True.
    %    - param_eval :data_type 'logical' : dimension [1 1] : range [true false]
    %      Description: whether to use to check the parameters when
    %      applying the method to new data. (default 1).
    %      Default value - True.
    %
    %   If no parameters are provided the the C_SVM_LIBSVM object
    %   will inherite the built-in values predefined for this class.
    %
    %   If parameters are provided the program will assess if they are
    %   valid based on the built-in parameters. ...
    %   model - %FORMAT: struct; DESCRIPTION : Model estimated using the
    %   method defined in the C_SVM_LIBSVM class. If empty
    %   the model will be estimated, else applied. Fields in the model
    %   are:
    %      -Parameters: parameters internally used
    %      -nr_class: number of classes; = 2 for regression/one-class svm
    %      -totalSV: total #SV
    %      -rho: -b of the decision function(s) wx+b
    %      -Label: label of each class; empty for regression/one-class SVM
    %      -ProbA: pairwise probability information; empty if -b 0 or in one-class SVM
    %      -ProbB: pairwise probability information; empty if -b 0 or in one-class SVM
    %      -nSV: number of SVs for each class; empty for regression/one-class SVM
    %      -sv_coef: coefficients for SVs in decision functions
    %      -SVs: support vectors
    %      -weight_vector: weight vector determined by the model - optional.
    %   reports - %FORMAT: report class object ; DESCRIPTION: Report class
    %   object that describes the status and incidences in the model
    %   estimation/application process
    %       USAGE:
    %       1 - C_SVM_LIBSVM
    %
    %       Basic usage, the class will inherit the built-in parameters and
    %       the models and reports fields will be empty. The status of this
    %       object is 'estimation_ready'.
    %
    %       2 - C_SVM_LIBSVM(parameters)
    %
    %       User defined parameters, the class will take the provided
    %       parameters and check if they are in agreement with the built-in
    %       definition of the parameters. All the parameters should be
    %       provided. The status of the this object is 'estimation_ready'.
    %
    %       3 - C_SVM_LIBSVM(parameters,model,report)
    %
    %       The complete model is provided, the status of this object is
    %       'application_ready'.
    %
    %
    %   C_SVM_LIBSVM revision history:
    %   Date of creation: 17 March 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        parameters; %FORMAT: struct
        model;%FORMAT: struct
        reports; %FORMAT: report class object ;
    end
    
    methods
        function obj =C_SVM_LIBSVM(paramet,model,reports)
            import evaluation_methods.*
            if nargin==0
               %VERY IMPORTANT built-in parameters definition. Each
               %parameter is a parameter class object (for more information
               %read the parameter class documentation).
               
               %kernel_type : kernel to be used on C-SVM
               %kernel_type :data_type 'integer' : dimension [1 1] : range {0,1,2,3} :
               %value {2} : comment : description of the values; 
               kernel_type=parameters({0},'int16',int16([1 1]),num2cell(int16(0:3)),'0 -- linear: u''*v \n 1 -- polynomial: (gamma*u''*v + coef0)^degree\n2 -- radial basis function: exp(-gamma*|u-v|^2)\n3 -- sigmoid: tanh(gamma*u''*v + coef0)\n Default  value - 0;)');
               
               %degree : of the polynomial kernel to be used by the C-SVM
               %degree :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               %value {3} : comment : description of the values; 
               degree=parameters({[]},'int16',int16([1 1]),[-Inf Inf],'set degree in kernel function (default 3)\n empty values allowed, default will be used.');
               
               %gamma : in kernel function to be used by the C-SVM
               %gamma :data_type 'double' : dimension [1 1] : [0 Inf] :
               %value {'1/number_of_features'} : comment : description of the values; 
               gamma=parameters({[]},'double',int16([1 1]),[0 Inf],'set gamma in kernel function (default 1/number_of_features)\n empty values allowed, default will be used.');
               
               %coef0 : set coef0 in kernel function (default 0) to be used by the C-SVM
               %coef0 :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               %value {0} : comment : description of the values; 
               coef0=parameters({[]},'int16',int16([1 1]),[-Inf Inf],'set coef0 in kernel function (default 0)\n empty values allowed, default will be used.');
               
               %cost : set the parameter C of C-SVC (default 1)
               %cost :data_type 'double' : dimension [1 1] : [0 Inf] :
               %value {1} : comment : description of the values; 
               cost=parameters({[]},'double',int16([1 1]),[0 Inf],'set the parameter C of C-SVC (default 1)\n empty values allowed, default will be used.');
               
               %cachesize : set cache memory size in MB (default 100)
               %cachesize :data_type 'double' : dimension [1 1] : [1 Inf] :
               %value {100} : comment : description of the values; 
               cachesize=parameters({[]},'double',int16([1 1]),[1 Inf],'set cache memory size in MB (default 100)\n empty values allowed, default will be used.');
               
               %epsilon : set tolerance of termination criterion (default 0.001)
               %epsilon :data_type 'double' : dimension [1 1] : [0 1] :
               %value {0.0001} : comment : description of the values; 
               epsilon=parameters({[]},'double',int16([1 1]),[0 1],'set tolerance of termination criterion (default 0.001)\n empty values allowed, default will be used.');
               
               %shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
               %shrinking :data_type 'logical' : dimension [1 1] : [true false] :
               %value {true} : comment : description of the values; 
               shrinking=parameters({[]},'logical',int16([1 1]),[true false],'whether to use the shrinking heuristics, 0 or 1 (default 1)\n empty values allowed, default will be used.');
               
               %probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
               %probability_estimates :data_type 'logical' : dimension [1 1] : [true false] :
               %value {false} : comment : description of the values;
               probability_estimates=parameters({[]},'logical',int16([1 1]),[true false],'whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)\n empty values allowed, default will be used.');
               
               %class_weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
               %class_weight :data_type 'double' : dimension [1 number_of_classes] : [0 Inf] :
               %value {'ones(1,number_of_classes)'} : comment : description of the values; 
               class_weight=parameters({[]},'double','int16([1 number_of_classes])',[0 Inf],'set the parameter C of class i to weight*C, for C-SVC (default 1)\n empty values allowed, default will be used.\n empty values allowed Size Variable');
               
               %weight_data_instances : set the parameter C of data instance i to weight*C, for C-SVC (default 1)
               %weight_data_instances :data_type 'double' : dimension [1 number_of_classes] : [0 Inf] :
               %value {'ones(1,number_of_examples)'} : comment : description of the values; 
               weight_data_instances=parameters({[]},'double','int16([1 number_of_examples])',[0 Inf],'set the parameter C of data instance i to weight*C, for C-SVC (default 1).\n empty values allowed Size Variable');
               
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
               paramet=struct('kernel_type',kernel_type,'degree',degree,'gamma',gamma,'coef0',coef0,'cost',cost,'cachesize',cachesize,'epsilon',epsilon,'shrinking',shrinking,'probability_estimates',probability_estimates,'class_weight',class_weight,'weight_data_instances',weight_data_instances,'train_eval',train_eval,'param_eval',param_eval);
               obj.parameters=paramet;
               obj.model=struct([]);
               obj.reports=report;
            else
                if (nargin==1)
                    obj=binary_classification.C_SVM_LIBSVM();
                    if isstruct(paramet)
                        try reporta=parameters_checker(obj.parameters,paramet);
                        catch err
                            rethrow(err)
                        end
                        if reporta.flag
                            obj.parameters=paramet;
                        else
                            error(['C_SVM_LIBSVM:Class_error','Error using C_SVM_LIBSVM \n Invalid parameters provided. \n ' reporta.descriptor]);
                        end
                    else
                        error(['C_SVM_LIBSVM:Class_error','Error using C_SVM_LIBSVM \n First input (parameters) must be a structure.']);
                    end
                elseif (nargin==3)
                    obj=binary_classification.C_SVM_LIBSVM(paramet);
                    if ~isstruct(model)
                        error('C_SVM_LIBSVM:Incompability_error','Error using C_SVM_LIBSVM \nSecond input (model) must be a structure.')
                    end
                        %-Parameters: parameters
                        %-nr_class: number of classes; = 2 for regression/one-class svm
                        %-totalSV: total #SV
                        %-rho: -b of the decision function(s) wx+b
                        %-Label: label of each class; empty for regression/one-class SVM
                        %-ProbA: pairwise probability information; empty if -b 0 or in one-class SVM
                        %-ProbB: pairwise probability information; empty if -b 0 or in one-class SVM
                        %-nSV: number of SVs for each class; empty for regression/one-class SVM
                        %-sv_coef: coefficients for SVs in decision functions
                        %-SVs: support vectors
                        %-weight_vector: weight vector determined by the model - optional.
                    list_of_fields={'Parameters','nr_class','totalSV','rho','Label','ProbA','ProbB','nSV','sv_coef','SVs'};
                    for i=1:numel(list_of_fields)
                        if ~isfield(model,list_of_fields{i})
                           error('C_SVM_LIBSVM:Incompability_error',['Error using C_SVM_LIBSVM \nSecond input (model) does not contain the ' list_of_fields{i} ' field.'])
                        end
                    end
                    obj.model=model;
                    if ~(sum(isreport(reports))>0)
                        error('C_SVM_LIBSVM:Incompability_error','Error using C_SVM_LIBSVM \nThird (reports) must be a report class object.')
                    else
                        obj.reports=reports;
                    end
                else
                    error('C_SVM_LIBSVM:Invalid_number_of_arguments','Invalid numer of arguments specified please read the C_SVM_LIBSVM class documentation.')
                end
            end
        end
    end
end
