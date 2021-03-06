%% Plot_network
%

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: Plot_network.m 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

rad2deg = 45/atan(1);

KIND_U   =   1;
KIND_V   =   2;
KIND_PS  =   3;
KIND_T   =   4;
KIND_VR  = 100;
KIND_REF = 101;
KIND_U10 = 200;
KIND_V10 = 201;
KIND_T2  = 202;
KIND_Q2  = 203;
KIND_TD2 = 204;

map_proj = {'lambert', 'ups', 'mercator'};

fname = 'True_State'
stdlat1 = ncread(fname, 'TRUELAT1');
stdlat2 = ncread(fname, 'TRUELAT2');
cen_lat = ncread(fname, 'CEN_LAT');
cen_lon = ncread(fname, 'CEN_LON');

mp = ncread(fname, 'MAP_PROJ');

num_domains = size(mp,1);

if (num_domains > 1)

   disp(['Number of domains: ',int2str(num_domains)])
   id = input('Input domain id: ');

else

   id = 1;

end

xlon = ncread(fname, ['XLON_d0',int2str(id)]);
xlat = ncread(fname, ['XLAT_d0',int2str(id)]);

minlat = min(xlat(:)); maxlat = max(xlat(:));
minlon = min(xlon(:)); maxlon = max(xlon(:));

axesm(map_proj{mp(id)},'Origin',      [0 cen_lon(id) 0], ...
                       'MapParallels',[stdlat1(id) stdlat2(id)], ...
                       'MapLatLimit', [minlat maxlat], ...
                       'MapLonLimit', [minlon maxlon]); framem;

plotm(coast             ,'color',[0 0 0]);
plotm(usalo('statebvec'),'color',[0 0 0]);
plotm(usalo('conusvec') ,'color',[0 0 0]);

axis( [-0.65 0.65 .1 1.45 ]) % This works pretty well for present CONUS domain

a = ReadASCIIObsSeq('obs_seq.out_OSSE1-7');
%a = ReadASCIIObsSeq('create_obs_sequence.out');

iu=0;
iv=0;
it=0;
iu10=0;
iv10=0;
it2=0;
itd2=0;
ips=0;
ivr=0;
iref=0;

for i = 1:a.num_obs,
%for i = 1:1000,

   lon = rad2deg*a.loc(i,1);
   lat = rad2deg*a.loc(i,2);

   if ( a.kind(i) == KIND_U )

     iu = iu + 1;

   scatterm(lat,lon,'xb')

   elseif ( a.kind(i) == KIND_V )

     iv = iv + 1;

   elseif ( a.kind(i) == KIND_T )

     it = it + 1;

   scatterm(lat,lon,'+r')

   elseif ( a.kind(i) == KIND_U10 )

     iu10 = iu10 + 1;

   scatterm(lat,lon,'xg')

   elseif ( a.kind(i) == KIND_V10 )

     iv10 = iv10 + 1;

   scatterm(lat,lon,'xg')

   elseif ( a.kind(i) == KIND_T2 )

     it2 = it2 + 1;

   scatterm(lat,lon,'xg')

   elseif ( a.kind(i) == KIND_TD2 )

     itd2 = itd2 + 1;

   scatterm(lat,lon,'xg')

   elseif ( a.kind(i) == KIND_PS )

     ips = ips + 1;

   scatterm(lat,lon,'xg')

   elseif ( a.kind(i) == KIND_VR )

     ivr = ivr + 1;

   scatterm(lat,lon,'ob')

   elseif ( a.kind(i) == KIND_REF )

     iref = iref + 1;

   scatterm(lat,lon,'+b')

   else

   disp(['Kind for obs ',int2str(i),' is ',int2str(a.kind(i))])

   end

   hold on

end

fprintf('# of U   %d\n', iu)
fprintf('# of V   %d\n', iv)
fprintf('# of T   %d\n', it)
fprintf('# of Vr  %d\n', ivr)
fprintf('# of Ref %d\n', iref)
fprintf('# of U10 %d\n', iu10)
fprintf('# of V10 %d\n', iv10)
fprintf('# of T2  %d\n', it2)
fprintf('# of TD2 %d\n', itd2)
fprintf('# of PS  %d\n', ips)


% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/Plot_network.m $
% $Revision: 11289 $
% $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
