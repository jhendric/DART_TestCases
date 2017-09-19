%% Adds the path necessary for the new NetCDF stuff

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: initialize_matlab.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

%addpath /home/timw/tools/netcdf_toolbox/netcdf/ncfiles -begin
addpath /home/timw/tools/netcdf_toolbox/netcdf/nctype -begin
addpath /home/timw/tools/netcdf_toolbox/netcdf/ncutility -begin
addpath /home/timw/tools/netcdf_toolbox/netcdf -begin
addpath /home/timw/tools/mexnc -begin

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps/matlab/initialize_matlab.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
