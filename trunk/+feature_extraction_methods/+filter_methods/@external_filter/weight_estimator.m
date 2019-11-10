function filt_obj=weight_estimator(filt_obj,data_obj)
%WEIGHT_ESTIMATOR (EXTERNAL_FILTER class) performs feature extraction 
%   FILT_OBJ=WEIGHT_ESTIMATOR(FILT_OBJ,FEATURES) estimates the
%   external weight of each feature in the data class object FEATURES
%
%   


%   FILT_OBJ=WEIGHT_ESTIMATOR(FILT_OBJ,DATA)

%   WEIGHT_ESTIMATOR revision history:
%   Date of creation: 19 July 2016 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    import filter_methods.*
    if numel(filt_obj)~=1
        error('weight_estimator:InputError',['Invalid number of elements (' num2str(numel(filt_obj)) ') for the first input of function '' weight_estimator (external_filter class).']);
    elseif ~isdata_class(data_obj)
        error('weight_estimator:InputError',['Undefined function '' weight_estimator (external_filter class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('weight_estimator:InputError',['weight_estimator:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' weight_estimator (external_filter class).']);
    end
    %% Act: Proceeding to the weight map estimation
    filt_obj.model.weight_vector=data_obj.feature_grouping;
else
    error('weight_estimator:InputError','Invalid number of arguments for function '' weight_estimator (external_filter class). (number of arguments is not 2)');
end
end