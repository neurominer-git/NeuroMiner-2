classdef chain
    %Summary of CHAIN:
    %   The CHAIN class defines a full chain of processing, from the
    %   simplest pipelines to the more complex ones. CHAIN class elements
    %   can run inside a bigger CHAIN class element to perform optimization
    %   or ensemble learning.
    %
    %   CHAIN properties:
    %   data_class - ...
    %   validation - ...
    %   feature_extraction - ...
    %   evaluation - ...
    %   ensemble_learning - ...
    %   result - ...
    
    %   CHAIN revision history:
    %   Date of creation: 9 September 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        input_data;  %FORMAT: input_data class; DESCRIPTION: Data to be analyzed.
        validation;  %FORMAT: cv class element; DESCRIPTION: Validation design/designs to be used.
        feature_extraction; %FORMAT: feature_extraction class element: DESCRIPTION: Feature Extraction definition.
        evaluation; %FORMAT: evaluation class element; DESCRIPTION: Evaluation strategy definition.
        ensemble_learning; %FORMAT: ensemble_learning class element; DESCRIPTION: Ensemble learning definition - this field can be empty or have a dummy ensemble class element when no ensemble learning is defined.
        result; %FORMAT: results class element; DESCRIPTION: Final result of the class chain processing 
    end
    
    methods
        function obj = chain (data,validation,feat_extraction,eval,ensembl_learning)
            if (nargin>0)
                obj.input_data = data;
                obj.validation = validation;
                obj.feature_extraction = feat_extraction;
                obj.evaluation = eval;
                obj.ensemble_learning = ensembl_learning;
            end
        end
    end
end