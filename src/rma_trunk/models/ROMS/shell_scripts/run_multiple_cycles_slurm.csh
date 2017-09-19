#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_multiple_cycles_slurm.csh 11514 2017-04-25 18:54:09Z thoar@ucar.edu $
#
# Based on scripts to control WRF-DART provided by
# William James Schouler Miller of the University of Maryland.
# Thanks William!
#
#==========================================================================

#user-specified experiment parameters
set domains = d01_only
set cyclestart = 2015092706
set ncycles = 11


set paramfile = init_param.csh
source $paramfile

#parse start date to find starting day & hour
set dd = `echo $cyclestart | awk '{print substr($0,7,2)}'`
set hh = `echo $cyclestart | awk '{print substr($0,9,2)}'`
set dayname = `echo $cyclestart | awk '{print substr($0,1,8)}'`

echo "starting day is $dd"
echo "starting hour is $hh"

#--------------------------------------------------------------------------
# Overall strategy is to fire off a series of dependent jobs.
# Successful completion of the first filter job will free the queued model
# advances. That successful completion of that job array will free the 
# next filter job ... and so on.
#--------------------------------------------------------------------------

set i = 1
while ( $i <= $ncycles )

   echo "commencing cycle $i"

   set yyyymmddhh = ${dayname}${hh}
   echo "date format passed to job scripts is $yyyymmddhh "

   #-----------------------------------------------------------------------
   # run Filter to generate the analysis
   #-----------------------------------------------------------------------

   echo "submitting job for running Filter at analysis time $yyyymmddhh"

   if ( $i == 1) then ##no dependency for Filter run at first analysis time
      set tmp = `sbatch -A aosc-hi ${SCRIPTS_DIR}/run_filter_slurm.csh $yyyymmddhh`
   else
      set tmp = `sbatch -A aosc-hi $depstr ${SCRIPTS_DIR}/run_filter_slurm.csh $yyyymmddhh`
   endif

   set dajob = `echo $tmp | awk '{print($4)}'`

   echo "variable dajob is"
   echo $dajob

   set depstr = "--dependency=afterok:$dajob"

   echo "variable depstr is"
   echo $depstr

   #-----------------------------------------------------------------------
   # run ensemble advances pending successful Filter run
   #-----------------------------------------------------------------------

   if ( $i < $ncycles ) then

      #run 60-member WRF ensemble set

      set tmp = `sbatch -A aosc-hi $depstr ${SCRIPTS_DIR}/run_ensembles.slurm.csh $yyyymmddhh`
      set ensjob = `echo $tmp | awk '{print($4)}'`

      set depstr = "--dependency=afterok:$ensjob"

   endif

   #advance time forward 6 h
   if ( $hh == 00 ) set hhnew = 06
   if ( $hh == 06 ) set hhnew = 12
   if ( $hh == 12 ) set hhnew = 18
   if ( $hh == 18 && $dayname == 20150927 ) then
      set hhnew = 00
      set dayname = 20150928
   else if ( $hh == 18 && $dayname == 20150928 ) then
      set hhnew = 00
      set dayname = 20150929
   else if ( $hh == 18 && $dayname == 20150929 ) then
      set hhnew = 00
      set dayname = 20150930
   endif

   set hh = $hhnew

   @ i++

end


exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/ROMS/shell_scripts/run_multiple_cycles_slurm.csh $
# $Revision: 11514 $
# $Date: 2017-04-25 12:54:09 -0600 (Tue, 25 Apr 2017) $

