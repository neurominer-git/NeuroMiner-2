function r =economy(r)
%ECONOMY transforms a C_SVM_LIBLINEAR class object to save disc space.
%  RES=ECONOMY(R) RES is an array of C_SVM_LIBLINEAR class objects in
%  memory economy mode. For C_SVM_LIBLINEAR there is no need to economize
%  in space since LIBLINEAR package does not save the the SVs but the
%  directly the weights.
%  For more information read the C_SVM_LIBLINEAR class documentation.
%   See also C_SVM_LIBLINEAR, APPLY, STATUS.

%   ECONOMY (C_SVM_LIBLINEAR class)  revision history:
%   Date of creation: 19 March 2014 beta (Helena)
%   Creator: Carlos Cabral

end