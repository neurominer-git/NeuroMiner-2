function r =economy(r)
%ECONOMY transforms a C_SVM_LIBSMV class object to save disc space.
%  RES=ECONOMY(R) RES is an array of C_SVM_LIBSMV class objects in
%  memory economy mode. For C_SVM_LIBSMV the econominization in memory
%  comes from elemination of the SVs field. 
%  For more information read the C_SVM_LIBSMV class documentation.
%   See also C_SVM_LIBSMV, APPLY, STATUS.

%   ECONOMY (C_SVM_LIBSMV class)  revision history:
%   Date of creation: 17 March 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    r(i).model.SVs=[];
end
end