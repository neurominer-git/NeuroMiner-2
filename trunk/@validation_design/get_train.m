function train=get_train(val,data)
%   GET_TRAIN (VALIDATION_DESIGN class)
%   GET_TRAIN (VALIDATION_DESIGN class) receives a data_class object, a
%   validation_design object.
%
%   See also VALIDATION_DESIGN, DATA_CLASS.

%   GET_TRAIN (VALIDATION_DESIGN class)  revision history:
%   Date of creation: 21 May 2014 beta (Helena)
%   Creator: Carlos Cabral
if nargin==2
    %% Overture: Input checking
    if ~all(isvalidation_design(val))
        error('get_train:FunctionError',['Undefined function '' get_train (validation_design class) '' for the first input argument of type ''' class(val) ''' (First input argument must be a validation class object).']);
    end
    if ~isdata_class(data)
        error('get_train:FunctionError',['Undefined function '' get_train (validation_design class) '' for the second input argument of type ''' class(data) ''' (Second input argument must be a data_class class object).']);
    end
%     if ~isnumeric(coordinates)
%         error('get_train:FunctionError',['Undefined function '' get_train (validation_design class) '' for the third input argument of type ''' class(coordinates) ''' (Third input argument must be numeric).']);
%     elseif numel(coordinates)~=1
%         error('get_train:FunctionError',['Invalid number of elements ' num2str(numel(coordinates)) ' for the third input of the function '' get_train '' (validation_design class) number of elements should be 1']);
%     elseif round(coordinates)~=coordinates
%         error('get_train:FunctionError',['Undefined function '' get_train (validation_design class) '' for the third input argument of dimension ''' num3str(size(coordinates)) ''' (Third input argument must be of the size [1 1]).']);
%     end
    %% Act: Select the indices that correspond to the train set
    %needs to be decided with Nikos the exact way of transporting the
    %information
    train_ind=val.train;
    train_targets=val.target_values(train_ind);
    %% Finale: Producing the train data_class object
    train=data_class.empty(0,numel(data));
    for i=1:numel(val)
        try train(i)=data(i).data_selector(train_ind);
        catch err
            rethrow(err)
        end
    end
else
    error('get_train:FunctionError','Invalid number of arguments for function '' get_train (validation_design class). (number of arguments is not 3)');
end
end