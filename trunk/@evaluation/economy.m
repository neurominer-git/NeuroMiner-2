function r =economy(r)
%ECONOMY transforms a EVALUATION object to save disc space.
%  RES=ECONOMY(R) RES is an array of EVALUATION class objects in
%  memory economy mode (generally with information loss when compared to
%  R).
%  This array is the same size as the input array and the only difference
%  consists in the fact that the models are stored in "economy" mode,
%  saving memory but generally also losing information. The exact
%  configuration of "economy" mode is different for every
%  EVALUATION method in the +evaluation_methods package,
%  for more information read documentation of methods of interest.
%
%   See also EVALUATION, ISEVALUATION.

%   ECONOMY (EVALUATION class)  revision history:
%   Date of creation: 26 November 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    r(i).model=r(i).model.economy;
end
end