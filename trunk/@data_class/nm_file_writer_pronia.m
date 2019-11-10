function nm_file_writer_pronia(data,filename)
% NM_FILE_WRITER_PRONIA (DATA_CLASS class) writes a .txt file that is
% usable for the NM interface.
%
%   NM_FILE_WRITER_PRONIA (DATA_INPUT) writes a
%   text file "DATA_INPUT.type_YYYY_MM_DD_HH_MM_SS.txt" in the current
%   directory that contains a list of files that can be used to interact
%   with the NM GUI for analysis of imaging data. This list will have as
%   many elements as instances in the data class.
%
%   DATA_INPUT is a data_class object. For the method to work properly the
%   property "descriptor" in the DATA_INPUT should contain the full path
%   for the folder where the files reside. For each element in the
%   property dbcode should exist only one file in the supracited folder
%   that contains the dbcode in the name.
%
%   NM_FILE_WRITER_PRONIA (DATA_INPUT,FILENAME) writes a
%   text file "FILENAME" in the corrent directory that contains a list of
%   files that can be used to interact with the NM GUI for analysis of
%   imaging data. This list will have as many elements as instances in the
%   data class.
%
%   FILENAME is an string defining the the name of the file to be produced
%   by the method.
%
%   See also data_compare, data_class, report, data_fuser, parameters

%   NM_FILE_WRITER_PRONIA (data_class class) revision history:
%   Date of creation: 28 October 2015 beta (Helena)
%   Creator: Carlos Cabral
if nargin==1||nargin==2
    %% Overture: Input checking.
    %data
    if numel(data)~=1
        error('nm_file_writer_pronia:Function_error','The dimension of the DATA argument provided to function " nm_file_writer_pronia (data_class class) " is not valid (number of elements should be 1))')
    elseif isempty(data)
        error('nm_file_writer_pronia:Function_error','Empty DATA argument provided to function " nm_file_writer_pronia (data_class class) " ')
    elseif ~exist(fileparts(data.descriptor),'dir')
        error('nm_file_writer_pronia:Function_error','The Descriptor property of the DATA argument provided to function " nm_file_writer_pronia (data_class class) does not correspond to the expected format folder+prefix " ')
    end
    % filename
    if nargin==1
        td=clock;
        td=[num2str(td(1)) ':' num2str(td(2)) ':' num2str(td(3)) ' ' num2str(td(4)) ':' num2str(td(5)) ':' num2str(round(td(6)))];
        filename=[data.type '_' td '.txt'];
    else
        if ~ischar(filename)
            error('nm_file_writer_pronia:Function_error','The class of the FILENAME argument provided to function " nm_file_writer_pronia (data_class class) " is not valid, a CHAR is expected)')
        end
    end
    %% Act 1: open the file
    try fid=fopen(filename,'a+');
    catch err
        rethrow(err)
    end
    dbcode=data.dbcode;
    for i=1:numel(dbcode)
        aux_file=dir([data.descriptor '/*' dbcode{i} '*']);
        if numel(aux_file)==1
           fprintf(fid,[fullfile(data.descriptor,aux_file.name) '\n']);
        elseif numel(aux_file)>1
            fclose(fid);
            delete(filename)
            error('nm_file_writer_pronia:Function_error',['More than one file found for instance ' data.dbcode{i} ' " ' data.descriptor '", only one file is expected.'])
        else
            fclose(fid);
            delete(filename);
            error('nm_file_writer_pronia:Function_error',['No file found for instance ' data.dbcode{i} ' " ' data.descriptor '", one file is expected.'])
        end
    end
    %% Finale: Writting the file
    fclose(fid);
else
    error('nm_file_writer_pronia:Function_error','Function '' nm_file_writer_pronia (data_class class) called with an invalid number of arguments. (1 or 2 arguments should be provided)');
end
end