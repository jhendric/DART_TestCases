function rho = compute_density( mu, dnw, phi )
%% FUNCTION rho : Computes density of dry air, computed from the
%    hydrostatic relation for dry air: - dphi/deta = -mu alpha.
%
% Inputs:  
%	mu  = (full) dry hydrostatic surf. press (2d)
%	dnw = intervals between w levels, at mass pts
%	phi = (full) geopotential, at w pts
% Output:
%	rho  =  density, at mass pts
%
% See wrf subroutine calc_p_rho_phi.

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: compute_density.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

phi_eta = ( phi(2:end,:,:) - phi(1:end-1,:,:) ) ./ repmat( dnw(:), [1 size(mu)] );

rho = -repmat( reshape( mu, [1 size(mu)] ), [ length(dnw) 1 1 ] ) ./ phi_eta ;

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/matlab/compute_density.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
