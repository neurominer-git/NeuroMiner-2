classdef report
    %Summary of REPORT:
    %   The REPORT class standartizes how the information relative to a 
    %   process (consistency and faillures) this information will then be 
    %   an important part in the construction of the log files. The REPORT 
    %   class element can be used to store information regarding the 
    %   consistency of a process (before the process takes places) or to 
    %   report faillure and sucess of the processes (at the end of the 
    %   processes).
    %
    %   REPORT properties:
    %   process - ...
    %   subprocesses_report - ...
    %   flag - ...
    %   descriptor - ...
    %
    %   REPORT history:
    %   Date of creation: 24 April 2014
    %   First used in: NM2.0 beta (Helena)
    %   Creator: Carlos Cabral
    properties
        process;  %FORMAT: String; DESCRIPTION: Designation of the process for which the REPORT will be produced.
        subprocesses_report;  %FORMAT: array of REPORT class elements; DESCRIPTION: Array of REPORT class elements that were produced by the subprocesses that compose the process.
        flag; %FORMAT: logical: DESCRIPTION: 0 for problems (consistency faults or processes not corretly finished) and 1 for green light (consistency and all processes finished)
        descriptor; %FORMAT: String; DESCRIPTION: Short description of the occurences in the process to be included in the log file.
    end
    
    methods
        function obj = report(process,subprocesses_report,flag,descriptor)
            if nargin>0
                obj=report();
                obj.flag=true;
                if (nargin==1)
                    if ischar(process)
                       obj.process=process;
                    else
                        error('report:ClassError','Process propriety is invalid, please read REPORT class documentation')
                    end
                elseif (nargin==2)
                    if ischar(process)
                        obj.process=process;
                    else
                        error('report:ClassError','Process propriety is invalid, please read REPORT class documentation')
                    end
                    if ischar(subprocesses_report)||isempty(subprocesses_report)
                        obj.subprocesses_report=subprocesses_report;
                    else
                        error('report:ClassError','Subprocesses_report propriety is invalid, please read REPORT class documentation')
                    end
                elseif (nargin==3)
                    if ischar(process)
                        obj.process=process;
                    else
                       error('report:ClassError','Process propriety is invalid, please read REPORT class documentation')
                    end
                    if isreport(subprocesses_report)||isempty(subprocesses_report)
                        obj.subprocesses_report=subprocesses_report;
                    else
                        error('report:ClassError','Subprocesses_report propriety is invalid, please read REPORT class documentation')
                    end
                    if islogical(flag)
                        obj.flag=flag;
                    else
                        error('report:ClassError','Flag propriety is invalid, please read REPORT class documentation')
                    end
                elseif nargin==4
                    if ischar(process)
                        obj.process=process;
                    else
                        error('report:ClassError','Process propriety is invalid, please read REPORT class documentation')
                    end
                    if isreport(subprocesses_report)||isempty(subprocesses_report)
                        obj.subprocesses_report=subprocesses_report;
                    else
                        error('report:ClassError','Subprocesses_report propriety is invalid, please read REPORT class documentation')
                    end
                    if islogical(flag)
                        obj.flag=flag;
                    else
                        error('report:ClassError','Flag propriety is invalid, please read REPORT class documentation')
                    end
                    if ischar(descriptor)
                        obj.descriptor=descriptor;
                    else
                        error('report:ClassError','Descriptor propriety is invalid, please read REPORT class documentation')
                    end
                end
            else
                obj.process=[];
                obj.subprocesses_report=[];
                obj.flag=false;
                obj.descriptor=[];
            end          
        end
    end
end