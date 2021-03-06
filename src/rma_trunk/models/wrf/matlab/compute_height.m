function height = compute_height( phi, g )
%% compute_height
%
% Inputs:
%	phi = (full) geopotential, at w pts
%	g   = gravitational acceleration
% Output:
%	height = height, at mass pts
%

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: compute_height.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

height = ( phi(2:end,:,:) + phi(1:end-1,:,:) ) ./ (2*g) ;

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/matlab/compute_height.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
