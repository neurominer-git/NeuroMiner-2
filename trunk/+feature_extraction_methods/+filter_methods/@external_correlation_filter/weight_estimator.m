function filt_obj=weight_estimator(filt_obj,data_obj)
%WEIGHT_ESTIMATOR (CORRELATION_FILTER class) performs feature extraction 
%   FILT_OBJ=WEIGHT_ESTIMATOR(FILT_OBJ,FEATURES) estimates the
%   correlation weight of each feature in the data class object FEATURES
%
%   


%   FILT_OBJ=WEIGHT_ESTIMATOR(FILT_OBJ,DATA)

%   WEIGHT_ESTIMATOR revision history:
%   Date of creation: 22 July 2016 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    import filter_methods.*
    if numel(filt_obj)~=1
        error('weight_estimator:InputError',['Invalid number of elements (' num2str(numel(filt_obj)) ') for the first input of function '' weight_estimator (correlation_filter class).']);
    elseif ~isdata_class(data_obj)
        error('weight_estimator:InputError',['Undefined function '' weight_estimator (correlation_filter class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('weight_estimator:InputError',['weight_estimator:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' weight_estimator (correlation_filter class).']);
    else
        dummy_correlation_filter=filter_methods.external_correlation_filter;
        dummy_correlation_filter=parameters_eval(dummy_correlation_filter.parameters,data_obj);
        filt_obj.parameters=parameters_eval(filt_obj.parameters,data_obj);
        try
            param_report=parameters_checker(dummy_correlation_filter,filt_obj.parameters,data_obj);
        catch err
            rethrow(err);
        end
        if ~param_report.flag
            param_report.reporter;
            error('weight_estimator:IncompatibilityError','Incompatible parameters provided to '' weight_estimator (correlation_filter class) ''. Please check the inputs more details can be found in the error_log');
        end
        clear dummy_correlation_filter
    end
    %% Act: Proceeding to the weight map estimation
    import feature_extraction_methods.auxiliary.*
    try eval(['target=data_obj.' filt_obj.parameters.target.value{1} ';']);
    catch err
        rethrow(err)
    end
    if iscell(target)
       target=cell2mat(target);
    end
    corr_filter=arrayfun(@(j) abs(corr(data_obj.data(:,j),target)),1:size(data_obj.data,2))';
    external_filt=data_obj.feature_grouping;
    %% ACT 2: Combining the patterns
    switch filt_obj.parameters.mode.value{1}
        case 'sort_descend'
            [~,order_corr]=sort(corr_filter,'descend');
            [~,order_ext]=sort(external_filt,'descend');
            filt_obj.model.weight_vector=order_corr+order_ext;
        case 'sort_ascend'
            [~,order_corr]=sort(corr_filter,'ascend');
            [~,order_ext]=sort(external_filt,'ascend');
            filt_obj.model.weight_vector=order_corr+order_ext;
        case 'sum'
            filt_obj.model.weight_vector=corr_filter+external_filt;
        case 'diff'
            filt_obj.model.weight_vector=corr_filter-external_filt;
        case 'times'
            filt_obj.model.weight_vector=corr_filter.*external_filt;
        case 'divide'
            filt_obj.model.weight_vector=corr_filter./(external_filt+eps);
    end
else
    error('weight_estimator:InputError','Invalid number of arguments for function '' weight_estimator (correlation_filter class). (number of arguments is not 2)');
end
end