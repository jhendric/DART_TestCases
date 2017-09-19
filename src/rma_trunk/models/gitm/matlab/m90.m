function [to,yo]=m90(ti,yi,m)

%calculate 90 minute averages
%ti - time in (hours?)
%yi - values in
%m - number of (units of ti) to calculate averages over
%to - time out
%yo - values out

% DART $Id: m90.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $
% CREDIT: Alexey Morozov

to=ti(1):m:ti(end); 
yo=0*to; %preallocate

for i=2:length(to)
    cur=find( to(i-1)<ti & ti<=to(i));
    yo(i)=sum(yi(cur))/length(cur);
end
yo(1)=yo(2);

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/gitm/matlab/m90.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
