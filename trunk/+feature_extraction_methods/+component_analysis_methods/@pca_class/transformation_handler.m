function [comp_obj,data_obj]=transformation_handler(comp_obj,data_obj,mod,weights)
%TRANSFORMATION_HANDLER (PCA_CLASS class) handles all the aspects concerned
%with the transformation in the PCA_CLASS.
%   [COMP_OBJ,DATA_OBJ]=TRANSFORMATION_HANDLER(COMP_OBJ,DATA_OBJ,MODE)
%   deals with transformation process in the PCA_class.
%
%   COMP_OBJ is a a PCA_CLASS object containing the information for the PCA
%   analysis.
%
%   DATA_OBJ is an data_class object with the data to be used.
%
%   MODE is a string defining the operation mode, available modes:
%   
%       "estimation" the data in DATA_OBJ is used to estimate a
%       transformation and that same transformation is applied to it.
%
%       "application" COMP_OBJ already contains a transformation that is
%       applied to the data in DATA_OBJ.
%
%       "reconstruction_centered" COMP_OBJ already contains a
%       transformation that is inverted and subsequently applied to the
%       data in DATA_OBJ in order to obtain the data in the original space. 
%
%       "reconstruction" COMP_OBJ already contains a transformation that is
%       inverted and subsequently applied to the data in DATA_OBJ in order
%       to obtain the data in the original space (non centered).
%
%   
%   COMP_OBJ (OUTPUT) is a PCA_CLASS object with a completely estimated
%   transformation and all its information including eigenvalues.
%
%   DATA_OBJ (OUTPUT) is a DATA_CLASS object in the PCA space.
%
%   [COMP_OBJ,DATA_OBJ]=TRANSFORMATION_HANDLER(COMP_OBJ,DATA_OBJ,MODE,WEIGHTS)
%
%   WEIGHTS is a vector with the same number of elements as features in the
%   DATA_CLASS object that will be used for the weighted PCA estimation.
%   WEIGHTS is only used when COMP_OBJ's proporty weights is "external".

%   [COMP_OBJ,DATA_OBJ]=TRANSFORMATION_HANDLER(COMP_OBJ,DATA_OBJ,MODE)

%   TRANSFORMATION_HANDLER revision history:
%   Date of creation: 11 August 2016 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==3||nargin==4
    import feature_extraction_methods.*
    import component_analysis_methods.*
    if numel(comp_obj)~=1
        error('transformation_handler:InputError',['Invalid number of elements (' num2str(numel(comp_obj)) ') for the first input of function '' transformation_handler (pca_class class).']);
    elseif ~isdata_class(data_obj)
        error('transformation_handler:InputError',['Undefined function '' transformation_handler (pca_class class) '' for the input argument of type ''' class(data_obj) ''' (Second input argument must be a data_class class object).']);
    elseif numel(data_obj)~=1
        error('transformation_handler:InputError',['transformation_handler:IncompatibilityError','Invalid number of elements (' num2str(numel(data_obj)) ') for the  second input of function '' transformation_handler (pca_class class).']);
    end
    if isequal(comp_obj.parameters.weights.value{1},'external')
       if nargin==4
          if isvector(weights)&&isnumeric(weights)
             if numel(weights)==data_obj.data_reporter.number_of_features
                if size(weights,2)==1
                   weights=weights';
                end
             else
                  error('transformation_handler:InputError',['transformation_handler:IncompatibilityError','Invalid size of fourth input (weights) of function '' transformation_handler (pca_class class), a numerical vector with as many elements as features in the data is expected.']); 
             end
          else
             error('transformation_handler:InputError',['transformation_handler:IncompatibilityError','Invalid data_type provided for the fourth (weights) input of function '' transformation_handler (pca_class class), a numerical vector is expected.']); 
          end
       else
           error('transformation_handler:InputError','Invalid number of arguments for function '' transformation_handler (pca_class class) in external weights mode. (number of arguments is not 4)');
       end
    end
    dummy_pca_class=component_analysis_methods.pca_class;
    dummy_pca_class=parameters_eval(dummy_pca_class.parameters,data_obj);
    comp_obj.parameters=parameters_eval(comp_obj.parameters,data_obj);
    try
        param_report=parameters_checker(dummy_pca_class,comp_obj.parameters,data_obj);
    catch err
        rethrow(err);
    end
    if ~param_report.flag
        param_report.reporter;
        error('transformation_handler:IncompatibilityError','Incompatible parameters provided to '' transformation_handler (pca_class class) ''. Please check the inputs more details can be found in the error_log');
    end
    clear dummy_pca_class
    %% Act: Proceeding to the weight map estimation
    switch mod
        case 'estimation'
            switch comp_obj.parameters.weights.value{1}
                case 'none'
                    [comp_obj.model.transformation,data_transform,comp_obj.model.component_weight,comp_obj.model.statistics]=pca(data_obj.data);
                    comp_obj.model.bias=mean(data_obj.data);
                    data_obj=data_class(data_transform,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,[],[data_obj.descriptor '| pca_class ' comp_obj.parameter_descriptor ]);
                case 'external'
                    [transformation,~,comp_obj.model.component_weight]=pca(data_obj.data,'VariableWeights',weights);
                    comp_obj.model.bias=mean(data_obj.data);
                    comp_obj.model.transformation=sqrt(diag(weights))*transformation;
                    data_obj=data_class((data_obj.data-ones(data_obj.data_reporter.number_of_examples,1)*comp_obj.model.bias)*comp_obj.model.transformation,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,[],[data_obj.descriptor '| pca_class ' comp_obj.parameter_descriptor ]);
                case 'variance'
                    [transformation,~,comp_obj.model.component_weight]=pca(data_obj.data,'VariableWeights','variance');
                    comp_obj.model.transformation=inv(diag(std(data_obj.data)))*transformation;
                    comp_obj.model.bias=mean(data_obj.data);
                    data_obj=data_class((data_obj.data-ones(data_obj.data_reporter.number_of_examples,1)*comp_obj.model.bias)*comp_obj.model.transformation,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,[],[data_obj.descriptor '| pca_class ' comp_obj.parameter_descriptor ]);
            end
            
        case 'application'
             data_obj=data_class((data_obj.data-ones(data_obj.data_reporter.number_of_examples,1)*comp_obj.model.bias)*comp_obj.model.transformation,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,[],[data_obj.descriptor '| pca_class ' comp_obj.parameter_descriptor ]);
        case 'reconstruction'
             data_obj=data_class(data_obj.data*comp_obj.model.transformation',data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,[],[data_obj.descriptor '| pca_class ' comp_obj.parameter_descriptor ]);
        case 'reconstruction_centered'
            data_obj=data_class(data_obj.data*comp_obj.model.transformation'+ones(data_obj.data_reporter.number_of_examples,1)*comp_obj.model.bias,data_obj.type,data_obj.dbcode,data_obj.covariates,data_obj.target_values,data_obj.evaluation_type,[],[data_obj.descriptor '| pca_class ' comp_obj.parameter_descriptor ]);
        otherwise
            error('transformation_handler:IncompatibilityError','Invalide MODE input provided to '' transformation_handler (pca_class class) ''');
    end
else
    error('transformation_handler:InputError','Invalid number of arguments for function '' transformation_handler (pca_class class). (number of arguments is not 3 or 4)');
end
end