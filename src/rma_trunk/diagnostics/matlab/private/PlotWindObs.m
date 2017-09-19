%% PlotWindObs ... a function in progress ... not for general use.

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: PlotWindObs.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

for periods = 2:37;

   fname = sprintf('wind_vectors.%03d.dat',periods);
   ncname = 'obs_diag_output.nc';
   platform = 'SAT';
   level = -1;

   obs = plot_wind_vectors(fname,ncname,platform,level);

   disp('Pausing, hit any key to continue ...')
   pause

end


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/PlotWindObs.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
