function data=read_field(ncFileID,times,member,elements,variable)
%% data = read_field(ncFileID, times, member, elements, variable)
%
% Given a NetCDF file handle, the times in question, the ensemble
% member in question, and the elements to read, reads in data from
% a DART NetCDF file

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: read_field.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

data = squeeze(ncFileID{variable}(times,member,elements));

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps/matlab/read_field.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
