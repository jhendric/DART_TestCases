function h = plot_polar(y, x, mean_dist, string, model_size)
%% plot_polar

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: plot_polar.m 11680 2017-05-27 22:42:06Z thoar@ucar.edu $

% Y includes a wraparound point, x does not
x_t(model_size + 1) = x(1);
x_t(1:model_size) = x;
h = polar_dares(y, mean_dist + x_t, string);

end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/DART_LAB/matlab/private/plot_polar.m $
% $Revision: 11680 $
% $Date: 2017-05-27 16:42:06 -0600 (Sat, 27 May 2017) $
