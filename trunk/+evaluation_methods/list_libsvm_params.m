               %VERY IMPORTANT built-in parameters definition. Each
               %parameter is a parameter class object (for more information
               %read the parameter class documentation).
               
               %kernel_type : kernel to be used on C-SVM
               %kernel_type :data_type 'integer' : dimension [1 1] : range {0,1,2,3} :
               %value {2} : comment : description of the values; 
               kernel_type=parameters({0},'int16',int16([1 1]),num2cell(int16(0:3)),'0 -- linear: u''*v \n 1 -- polynomial: (gamma*u''*v + coef0)^degree\n2 -- radial basis function: exp(-gamma*|u-v|^2)\n3 -- sigmoid: tanh(gamma*u''*v + coef0)\n Default  value - 0; empty values allowed - value 2 will be used)');
               
               %degree : of the polynomial kernel to be used by the C-SVM
               %degree :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               %value {3} : comment : description of the values; 
               degree=parameters({[]},'int16',int16([1 1]),[-Inf Inf],'set degree in kernel function (default 3)\n empty values allowed, default will be used.');
               
               %gamma : in kernel function to be used by the C-SVM
               %gamma :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               %value {'1/number_of_features'} : comment : description of the values; 
               gamma=parameters({[]},'double',int16([1 1]),[0 Inf],'set gamma in kernel function (default 1/number_of_features)\n empty values allowed, default will be used.');
               
               %coef0 : set coef0 in kernel function (default 0) to be used by the C-SVM
               %coef0 :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               %value {0} : comment : description of the values; 
               coef0=parameters({[]},'int16',int16([1 1]),[-Inf Inf],'set coef0 in kernel function (default 0)\n empty values allowed, default will be used.');
               
               %nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
               %nu :data_type 'double' : dimension [1 1] : [0 1] :
               %value {1} : comment : description of the values;
               nu=parameters({[]},'double',int16([1 1]),[0 1],'set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)\n empty values allowed, default will be used.');
               
               %cost : set the parameter C of C-SVC (default 1)
               %cost :data_type 'double' : dimension [1 1] : [-Inf Inf] :
               %value {1} : comment : description of the values; 
               cost=parameters({[]},'double',int16([1 1]),[-Inf Inf],'set the parameter C of C-SVC (default 1)\n empty values allowed, default will be used.');
               
               %cachesize : set cache memory size in MB (default 100)
               %cachesize :data_type 'double' : dimension [1 1] : [1 Inf] :
               %value {100} : comment : description of the values; 
               cachesize=parameters({[]},'double',int16([1 1]),[1 Inf],'set cache memory size in MB (default 100)\n empty values allowed, default will be used.');
               
               %epsilon : set tolerance of termination criterion (default 0.001)
               %epsilon :data_type 'double' : dimension [1 1] : [0 1] :
               %value {0.0001} : comment : description of the values; 
               epsilon=parameters({[]},'double',int16([1 1]),[0 1],'set tolerance of termination criterion (default 0.001)\n empty values allowed, default will be used.');
               
               %epsilon_svr : set the epsilon in loss function of epsilon-SVR (default 0.1)
               %epsilon_svr :data_type 'double' : dimension [1 1] : [0 1] :
               %value {0.1} : comment : description of the values; 
               epsilon_svr=parameters({[]},'double',int16([1 1]),[0 1],'set the epsilon in loss function of epsilon-SVR (default 0.1)\n empty values allowed, default will be used.');
               
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
               class_weight=parameters({[]},'double','int16([1 number_of_classes])',[0 Inf],'set the parameter C of class i to weight*C, for C-SVC (default 1)\n empty values allowed, default will be used.');
               
               %weight_data_instances : set the parameter C of data instance i to weight*C, for C-SVC (default 1)
               %weight_data_instances :data_type 'double' : dimension [1 number_of_classes] : [0 Inf] :
               %value {'ones(1,number_of_examples)'} : comment : description of the values; 
               weight_data_instances=parameters({'ones(1,number_of_examples)'},'double','int16([1 number_of_examples])',[0 Inf],'set the parameter C of data instance i to weight*C, for C-SVC (default 1).');
               