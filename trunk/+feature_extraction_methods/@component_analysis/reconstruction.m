function recon_vec=reconstruction(comp_obj,weight_vector)
%RECONSTRUCTION (COMPONENT_ANALYSIS class) performs reconstruction to the
%original data space of a weight vector resulting of the application of a
%evalution method to a data set that underwent component analysis.
%   RECON_VEC=RECONSTRUCTION(FILT_OBJ,WEIGHT_VECTOR) reconstructs the
%   weight vector in the WEIGHT_VECTOR to its original space.

%   RECON_VEC=RECONSTRUCTION(COMP_OBJ,WEIGHT_VECTOR)

%   RECONSTRUCTION revision history:
%   Date of creation: 11 August 2016 beta (Helena)
%   Creator: Carlos Cabral
%% Overture: Input checking
if nargin==2
    import feature_extraction_methods.*
    import component_analysis.*
    if numel(comp_obj)~=1
        error('reconstruction:InputError',['Invalid number of elements (' num2str(numel(comp_obj)) ') for the first input of function '' reconstruction (component_analysis_methods class).']);
%     elseif ~isevalpackage(evaluation_obj)
%         error('reconstruction:InputError',['Undefined function '' reconstruction (component_analysis_methods class) '' for the input argument of type ''' class(evaluation_obj) ''' (Second input argument must be a data_class class object).']);
    elseif ~isnumeric(weight_vector)
        error('reconstruction:InputError',['reconstruction:IncompatibilityError','Invalid data type of  (' class(weight_vector) ') for the  second input of function '' reconstruction (component_analysis_methods class).']);
    end
    %% Act: Proceeding to the feature estimation/application process
    status_fe=comp_obj.status{1};
    import feature_extraction_methods.auxiliary.*
    switch status_fe %selecting the functioning mode
        case 'application_ready'
            aux_data=data_class(weight_vector,'dummy',{'1'},struct([]),{1},'binary_classification',[],'dummy');
            try [~,recon_vec]=comp_obj.transformation_handler(aux_data,'reconstruction');
            catch err
                rethrow(err)
            end
            recon_vec=recon_vec.data;
        otherwise
            error('reconstruction:FunctionError',['Undefined function '' reconstruction (component_analysis_methods class) '' for the ' status_fe ' input argument of type ''' class(comp_obj) '''.']);
    end
    %% Finale
else
    error('reconstruction:InputError','Invalid number of arguments for function '' reconstruction (component_analysis_methods class). (number of arguments is not 2)');
end
end