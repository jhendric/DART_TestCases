%% gpsloc

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: gpsloc.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

load loc_2007jun08.dat;

%  orient landscape
   orient portrait
   wysiwyg

counter = 0;
for i = 1:size(loc_2007jun08, 1)
  counter = counter + 1;
  xx4(counter) = loc_2007jun08(i, 2);
  yy4(counter) = loc_2007jun08(i, 1);
end

load coast;

axesm('mercator','MapLatLimit',[-20 40], 'MapLonLimit', [85 165]); gridm; plotm(lat,long,'color',[.15 .15 .15]); 
tightmap
mlabel; plabel;

plotm(yy4, xx4, 'r.', 'markersize', 15);

%ylabel('Latitude (N)', 'fontsize', 12)
%xlabel('Longitude (E)', 'fontsize', 12)
xlabel('COSMIC RO locations (8 June 2007, 102 profiles)', 'fontsize', 16)

print -dpdf gpsloc_2007jun08.pdf
print -dpng gpsloc_2007jun08.png

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/obs_converters/gps/matlab/gpsloc.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
