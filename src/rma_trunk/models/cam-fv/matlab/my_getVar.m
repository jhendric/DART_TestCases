function data = my_getVar(ncid,varid,FillValue)

% Usage data = my_getVar(ncid,Var_ind,FillValue);

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: my_getVar.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

data = netcdf.getVar(ncid, varid);
if ( ~ isempty(FillValue) )
   data(data == FillValue) = NaN;
end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/cam-fv/matlab/my_getVar.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
