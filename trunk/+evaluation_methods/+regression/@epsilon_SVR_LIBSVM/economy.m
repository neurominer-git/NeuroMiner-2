function r =economy(r)
%ECONOMY transforms a epsilon_SVR_LIBSVM class object to save disc space.
%  RES=ECONOMY(R) RES is an array of epsilon_SVR_LIBSVM class objects in
%  memory economy mode. For epsilon_SVR_LIBSVM the econominization in memory
%  comes from elemination of the SVs field. 
%  For more information read the epsilon_SVR_LIBSVM class documentation.
%   See also epsilon_SVR_LIBSVM, APPLY, STATUS.

%   ECONOMY (epsilon_SVR_LIBSVM class)  revision history:
%   Date of creation: 17 March 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    r(i).model.SVs=[];
end
end