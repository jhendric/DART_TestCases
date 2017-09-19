function [y, ydims] = get_varsNdims(fname)
%% Get the dimension (strings) for each atmospheric variable.
% [y, ydims] = get_vars_dims(fname);
%
% fname     a netcdf file name
%
% y       a cell array of variable names
% ydims   a cell array of the concatenated dimension names 
%
% EXAMPLE:
% 
% fname      = 'obs_seq.final.nc';
% [y, ydims] = get_varsNdims(fname);
%
% >> y{20}  
%
%    AIRCRAFT_U_WIND_COMPONENT_guess
%
% >> ydims{20}
%    region plevel copy time

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: get_varsNdims.m 11303 2017-03-13 21:11:10Z thoar@ucar.edu $

ALLvarnames = get_varnames(fname);
Nvarnames   = length(ALLvarnames);

y     = cell(Nvarnames,1);
ydims = cell(Nvarnames,1);

for i = 1:Nvarnames

   varname = ALLvarnames{i};
   y{i}    = varname;
   
   varinfo = ncinfo(fname,varname);
   ydims{i} = varinfo.Dimensions(1).Name;
   
   rank = length(varinfo.Size);
    
   for idim = 2:rank
      ydims{i} = sprintf('%s %s',ydims{i}, varinfo.Dimensions(idim).Name);
   end

end


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/get_varsNdims.m $
% $Revision: 11303 $
% $Date: 2017-03-13 15:11:10 -0600 (Mon, 13 Mar 2017) $
