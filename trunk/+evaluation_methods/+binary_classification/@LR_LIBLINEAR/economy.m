function r =economy(r)
%ECONOMY transforms a LR_LIBLINEAR class object to save disc space.
%  RES=ECONOMY(R) RES is an array of LR_LIBLINEAR class objects in
%  memory economy mode. For LR_LIBLINEAR there is no need to economize
%  in space since LIBLINEAR package does not save the the SVs but the
%  directly the weights. 
%  For more information read the LR_LIBLINEAR class documentation.
%   See also LR_LIBLINEAR, APPLY, STATUS.

%   ECONOMY (LR_LIBLINEAR class)  revision history:
%   Date of creation: 17 March 2014 beta (Helena)
%   Creator: Carlos Cabral

end