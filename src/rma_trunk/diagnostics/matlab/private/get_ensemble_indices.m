function [ens_size, ens_indices] = get_ensemble_indices(fname)
%% DART:GET_ENSEMBLE_INDICES  returns the number of ensemble members in the file and their 'copy' indices. 
%
% Example:
% fname = 'filter_output.nc';
% [ens_size, ens_indices] = get_ensemble_indices(fname);
%
% Example to return just the size ...
% [ens_size, ~] = get_ensemble_indices(fname);

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: get_ensemble_indices.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

if ( exist(fname,'file') ~= 2 ), error('%s does not exist.',fname); end

[ens_size, ~] = nc_dim_info(fname,'member');

ens_indices = 1:ens_size;

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/get_ensemble_indices.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
