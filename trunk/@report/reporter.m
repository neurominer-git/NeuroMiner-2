function []=reporter(rpt)
% REPORTER (REPORT class)
%   []=REPORTER(report_input)
%
%   REPORTER (report class) function receives a report class element or
%   array of report class objects and translates the information of each
%   report to an .xml file name after the process description. 

%   See also report, isreport, flag_decider.

%   REPORTER (report class) revision history:
%   Date of creation: 23 of October 2014 beta (Helena)
%   Creator: Carlos Cabral
if numel(rpt)==1
    try
        aux_struct=class2struct(rpt,true);
    catch err
        rethrow(err);
    end
   s.(genvarname(rpt.process))=aux_struct;
   try
       struct2xml(s,genvarname(rpt.descriptor));
   catch err
       rethrow(err);
   end
else
   for i=1:numel(rpt)
       aux_rpt=rpt(i);
       aux_rpt.reporter;
   end
end

end