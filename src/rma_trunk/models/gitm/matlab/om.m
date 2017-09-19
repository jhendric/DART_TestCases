function oba=om(i,th)

% DART $Id: om.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $
% CREDIT: Alexey Morozov

if i==1
      oba=[1 0 0
           0 cos(th) sin(th)
           0 -sin(th) cos(th)];
elseif i==2
      oba=[cos(th) 0 -sin(th)
           0 1 0
           sin(th) 0 cos(th)];
elseif i==3
    oba=[cos(th) sin(th) 0
        -sin(th) cos(th) 0
        0 0 1];
end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/gitm/matlab/om.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
