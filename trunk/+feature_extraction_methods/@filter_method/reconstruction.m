function recon_vec=reconstruction(filt_obj,weight_vector)
%RECONSTRUCTION (FILTER_METHOD class) performs reconstruction to the
%original data space of a weight vector resulting of the application of a
%evalution method to a data set that underwent filtering.
%   RECON_VEC=RECONSTRUCTION(FILT_OBJ,WEIGHT_VECTOR) reconstructs the
%   weight vector WEIGHT_VECTOR to its original space.

%   RECON_VEC=RECONSTRUCTION(FILT_OBJ,EVALUATION_OBJ)

%   RECONSTRUCTION revision history:
%   Date of creation: 19 July 2016 beta (Helena)
%   Creator: Carlos Cabral
%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    import filter_methods.*
    if numel(filt_obj)~=1
        error('reconstruction:InputError',['Invalid number of elements (' num2str(numel(filt_obj)) ') for the first input of function '' reconstruction (filter_method class).']);
%     elseif ~isevalpackage(weight_vector)
%         error('reconstruction:InputError',['Undefined function '' reconstruction (filter_method class) '' for the input argument of type ''' class(weight_vector) ''' (Second input argument must be a data_class class object).']);
    elseif ~isnumeric(weight_vector)
        error('reconstruction:InputError',['reconstruction:IncompatibilityError','Invalid data type (' class(weight_vector) ') for the  second input of function '' reconstruction (filter_method class).']);
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=filt_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    switch status_fe %selecting the functioning mode
        case 'application_ready'
            %% filtering the data
            filter=filt_obj.model.cut_off.apply(filt_obj.model.weight_vector);
            if size(weight_vector,2)~=sum(filter)
               error('reconstruction:FunctionError',['Error in '' reconstruction (filter_method class) '' incompatible input arguments of type. The number of features defined in the filter " ' num2str(sum(filter)) ' " does not match the number of features in the evaluation process " ' num2str(size(weight_vector.model.w,1)) ' ".']);
            end
            
        otherwise
            error('reconstruction:FunctionError',['Undefined function '' reconstruction (filter_method class) '' for the ' status_fe ' input argument of type ''' class(filt_obj) '''.']);
    end
    %% Finale: Building the reconstruction vectors
            recon_vec=nan(numel(filter),size(weight_vector,1));
            recon_vec(filter,:)=weight_vector;
else
    error('reconstruction:InputError','Invalid number of arguments for function '' reconstruction (filter_method class). (number of arguments is not 2)');
end
end