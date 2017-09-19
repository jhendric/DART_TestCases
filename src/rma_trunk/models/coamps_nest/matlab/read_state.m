function data=read_state(ncFileID,times,member,elements)
% Given a NetCDF file handle, the times in question, the ensemble
% member in question, and the elements to read, reads in data from
% a DART NetCDF file

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: read_state.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

  data=read_field(ncFileID,times,member,elements,'state');

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/matlab/read_state.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
