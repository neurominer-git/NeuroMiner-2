function rpt=save_element(r,filename,location,flag)
%SAVE_ELEMENT (EVALUATION class) save to the disc the EVALUATION elements R.
% RPT=SAVE_ELEMENT (R,FILENAME,LOCATION,FLAG) save the evaluation class
%   elements (R) under the name specified by FILENAME, in the folder
%   LOCATION accordingly to FLAG.
%
%   FILENAME can be a string or a cell of strings, in the first case
%   if the number of elements of R is greater than 1 all the elements of R
%   will be saved with the same name and a suffix indicating its position
%   in the array. In later case, only valid when the number of elements of
%   R is greater that one, FILENAME and R must have the same number of
%   elements and the element R(i) will be saved under the name defined by
%   FILENAME{i}.
%
%   LOCATION can be a string or a cell of strings, in the first case
%   all the elements of R will be saved in the same folder, LOCATION, if
%   LOCATION does not exist it will be created. In later case, only valid
%   when the number of elements of R is greater that one, LOCATION and R
%   must have the same number of elements and the element R(i) will be
%   saved in the folder LOCATION{i}, again, if the folder LOCATION{i} does
%   not exist it will be created.
%
%   FLAG defined the saving mode, if TRUE the program will enter into
%   'economy' mode excluding the Support Vectors (SVs field in the model
%   structure) from the saved mode. If FLAG is FALSE the complete model is
%   saved.
%   FLAG is a logic array, in the case that the number of elements of FLAG
%   is one all the elements of R will be saved in the same mode otherwise,
%   only valid when the number of elements of R is greater that one, FLAG
%   and R must have the same number of elements and the element R(i) will be
%   saved accordingly with the mode defined by FLAG{i}.
%
%   RPT is a REPORT class element or array with the information about the
%   saving process.
%

%   SAVE_ELEMENT (R)
%   See also EVALUATION, APPLY, STATUS

%   SAVE_ELEMENT (EVALUATION class)  revision history:
%   Date of creation: 25 November 2014 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Input checking
if nargin==4
    if ~(iscellstr(filename)||ischar(filename))
        error('save_element:InputError',['Undefined function '' save_element (evaluation class) '' for the input argument of type ''' class(filename) ''' (Second input argument must be a string or a cell of strings).']);
    elseif ~(iscellstr(location)||ischar(location))
        error('save_element:InputError',['Undefined function '' save_element (evaluation class) '' for the input argument of type ''' class(location) ''' (Third input argument must be a string or a cell of strings).']);
    elseif ~(islogical(flag))
        error('save_element:InputError',['Undefined function '' save_element (evaluation class) '' for the input argument of type ''' class(flag) ''' (Fourth input argument must be logical).']);
    end
    if iscell(location)
        if numel(location)~=numel(r)
            error('save_element:IncompatibilityError',['Incompatible parameters provided to '' save_element (evaluation class) ''. The number of elements to be saved (' num2str(numel(r)) ') is not compatible with the number of FILENAMES provided (' num2str(numel(filenames)) ').']);
        end
        loc_flag=true;
    else
        loc_flag=false;
        if ~exist(location,'dir')
            mkdir(location);
        end
        aux_location=location;
    end
    if iscell(filename)
        if numel(filename)~=numel(r)
            error('save_element:IncompatibilityError',['Incompatible parameters provided to '' save_element (evaluation class) ''. The number of elements to be saved (' num2str(numel(r)) ') is not compatible with the number of LOCATIONS provided (' num2str(numel(locations)) ').']);
        end
        for i=numel(filename)
            aux_filename=filename{i};
            aux=regexp(aux_filename, '[/\*:?"<>| ]');
            if ~isempty(aux)
                aux_filename(aux)=[];
                filename{i}=aux_filename;
            end
        end
        file_flag=true;
    else
        file_flag=false;
        aux=regexp(filename, '[/\*:?"<>| ]');
        if ~isempty(aux)
            filename(aux)=[];
        end
        aux_filename=filename;
    end
    if numel(flag)>1
        if numel(flag)~=numel(r)
            error('save_element:IncompatibilityError',['Incompatible parameters provided to '' save_element (evaluation class) ''. The number of elements to be saved (' num2str(numel(r)) ') is not compatible with the number of saving methods provided (' num2str(numel(flags)) ').']);
        end
        flag_flag=true;
    else
        flag_flag=false;
        aux_flag=flag;
    end
    flag_object=numel(r)>1;
    %% Act: Proceeding to the saving process
    for i=1:numel(r)
        if file_flag
            aux_filename=filename{i};
            aux=regexp(aux_filename, '[/\*:?"<>| ]');
            if ~isempty(aux)
                aux_filename(aux)=[];
            end
        elseif flag_object
            aux_filename=[aux_filename '_' num2str(i)];
        end
        if flag_flag
            aux_flag=flag(i);
        end
        if loc_flag
            aux_location=location{i};
            if ~exist(aux_location,'dir')
                mkdir(aux_location);
            end
        end
        %transform the element to be saved accordingly with the economy flag
        if aux_flag
            aux_class=r(i).economy;
        else
            aux_class=r(i);
        end
        try save(fullfile(aux_location,aux_filename),'aux_class');
        catch err
        end
        %% Finale: Building reports
        aux_report=exist('err','variable')>0;
        if aux_report
            aux_comment=[err.identifier ' | ' err.message];
            clear err
        else
            [~,sizes]=system(['du -sh ' fullfile(aux_location,aux_filename) '.mat']);
            aux_place=isletter(sizes);
            aux_comment=['Saved under : ' fullfile(aux_location,aux_filename) ' | Size : ' sizes(1:aux_place(1)) 'B'];
        end
        rpt(i)=report('save_element:evaluation',report(),~aux_report,aux_comment);
        
    end
else
    error('save_element:InputError','Invalid number of arguments for function '' save_element (evaluation class). (number of arguments is not 4)');
end
end