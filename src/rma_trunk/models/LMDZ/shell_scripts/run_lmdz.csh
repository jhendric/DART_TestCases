#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_lmdz.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

limit stacksize unlimited
limit stacksize unlimited
limit datasize unlimited

source ../Control_File.csh

ln -sf $LMDZ_DEF_PATH/*.def .
ln -sf $LMDZ_DEF_PATH/$limit_file limit.nc
ln -sf $LMDZ_DEF_PATH/$gcm_exe .

rm used_*

../trans_time
set adv_date = `cat times | tail -1`
echo $adv_date
set hh = `echo $adv_date | cut -c12-13`
echo $hh
set ens_member = `cat element`
echo $ens_member

mv ../stok_paprs.dat_$ens_member  stok_paprs.dat

./$gcm_exe 

mv restart.nc start.nc
mv restartphy.nc startphy.nc

mv histhf.nc ../histhf_$ens_member.nc_$hh
mv histins.nc ../histins_$ens_member.nc_$hh

mv stok_paprs.dat ../stok_paprs.dat_$ens_member



exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/LMDZ/shell_scripts/run_lmdz.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

