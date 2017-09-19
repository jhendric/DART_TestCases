function VTecTS=calc_vtec_grid(AltT, RhoT, wlon, wlat)

% DART $Id: calc_vtec_grid.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $
% CREDIT: Alexey Morozov

nAlts=length(AltT);

IdseTS=squeeze(RhoT(wlon,wlat,:,:));
H=diag(ones(nAlts,1))+diag(ones(nAlts-1,1),1);
H=H(1:nAlts-1,:); %summation operator (needed for the trapezoidal rule - Integral = Sum_{i=1}^{N-1} (h_{i+1}-h_{i})/2*(f_{i+1}+f_{i}), so H*Idse gives you (f_{i+1}+f_{i})
IdseTSs=H*IdseTS; % (f_{i+1}+f_{i})
da=diff(AltT')/2; % (h_{i+1}-h_{i})/2
VTecTS=da*IdseTSs; % Integral = Sum_{i=1}^{N-1} (h_{i+1}-h_{i})/2 * (f_{i+1}+f_{i})
VTecTS=VTecTS*10^-16; %convert it into TECU

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/gitm/matlab/calc_vtec_grid.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
