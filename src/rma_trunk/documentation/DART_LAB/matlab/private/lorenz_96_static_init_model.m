function L96 = lorenz_96_static_init_model()

%% lorenz_96_static_init_model Initializes class data for L96

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: lorenz_96_static_init_model.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

% Lorenz-96 model parameters

L96.time_step_days    = 0;
L96.time_step_seconds = 0;
L96.delta_t           = 0.05;
L96.forcing    = 8;
L96.model_size = 40;
L96.state_loc  = (0:L96.model_size - 1) / L96.model_size;

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/DART_LAB/matlab/private/lorenz_96_static_init_model.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
