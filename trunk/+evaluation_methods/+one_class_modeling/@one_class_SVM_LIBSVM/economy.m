function r =economy(r)
%ECONOMY transforms a one_class_SVM_LIBSVM class object to save disc space.
%  RES=ECONOMY(R) RES is an array of one_class_SVM_LIBSVM class objects in
%  memory economy mode. For one_class_SVM_LIBSVM the econominization in memory
%  comes from elemination of the SVs field. 
%  For more information read the one_class_SVM_LIBSVM class documentation.
%   See also one_class_SVM_LIBSVM, APPLY, STATUS.

%   ECONOMY (one_class_SVM_LIBSVM class)  revision history:
%   Date of creation: 17 March 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    r(i).model.SVs=[];
end
end