classdef cut_off
       %Summary of CUT_OFF:
    %   The CUT_OFF class controls the cut_off superclass in NM2 framework.
    %
    %   CUT_OFF properties:
    %   operation_mode - ...
    %   threshold - ...
    %   direction - ...
    
    %   CUT_OFF revision history:
    %   Date of creation: 10 August 2016
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        operation_mode; %FORMAT: string; Description : String describing the implemented operation mode. Available options include: "percentile","number_of_features","cumulative" and "threshold". 
        threshold;%FORMAT: double; DESCRIPTION: Number describing the cut off limit.
        direction;  %FORMAT: string; DESCRIPTION : String defining the relational operation used in operation_mode with threshold. Valid values are "==","~=",">",">=","<","<=".
    end
    
     methods
        function obj = cut_off(oper,thresh,dire)
            if nargin==0
               obj.operation_mode='percentile';
               obj.threshold=75;
               obj.direction='>=';
            else
                if (nargin==3)
                    %operation_mode
                    if ~any([isqual(oper,'percentile'),isqual(oper,'number_of_features'),isqual(oper,'cumulative'),isqual(oper,'threshol')]);
                        error('cut_off:Incompability_error','Error using cut_off \nFirst input (operation_mode) is invalid.')
                    end
                    %threshold
                    if ~all([isdouble(thresh) numel(thresh)==1])
                       error('cut_off:Incompability_error','Error using cut_off \nSecond input (threshold) is invalid.') 
                    end
                    %direction
                    if ~any([isqual(dire,'=='),isqual(dir,'~='),isqual(dire,'>'),isqual(dire,'<'),isqual(dire,'<=')],isqual(dire,'>='));
                        error('cut_off:Incompability_error','Error using cut_off \nThird input (direction) is invalid.')
                    end
                    obj.operation_mode=oper;
                    obj.threshold=thresh;
                    obj.direction=dire;
                else
                    error('cut_off:Incompability_error','Invalid numer of arguments specified please read the cut_off class documentation.')
                end
            end
        end
    end
end