function r =economy(r)
%ECONOMY transforms a epsilon_SVR_LIBLINEAR class object to save disc space.
%  RES=ECONOMY(R) RES is an array of epsilon_SVR_LIBLINEAR class objects in
%  memory economy mode. For epsilon_SVR_LIBLINEAR there is no need to economize
%  in space since LIBLINEAR package does not save the the SVs but the
%  directly the weights.
%  For more information read the epsilon_SVR_LIBLINEAR class documentation.
%   See also epsilon_SVR_LIBLINEAR, APPLY, STATUS.

%   ECONOMY (epsilon_SVR_LIBLINEAR class)  revision history:
%   Date of creation: 19 March 2014 beta (Helena)
%   Creator: Carlos Cabral

end