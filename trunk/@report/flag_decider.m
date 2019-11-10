function rpt=flag_decider(rpt)
% FLAG_DECIDER (REPORT class)
%   report_output =FLAG_DECIDER(report_input)
%
%   FLAG_DECIDER (report class) function receives a report class element and
%   decides the flag and descriptor properties of this element based on the
%   subprocesses and the existing flag and descriptor properties.

%   See also report, isreport, io_compare.

%   FLAG_DECIDER (report class) revision history:
%   Date of creation: 12 May 2014 beta (Helena)
%   Creator: Carlos Cabral
if ~isempty(rpt)
    if nargin==1
        subs=rpt.subprocesses_report;
        if ~isempty(subs)
            aux_flag=rpt.flag;
            if isempty(aux_flag)
               aux_flag=true;
            end
            aux_descriptor=rpt.descriptor;
            if isempty(aux_descriptor)
                aux_descriptor=rpt.process;
            end
            for i=1:numel(subs)
                aux_flag=aux_flag&&subs(i).flag;
                if ~subs(i).flag
                    aux_descriptor=[aux_descriptor ' ' subs(i).process ' failed'];
                end
            end
            rpt=report(rpt.process,subs,aux_flag,aux_descriptor);
        end
    else
        error('Function '' flag_merger (report class) called with an invalid number of arguments. (1 argument should be provided)');
    end
else
    warning('\nEmpty report nothing to do\n')
end
end