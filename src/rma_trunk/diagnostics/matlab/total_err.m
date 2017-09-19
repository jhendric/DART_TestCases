function err = total_err(pred, verif, w)
%% TOTAL_ERR: Computes Total error for time series of set of state variables

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: total_err.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

% Pred and verif are time_series_length x number of variables
num_times = size(pred, 1);
num_vars  = size(pred, 2);

if ( nargin == 2 )
   %--------------------------------------------------
   % unweighted error
   %--------------------------------------------------

   err = sqrt( sum( (pred - verif).^2       , 2) );

elseif ( nargin == 3 )
   %--------------------------------------------------
   % weighted error
   %--------------------------------------------------

   if (length(w) ~= num_vars)
      error('wrong sizes %d and %d',length(w),num_vars)
   end

   err = zeros(num_times,1);

   for i = 1:num_times,
      d  = (pred(i,:) - verif(i,:)).^2;
      err(i) = sqrt(sum(dot(d,w)));
   end

else
   error('Wrong number of arguments.')
end


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/total_err.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
