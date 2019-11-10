function res =is_package(identifier,package,type)
%IS_PACKAGE  Checks if a function or class is part of a package.
%   RES =IS_PACKAGE(IDENTIFIER,PACKAGE) checks if the method(s) in
%   IDENTIFIER are present in the package defined by PACKAGE
%
%   In the case that IDENTIFIER is string or a cellstr, IS_PACKAGE will
%   check if the class or function defined by the string is part of the
%   package defined by PACKAGE.
%
%   In the case that IDENTIFIER is a cell of objects, IS_PACKAGE will check
%   if the class of each object is part of the package defined by PACKAGE.
%
%   In the case that IDENTIFIER is a structure, IS_PACKAGE will check if
%   the class of each of the IDENTIFIER's fields is part of the package
%   defined by PACKAGE.
%
%   RES is a logical array with the same number of elements as IDENTIFIER,
%   with TRUE (1) represeting the existence of the correpondent
%   method/class in the package DEFINED by PACKAGE and FALSE (0) the non
%   existence.
%
%   RES =IS_PACKAGE(IDENTIFIER,PACKAGE,TYPE) checks if the in the package
%   defined by PACKAGE exists the elements described in IDENTIFIER of the
%   type defined by TYPE, Type is a string and possible values are:
%
%       'm'     M-files
%       'mat'   MAT-files
%       'mex'   MEX-files
%       'mdl'   MDL-files
%       'slx'   SLX-file
%       'p'    P-file
%       'classes'     class folders
%       'packages'    packages folders
%


%   RES =IS_PACKAGE(IDENTIFIER,PACKAGE)

%   IS_PACKAGE revision history:
%   Date of creation: 23 May 2014 beta (Helena)
%   Creator: Carlos Cabral

if nargin>1&&nargin<4
    %% Overture
    if ~ischar(identifier)&&~iscell(identifier)&&~isstruct(identifier)
       identifier=class(identifier);
    end
    if ~ischar(package)
        error('IS_PACKAGE:FunctionError',['Undefined function '' is_package '' for the input argument of type ''' class(package) ''' (Second input argument must be a string).']);
    else
        aux_what=what(package);
        if isempty(aux_what)
            error([ package ' not found']);
        end
    end
    %% Act
    %defining the mode
    if nargin==3
        if ~ischar(type)
            error(['Undefined function '' is_package '' for the input argument of type ''' class(type) ''' (Third input argument must be a string).']);
        else
            type_options={'m','mat','mex','mdl','slx','p','classes','packages'};
            aux_type=find(strcmp(type,type_options));
            if isempty(aux_type)
                error(['Invalid type provided' type]) ;
            end
        end
        aux_type=type_options(aux_type);
        if ~iscell(aux_type)
           aux_type={aux_type};
        end
    else
        aux_type={'m','mat','mex','mdl','slx','p','classes','packages'};
    end
    %converting the structure into a cell
    if isstruct(identifier)
        identifier=struct2cell(identifier);
    elseif ischar(identifier)
        identifier={identifier};
    end
    res=zeros(numel(identifier),1);
    aux_package=what(package);
    %applying the mode
    for i=1:numel(identifier)
        if ~ischar(identifier{i})
            aux=class(identifier{i});
        else
            aux=identifier{i};
        end
        aux_find=strfind(aux,'.');
        if ~isempty(aux_find)
           aux=aux(aux_find(1)+1:end);
        end
        sub_res=zeros(1,numel(aux_type));
        for j=1:numel(aux_type)
            aux_package_sub=aux_package.(aux_type{j});
            sub_res(j)=sum(strcmp(aux,aux_package_sub));
        end
        res(i)=sum(sub_res);
    end
    %% Finale: Transforming the RES in a logical array
    res=res>0;
else
    error('Invalid numer of arguments specified please read the IS_PACKAGE function documentation.')
end
end