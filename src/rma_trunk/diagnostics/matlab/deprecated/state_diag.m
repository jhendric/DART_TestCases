%% state_diag.m uses read_state.m
%

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: state_diag.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

file_name = input('What is file for true state');

true_state = read_state(file_name);

file_name = input('What is file for prior state');

prior_state = read_state(file_name);

file_name = input('What is file for posterior state')

posterior_state = read_state(file_name);


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/deprecated/state_diag.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
