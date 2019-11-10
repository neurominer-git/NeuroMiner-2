function opt_string =param2optstring(r,label)
%PARAM2OPTSTRING transforms the SVM parameters into an option string.
%   RES=PARAM2OPTSTRING(R) takes the structure of parameters (R) that
%   defines parameters properties of an XXX_SVM_LIBSVM class object and
%   returns the correspondent option string to be used in the
%   training process (RES).
%
%   R is a structure of parameters class objects inherited from a
%   XXX_SVM_LIBSVM class object.
%
%   RES is a string defining the options to be used in the training process
%   of LIBSVM.
%
%   RES=PARAM2OPTSTRING(R,L) takes the structure of parameters (R) that
%   defines parameters properties of an XXX_SVM_LIBSVM class object
%   together with the class labels and returns the correspondent option
%   string to be used in the training process (RES).
%
%   L is a vector specifying the classes in the classification problem,
%   only valid for C_SVM_LIBSVM class elements.
%
%   See also PARAMETERS, C_SVM_LIBSVM_3_12.

%   PARAM2OPTSTRING (SVM_LIBSVM_3_12 class)  revision history:
%   Date of creation: 13 March 2015 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==1||nargin==2
    if isstruct(r)
        aux_fields=fieldnames(r);
        for i=1:numel(aux_fields)
            if isparameters(r.(aux_fields{i}))
                if isempty(r.(aux_fields{i}))
                    error('param2optstring:InputError','Undefined function '' param2optstring  '' for the input structure with fields containing empty PARAMETERS class objects. (First input argument must be a structure of non empty PARAMETERS class objects.).');
                end
            else
                error('param2optstring:InputError',['Undefined function '' param2optstring  '' for the input structure with fields of type ''' class(r.(aux_fields{i})) ''' (First input argument must be a structure of non empty PARAMETERS class objects.).']);
            end
        end
    else
        error('param2optstring:InputError',['Undefined function '' param2optstring  '' for the input argument of type ''' class(r) ''' (First input argument must be a structure of non empty PARAMETERS class objects.).']);
    end
    if nargin==2
        if isvector(label)&&isnumeric(label)
            if ~isequal(label,round(label))
                error('param2optstring:InputError','Undefined function '' param2optstring  '' for non integer vector input argument '' (Second input argument must be a vector of integers.).');
            end
        else
            error('param2optstring:InputError','Undefined function '' param2optstring  '' for non vector input argument '' (Second input argument must be a vector of integers.).');
        end
    end
else
    error('param2optstring:InputError','Invalid number of arguments for function '' param2optstring. (number of expected arguments is 1 or 2)');
end
%% Act : Building the string
opt_string='pre-';
for i=1:numel(aux_fields)
    aux_param=r.(aux_fields{i});
    switch aux_fields{i}
        case 'kernel_type'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -t ' num2str(aux_param.value{1})];
            end
        case 'degree'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -d ' num2str(aux_param.value{1})];
            end
        case 'gamma'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -g ' num2str(aux_param.value{1})];
            end
        case 'coef0'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -r ' num2str(aux_param.value{1})];
            end
        case 'cost'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -c ' num2str(aux_param.value{1})];
            end
        case 'nu'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -n ' num2str(aux_param.value{1})];
            end
        case 'cachesize'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -m ' num2str(aux_param.value{1})];
            end
        case 'epsilon'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -e ' num2str(aux_param.value{1})];
            end
        case 'epsilon_svr'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -p ' num2str(aux_param.value{1})];
            end
        case 'shrinking'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -h ' num2str(aux_param.value{1})];
            end
        case 'probability_estimates'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -b ' num2str(aux_param.value{1})];
            end
        case 'type'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -s ' num2str(aux_param.value{1})];
            end
        case 'bias'
            if ~isempty(aux_param.value{1})
                opt_string=[opt_string ' -B ' num2str(aux_param.value{1})];
            end
        case 'class_weight'
            if ~isempty(aux_param.value{1})
                if exist(label,'var')
                    vals=aux_param.value{1};
                    if numel(vals)==numel(label)
                        sub_string='pre-';
                        for j=1:numel(label)
                            sub_string=[sub_string ' w' num2str(label(j)) ' ' num2str(vals(j))];
                        end
                        sub_string=sub_string(5:end);
                    else
                        error('param2optstring:IncompatilityError','Provided class weights parameters do not agree with the labels.');
                    end
                    opt_string=[opt_string ' ' sub_string];
                else
                    error('param2optstring:IncompatilityError','To use the class weight parameters option the class labels must be provided.');
                end
            end
    end
end
%% Final: Prunning the string
opt_string=opt_string(5:end);
end