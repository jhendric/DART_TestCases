function x_new = advance_oned(x, alpha, model_bias)
%% advance_oned(x, alpha, model_bias)

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: advance_oned.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

x_new = x + comp_dt(x, alpha, model_bias);
end

%---------------------------------------------------

% Internal function comp_dt
function dx = comp_dt(x, alpha, model_bias)

% Compute the time tendency; alpha controls nonlinearity
% model_bias controls a shift in the model dynamics
dx = (x + model_bias) + alpha .* x .* abs(x);

end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/DART_LAB/matlab/private/advance_oned.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
