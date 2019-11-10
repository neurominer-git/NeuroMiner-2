function rpt =integrity_checker(data)
% INTEGRITY_CHECKER (DATA_CLASS class) checks data integrity for each
% element in a data_class array.
%
%   RPT_STRUCTURE=INTEGRITY_CHECKER (DATA) function receives an array
%   of data_class class objects (DATA) and checks for the presence of NaNs,
%   Infs of missing values in the data_class structure properties in data
%   and covariates. Returning exclusion vectors that can be used to select
%   the valid to purge the data for invalid values both in instances and
%   features domain.
%
%   DATA data_class array.
%
%   RPT_STRUCTURES is an array of structures, one for each element in DATA.
%   Each structure contains two fields, "instances" and "features". In
%   these fields you can find a logical vector defining the subjects the
%   instances or features that should be purged in order to obtain ready to
%   analyse data.

%   See also data_class, data_selector.

%   INTEGRITY_CHECKER (data_class class)  revision history:
%   Date of creation: 24 April 2014 beta (Helena)
%   Creator: Carlos Cabral
%
%   Date of Modification: 13 of August 2015
%   Modification: Complete redesign, adaptation to the new data_class
%   engineering.
%   Modifier: Carlos Cabral

%% Overture: Looping over the DATA_class elments
if nargin==1
   for i=1:numel(data)
     %% ACT :1 Checking the data property  
     aux=isinf(data(i).data)+isnan(data(i).data);
     aux=aux>0;
     rpt(i).data.features=sum(aux,1)==0;
     rpt(i).data.instances=sum(aux,2)==0;
     %% ACT :2 Checking the covariates
     covar_names=fieldnames(data(i).covariates);
     covar_flag=zeros(1,numel(covar_names));
     aux_covariate_instances=zeros(size(data(i).data,1),1);
     for j=1:numel(covar_names)
         aux_val=data(i).covariates.(covar_names{j});
         if isnumeric(aux_val)
            aux_instance=sum(isnan(aux_val),2);
         elseif iscell(aux_val)
            aux_instance=cellfun(@isempty,aux_val);
         else
            aux_instance=zeros(1,size(aux_val,2))>0;
         end
         covar_flag(j)=sum(aux_instance>0);
         aux_covariate_instances=aux_covariate_instances+aux_instance;
     end
     rpt(i).covariates.covariates=covar_flag==0;
     rpt(i).covariates.instances=aux_covariate_instances==0;
   end
else
   error('integrity_checker:Function_error','Function '' integrity_checker (data_class class) called with an invalid number of arguments. (1 argument should be provided)');
end
end