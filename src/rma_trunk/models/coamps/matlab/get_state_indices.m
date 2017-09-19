function indices = get_state_indices(varnum,ijarea)
%% indices = get_state_indices(varnum,ijarea)
%
% Given a size of the field and a variable number, determines the
% indices in the state vector array that correspond to that
% particular variable.

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: get_state_indices.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

indices = ((varnum-1)*ijarea + 1):(varnum*ijarea);

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps/matlab/get_state_indices.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
