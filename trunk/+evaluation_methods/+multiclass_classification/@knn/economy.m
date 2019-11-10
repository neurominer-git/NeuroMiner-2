function r =economy(r)
%ECONOMY transforms a KNN object to save disc space.
%  RES=ECONOMY(R) RES is an array of KNN class objects in
%  memory economy mode. For kNN the econominization in memory comes from
%  the droping of the space field in the model's structure. For more
%  information read the KNN class documentation.
%
%   See also KNN, APPLY, STATUS.

%   ECONOMY (KNN class)  revision history:
%   Date of creation: 27 November 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    r(i).model.space=[];
end
end