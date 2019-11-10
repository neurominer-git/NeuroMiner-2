function r=weight_vector(r)
%WEIGHT_VECTOR (one_class_SVM_LIBSVM class) computes the WEIGHT VECTOR of the
%one_class_SVM_LIBSVM element R.
% RES=WEIGHT_VECTOR (R) returns a vector that corresponds to W the primal
%   solution of the linear SVM defined by one_class_SVM_LIBSVM class object
%   (R). The vector W (1 by the number of features) together with the bias
%   (scalar) define the separating hyperplane.
%   IMPORTANT: The weight vector can only be estimated for 'application_ready'
%   elements and currently the WEIGHT VECTOR estimation is only valid
%   for Linear kernels. WEIGHT_VECTOR will return NaN to all invalid cases.
%
%   In the case that R is an array of one_class_SVM_LIBSVM class objects,
%   WEIGHT_VECTOR returns a cell of the size as R in which each position
%   correspond to the application of WEIGHT_VECTOR to the corresponding
%   element of R.

%   RES=WEIGHT_VECTOR (R)
%   See also one_class_SVM_LIBSVM, APPLY, STATUS

%   WEIGHT_VECTOR (one_class_SVM_LIBSVM class)  revision history:
%   Date of creation: 25 November 2014 beta (Helena)
%   Creator: Carlos Cabral
for i=1:numel(r)
    
    %% Overture: Checking the status and the kernel
    stat=r.status;
    kernel=r.parameters.kernel_type.value{1};
    %% Act: Estimating the W
    if strcmp(stat,'application_ready')
        switch kernel
            case 0
                res=(r.model.sv_coef'*full(r.model.SVs));
            otherwise
                res=NaN;
        end
    else
        res=NaN;
    end
    %% Finale: Incorporating the weight vector in the class element
    r(i).model.weight_vector=res;
end