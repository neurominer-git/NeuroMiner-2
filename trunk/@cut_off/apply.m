function filter=apply(cut_off,vec)
%APPLY (CUT_OFF class) performs cut_off
%   FILTER=APPLY(CUT_OFF_OBJ,VEC) applies the cut off defined by
%   CUT_OFF_OBJ to VEC outputing the correspondent filter vector FILTER.
%
%   VEC is a numerical vector
%
%   FILTER is a logical vector, of the same size as VEC with true values
%   for points that are to be kept and false otherwise.


%   FILTER=APPLY(CUT_OFF_OBJ,VEC)

%   APPLY revision history:
%   Date of creation: 10 August 2016 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==2
    if numel(cut_off)~=1
        error('apply:InputError',['Invalid number of elements (' num2str(numel(cut_off)) ') for the first input of function '' apply (cut_off class).']);
    elseif ~isnumeric(vec)
        error('apply:InputError',['Undefined function '' apply (cut_off class) '' for the input argument of type ''' class(vec) ''' (Second input argument must be numerical class object).']);
    elseif ~isvector(vec)
        error('apply:InputError',['apply:IncompatibilityError','Invalid size for the second input of function '' apply (cut_off class).']);
    end
    %% Act: Proceeding to the cut_off process
    cutt_off_mode=cut_off.operation_mode;
    cutt_off_thresh=cut_off.threshold;
    cutt_off_direction=cut_off.direction;
    switch cutt_off_mode
        case 'percentile'
            current_thresh=prctile(vec,cutt_off_thresh);
            try eval(['filter=vec' cutt_off_direction num2str(current_thresh) ';']);
            catch err
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the cut_off_direction inputs more details can be found in the error_log');
            end
        case 'number_of_features'
            if ~isempty(strfind(cutt_off_direction,'<'))
               cutt_off_direction='descend';
            else
                cutt_off_direction='ascend';
            end
            try [~,sorted_val]=sort(vec,cutt_off_direction);
            catch err
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the cut_off_direction inputs more details can be found in the error_log');
            end
            filter=false(size(sorted_val));
            filter(sorted_val(1:cutt_off_thresh))=true;
        case 'threshold'
            try eval(['filter=vec' cutt_off_direction num2str(cutt_off_thresh) ';']);
            catch err
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the cut_off_direction inputs more details can be found in the error_log');
            end
        case 'cumulative-percentile'
            vec=arrayfun(@(x) sum(vec(1:x)),1:numel(vec));
            current_thresh=prctile(vec,cutt_off_thresh);
            try eval(['filter=vec' cutt_off_direction num2str(current_thresh) ';']);
            catch err
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the cut_off_direction inputs more details can be found in the error_log');
            end
        case 'cumulative-threshold'
            vec=arrayfun(@(x) sum(vec(1:x)),1:numel(vec));
            try eval(['filter=vec' cutt_off_direction num2str(cutt_off_thresh) ';']);
            catch err
                error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the cut_off_direction inputs more details can be found in the error_log');
            end
        otherwise
            error('apply:IncompatibilityError','Incompatible parameters provided to '' apply (component_analysis class) ''. Please check the cut_off inputs more details can be found in the error_log');
    end
else
    error('apply:InputError','Invalid number of arguments for function '' apply (cut_off class). (number of arguments is not 2)');
end
end