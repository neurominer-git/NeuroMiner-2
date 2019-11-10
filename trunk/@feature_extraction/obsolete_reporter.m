function report =reporter(input_feat,data)
    % REPORTER (feature_extraction class) applies the intructions defined in an feature_extraction class element to a data_class element. 
%   report =REPORTER(input_feat,data)
%
%   REPORTER (feature_extraction class) function receives a
%   feature_extraction clas element and a data_class class element and
%   adds the feature_extraction log to the existing log of the data_class
%   element.
%

%   See also apply,feature_extraction,chain,data_class.

%   REPORTER (feature_extraction class) revision history:
%   Date of creation: 23 April 2014
%   First used in: NM2.0 beta (Helena)
%   Creator: Carlos Cabral

%% Overture: Initial log from data_class
report=data.log;
%% Act: Add the feature_extraction log to the existing one
models=input_feat.model;
for i=1:numel(model)
    aux_model=models(i);
    report.feature_extraction.(aux_model.method)=aux_model.log;
end
end