function wysiwyg
%% WYSIWYG -- this function is called with no args and merely
%       changes the size of the figure on the screen to equal
%       the size of the figure that would be printed,
%       according to the papersize attribute.  Use this function
%       to give a more accurate picture of what will be
%       printed.
%       Dan(K) Braithwaite, Dept. of Hydrology U.of.A  11/93

% DART $Id: wysiwyg.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

  unis = get(gcf,'units');
  ppos = get(gcf,'paperposition');
  set(gcf,'units',get(gcf,'paperunits'));
  pos = get(gcf,'position');
  pos(3:4) = ppos(3:4);
  set(gcf,'position',pos);
  set(gcf,'units',unis);

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/wysiwyg.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
