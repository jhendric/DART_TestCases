function temp = compute_temperature( pres, theta, Cp, Rd, p0 )
%% FUNCTION compute_temperature - Computes temperature from potential temperature.
%
% Inputs:  
%	pres     = pressure, at mass pts
%       theta    = potential temperature, at mass pts 
%	Cp,Rd,p0 = c_p, dry gas constants, reference pressure
% Output:
%	temp     = temperature, at mass pts

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: compute_temperature.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

kappa = Rd / Cp ;

temp = theta .* (pres ./ p0).^kappa ;

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/matlab/compute_temperature.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
