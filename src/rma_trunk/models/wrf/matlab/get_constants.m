function [ Cp, Rd, gamma, Rv, L_c, g, T0, p0] = get_constants()
%% get_constants -  Ideally, this would take netcdf filename as input, and
% read required constants from file.  At present, just a
% repository for hardwired constants.

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: get_constants.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

%% Useful constants

Rd    = 287.0;
Cp    = 7.0*Rd/2.0;
gamma = Cp / (Cp - Rd) ;
Rv    = 461; 
g     = 9.81; 
L_c   = 2.25e6; 
T0    = 300; 
p0    = 1000.e2;

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/matlab/get_constants.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
