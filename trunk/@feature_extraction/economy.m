function r =economy(r)
%ECONOMY transforms a FEATURE_EXTRACTION object to save disc space.
%  RES=ECONOMY(R) RES is an array of FEATURE_EXTRACTION class objects in
%  memory economy mode (generally with information loss when compared to
%  R).
%  This array is the same size as the input array and the only difference
%  consists in the fact that the models are stored in "economy" mode,
%  saving memory but generally also losing information. The exact
%  configuration of "economy" mode is different for every
%  FEATURE_EXTRACTION method in the +feature_extraction_methods package,
%  for more information read documentation of methods of interest.
%
%   See also FEATURE_EXTRACTION, ISFEATURE_EXTRACTION.

%   ECONOMY (FEATURE_EXTRACTION class)  revision history:
%   Date of creation: 26 November 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    aux_fieldnames=fieldnames(r(i).models);
    for j=1:numel(aux_fieldnames)
        r(i).models.(aux_fieldnames{j})=r(i).models.(aux_fieldnames{j}).economy;
    end
end
end