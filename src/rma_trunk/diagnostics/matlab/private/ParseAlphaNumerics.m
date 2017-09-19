function [vrbl, vrbl_inds] = ParseAlphaNumerics(IDstring)
%% ParseAlphaNumerics -  extricates a variable name from subsequent IDs
% str1 = ' X 1 3 4 89'
% [alpha, numerics] = ParseAlphaNumerics(str1)
% alpha = 'X'
% numerics = [1 3 4 89];

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: ParseAlphaNumerics.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

inds       = find(IDstring == ',');     % find all commas
IDstring(inds) = ' ';
words      = strread(IDstring,'%s');
nwords     = length(words);
vrbl       = words{1};

vrbl_inds = cast(zeros(1,nwords-1),'int32');
for i = 2:nwords
   vrbl_inds(i-1) = sscanf(words{i},'%d');
end


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/ParseAlphaNumerics.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
