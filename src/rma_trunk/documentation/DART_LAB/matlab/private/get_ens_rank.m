function [rank] = get_ens_rank(ens, x)
%% get_ens_rank

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: get_ens_rank.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

s_ens = sort(ens);
rank = find(s_ens < squeeze(x),1,'last') + 1;
if(isempty(rank))
   rank = 1;
end

end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/DART_LAB/matlab/private/get_ens_rank.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
