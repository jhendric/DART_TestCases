function ostruct = CombineStructs(struct1,struct2);
%% CombineStructs   all components of both stuctures are combined into one structure.
%
% EXAMPLE:
%
%

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: CombineStructs.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

if ~( isstruct(struct1) & isstruct(struct2) )
   error('both arguments must be structures')
end

% We'll just copy one input structure to the output
% and append all unique fields from #2 into the output.
% If the field exists in both, and is different, we're in trouble.

ostruct = struct1;
fields  = fieldnames(struct2);

for i=1:length(fields)

   ostruct = setfield(ostruct, fields{i}, getfield(struct2,fields{i}));

end


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/CombineStructs.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
