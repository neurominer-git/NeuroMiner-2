classdef validation_design
    %Summary of VALIDATION_DESIGN:
    %   The VALIDATION_DESIGN class defines a fold of the validation
    %   scheme.
    %
    %   VALIDATION_DESIGN properties:
    %   train - %FORMAT: logical array (Nx1); DESCRIPTION: Logical vector 
    %   defining the examples to be used as training set, N=number of examples.
    %   test - %FORMAT: logical array (Nx1); DESCRIPTION: Logical vector 
    %   defining the examples to be used as test set, N=number of examples.
    %   design - %FORMAT: validation_design class object ; DESCRIPTION: 
    %   Element describing the design of a inner validation scheme in the 
    %   training set.  
    %   depth - %FORMAT: integer ; DESCRIPTION: Number of inner designs.
    %   target_values - %FORMAT: cell array; DESCRIPTION: Target values to
    %   be used in the analysis (full set of target_labels
    %   test + train labels). Possible values:
    %   1 - empty Nx1 cell for unsupervised learning;
    %   2 - Nxd cell of integers or chars for classification experiments (also Nx1 cell of logicals);
    %   3 - Nxd cell of doubles for regression;
    %   4 - Nxd cell of logicals (d>1) for ranking
    %   evaluation_type - %FORMAT: String ; DESCRIPTION: Evaluation_type
    %   property inherited from the data_class element that originated the
    %   validation_design.
    
    %   VALIDATION_DESIGN history:
    %   Date of creation: 02 September 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        train;  %FORMAT: logical array (Nx1);
        test;  %FORMAT: logical array (Nx1); 
        design;  %FORMAT: validation_design class object;
        depth; %FORMAT: integer;
        target_values;%FORMAT: cell array;
        evaluation_type; %FORMAT: string;
    end
    methods
        function obj = validation_design (trains,tests,label,eval_type,designs,depths)
            if (nargin>0)
                if (nargin==4)
                    obj=validation_design();
                    %train
                    if islogical(trains) %data type
                        obj.train=trains;
                    else
                        error('Validation_Design:Class_error','Error using validation_design \nFirst input must be a logical.')
                    end
                    if (numel(size(trains))~=2)||(sum(size(trains)==1)<1) %dimensions
                       error('Validation_Design:Class_error','Error using validation_design \nInvalid dimensions for the first input.') 
                    end
                    %test
                    if islogical(tests) %data_type
                        obj.test=tests;
                    else
                        error('Validation_Design:Class_error','Error using validation_design \nSecond input must be a logical.')
                    end 
                    if (numel(size(trains))~=2)||(sum(size(trains)==1)<1) %dimensions
                       error('Validation_Design:Class_error','Error using validation_design \nInvalid dimensions for the first input.') 
                    end
                    % train and test
                    if numel(trains)~=numel(tests) %dimensions
                        error('Validation_Design:Class_error','Error using validation_design \nFirst and second input must have the dimensions.')
                    end
                    % labels
                    if iscell(label)
                        aux_type=unique(cellfun(@class,label,'UniformOutput',false));
                        if numel(aux_type)==1
                            if numel(label)==numel(trains)
                            obj.target_values=label;
                            else
                                error('Validation_Design:Class_error','target_values propriety dimensions are inconsistent, please read VALIDATION_DESIGN class documentation');
                            end
                        else
                            error('Validation_Design:Class_error','target_values propriety values are inconsistent, please read VALIDATION_DESIGN class documentation');
                        end
                    else
                        error('Validation_Design:Class_error','target_values propriety is invalid, please read  VALIDATION_DESIGN class documentation');
                    end
                    if ~ischar(eval_type)
                        error('Validation_Design:Class_error',['Undefined class "validation_Design" for ' class(eval_type) ' data type of "evaluation_type" properties, please read VALIDATION_TYPE class documentation']);
                    elseif ~any(strcmp(eval_type,{'binary_classification','multiclass_classification','multi_labelled','hierarchical','regression','unsupervised_learning','semisupervised_learning'}));
                        error('Validation_Design:Class_error',['Undefined class "validation_design" for ' eval_type ' "evaluation_type" propriety, please read VALIDATION_DESIGN class documentation']);
                    end
                elseif (nargin==5)
                    obj=validation_design(trains,tests,label,eval_type);
                    if isvalidation_design(designs)
                        obj.design=designs;
                    else
                        error('Validation_Design:Class_error','Error using validation_design \n Third input must be validation_design object.')
                    end
                    if numel(designs)<2
                        if isempty(designs.depth)
                            val=0;
                        else
                            val=designs.depth;
                        end
                    else
                        aux_designs=int16(zeros(1,numel(designs)));
                        for i=1:numel(designs)
                            aux_designs(i)=designs.depth;
                        end
                        if numel(unique(aux_designs))==1
                           val=unique(aux_designs);
                        else
                           error('Validation_Design:Class_error','Error using validation_design \n Third input validation_design objects property depth invalid.') 
                        end
                    end
                    obj.depth=int16(1+val);
                elseif (nargin==6)
                    obj=validation_design(trains,tests,label,designs);
                    if (isinteger(depths)||round(depths)==depths)
                        depths=int16(depths);
                        obj.depth=depths;
                    else
                        error('Validation_Design:Class_error','Error using validation_design \n Fourth input must be an integer.')
                    end
                    if isempty(designs.depth)
                        val=0;
                    else
                        val=designs.depth;
                    end
                    if depths~=(val+1)
                       error('Validation_Design:Class_error','Error using validation_design \n Depth and Designs are not valid.') 
                    end
                else
                    error('Validation_Design:Class_error','Error using validation_design \n Invalid numer of arguments specified please read the validation_design class documentation.')
                end
            end
        end
    end
end