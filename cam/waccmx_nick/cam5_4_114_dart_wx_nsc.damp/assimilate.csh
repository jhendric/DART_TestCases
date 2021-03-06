#!/bin/csh
#
# DART software - Copyright 2004 - 2013 UCAR. This open source software is
# provided by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: assimilate1_5.csh 9967 2016-03-16 20:28:24Z raeder $

# This block is an attempt to localize all the machine-specific
# changes to this script such that the same script can be used
# on multiple platforms. This will help us maintain the script.
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_filter.csh 11626 2017-05-11 17:27:50Z nancy@ucar.edu $
#
# Script to assimilate observations using DART and the POP ocean model.
# This presumes two directories exists that contain all the required bits
# for POP and for DART.
#
#=============================================================================
#BSUB -J waccmx_nickp:64:16
#BSUB -o waccmx_nickp:64:16.%J.log
#BSUB -e waccmx_nickp:64:16.%J.err
#BSUB -q small 
#BSUB -n 64    
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10
#=============================================================================
#PBS -N waccmx_nickp:2:36:36
#PBS -A P86850054
#PBS -l walltime=00:10:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=2:ncpus=36:mpiprocs=36
#=============================================================================

### Set TMPDIR as recommended
mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR  /glade/scratch/hendric/temp
setenv TEMPDIR /glade/scratch/hendric/temp
setenv TEMP    /glade/scratch/hendric/temp
setenv TMP     /glade/scratch/hendric/temp

echo "`date` -- BEGIN CAM_ASSIMILATE"

set nonomatch       # suppress "rm" warnings if wildcard does not match anything

# The FORCE options are not optional.
# The VERBOSE options are useful for debugging though
# some systems don't like the -v option to any of the following
#echo "`hostname`"
#switch ("`hostname`")
   # case ys*:
   #    # NCAR "yellowstone"
   #    alias ls ls
   #    set   MOVE = 'mv -fv'
   #    set   COPY = 'cp -fv --preserve=timestamps'
   #    set   LINK = 'ln -fvs'
   #    set   LS   = 'ls'
   #    set REMOVE = 'rm -fr'
   #    set TASKS_PER_NODE = `echo $LSB_SUB_RES_REQ | sed -ne '/ptile/s#.*\[ptile=\([0-9][0-9]*\)]#\1#p'`
   #    setenv MP_DEBUG_NOTIMEOUT yes

   #    set BASEOBSDIR = /glade/p/hao/nickp/dart_obs/saber_data/nsc_waccmx_dart/obs_seq_6hr_allobs/
   #    set  LAUNCHCMD = mpirun.lsf
   # breaksw

   #case default:
      echo "HOSTNAME :: `hostname`"

      alias ls ls
      set   MOVE = 'mv -fv'
      set   COPY = 'cp -fv --preserve=timestamps'
      set   LINK = 'ln -fvs'
      set   LS   = 'ls'
      set REMOVE = 'rm -rf'
      set    LAUNCHCMD = 'mpiexec_mpt dplace '
      # set    TASKS_PER_NODE = `echo run_mpt.csh | sed -ne '/ptile/s#.*\[ptile=\([0-9][0-9]*\)]#\1#p'`
      setenv MP_DEBUG_NOTIMEOUT yes
      set BASEOBSDIR = /glade/p/hao/nickp/dart_obs/saber_data/nsc_waccmx_dart/obs_seq_6hr_allobs/
      set    COMPILER = 'i17'
      set    MPI      = 'mpt'
   #breaksw
    
   # case linux_system_with_utils_in_other_dirs*:
   #    # example of pointing this script at a different set of basic commands
   #    set   MOVE = '/usr/local/bin/mv -fv'
   #    set   COPY = '/usr/local/bin/cp -fv --preserve=timestamps'
   #    set   LINK = '/usr/local/bin/ln -fvs'
   #    set REMOVE = '/usr/local/bin/rm -fr'

   #    set BASEOBSDIR = /glade/p/hao/nickp/dart_obs/saber_data/nsc_waccmx_dart/obs_seq_6hr_allobs/
   #    set LAUNCHCMD  = mpirun.lsf
   # breaksw

   # default:
   #    # NERSC "hopper"
   #    set   MOVE = 'mv -fv'
   #    set   COPY = 'cp -fv --preserve=timestamps'
   #    set   LINK = 'ln -fvs'
   #    set REMOVE = 'rm -fr'

   #    set BASEOBSDIR = BOGUSBASEOBSDIR
   #    set LAUNCHCMD  = "mpirun -n" 

   # breaksw
#endsw

# In CESM1_4 xmlquery must be executed in $CASEROOT.
setenv CASEROOT /glade/scratch/hendric/git_dart/waccmx_nick/cam5_4_114_dart_wx_nsc.damp
setenv CASE     $CASEROOT:t

cd ${CASEROOT}
setenv ensemble_size  `./xmlquery NINST_ATM   -value`
setenv CAM_DYCORE     `./xmlquery CAM_DYCORE  -value`
setenv EXEROOT        `./xmlquery EXEROOT     -value`
setenv RUNDIR         `./xmlquery RUNDIR      -value`
setenv archive        `./xmlquery DOUT_S_ROOT -value`
setenv DATA_ASSIMILATION_CYCLES        `./xmlquery DATA_ASSIMILATION_CYCLES -value`
# setenv doesn't work as a wordlist.

echo "ensemble_size  CAM_DYCORE  EXEROOT  RUNDIR   archive  DATA_ASSIMILATION_CYCLES       "
echo $ensemble_size $CAM_DYCORE $EXEROOT $RUNDIR  $archive $DATA_ASSIMILATION_CYCLES        

cd $RUNDIR

#-------------------------------------------------------------------------
# Preliminary clean up, which can run in the background.
# ATM_forcXX, CESM1_5's new archiver has a mechanism for removing restart file sets,
# which we don't need, but it runs only after the (multicycle) job finishes.  
# We'd like to remove unneeded restarts as the job progresses, allowing more
# cycles to run before needing to stop to archive data.  So clean them out of
# RUNDIR, and st_archive will never have to deal with them.
#-------------------------------------------------------------------------

# Move any hidden restart sets back into the run directory so they can be used or purged.
set echo verbose
ls -d ../Hide*
if ($status == 0) then
   $MOVE ../Hide*/* .
   rmdir ../Hide*
endif

# Cwd is currently RUNDIR.
set log_list = `ls -t cesm.log.*`
echo "log_list is $log_list"

# For safety, leave the most recent *2* restart sets in place.
# Prevents catastrophe if the last restart set is partially written before a crash.
# Add 1 more because the restart set used to start this will be counted:
# there will be 3 restarts when there are only 2 cesm.log files,
# which caused all the files to be deleted.
if ($#log_list >= 3) then

   # List of potential restart sets to remove
   set re_list = `ls -t *cpl.r.*`
   if ($#re_list < 3) then
      echo "Not enough restart sets, even though there are $#log_list cesm.log files"
      exit 14
   endif

   # Member restarts to remove
   set rm_date = `echo $re_list[3] | sed -e "s/-/ /g;s/\./ /g;"`
   @ day = $#rm_date - 2
   @ sec = $#rm_date - 1
   # Fix the misinterpretation of day_o_month = 08 as an octal number
   # by stripping any leading '0's.
   set day_o_month = `echo $rm_date[$day] | bc`
   set sec_o_day   = $rm_date[$sec]

   # Identify log files to be removed or moved.
   # [3] means the 3rd oldest restart set is being (re)moved.
   set rm_log = `echo $log_list[3] | sed -e "s/\./ /g;"`
   set rm_slot = $#rm_log
   if ($rm_log[$#rm_log] == 'gz') @ rm_slot--
   echo '$rm_log['$rm_slot']='$rm_log[$rm_slot]

   if ( $sec_o_day !~ '00000' ) then
   #if ( $sec_o_day !~ '00000' || \
   #    ($sec_o_day =~ '00000' && $day_o_month % BOGUS_save_every_Mth != 0) ) then
      echo "Removing unneeded restart file set from RUNDIR: "
      echo "    $rm_date[1]"'*.{r,rs,rh0,h0,i}*-*'${day_o_month}-${sec_o_day}
      # Remove member restarts (but not DART output)
      # Note that *cpl.ha.* is retained, and any h#, #>0.
      #        $CASE                          DD          -SSSSS
      #$REMOVE  $rm_date[1]*.{r,rs,rh0,h0,i}*${day_o_month}-${sec_o_day}* &
      $REMOVE  $rm_date[1]*.{r,rs,rh0,h0,i}*${day_o_month}-${sec_o_day}* 

      # Remove log files: *YYMMDD-HHMMSS.  
      #$REMOVE  *$rm_log[$rm_slot]*  &
      $REMOVE  *$rm_log[$rm_slot]*  
   else
      # Save the restart set to archive/rest/$datename, where it will be safe
      # from removes of $component/rest and ${case}.locked/archive.
      set save_date = `echo $re_list[3] | sed -e "s/\./ /g;"`
      @ piece = $#save_date - 1
      set save_root = $archive/rest/$save_date[$piece]
      if (! -d $save_root) then
         mkdir -p $save_root
         $MOVE $rm_date[1]*.{r,rs,rh0,h0,i}*${day_o_month}-${sec_o_day}*  $save_root &
         $MOVE                     *inflate*${day_o_month}-${sec_o_day}*  $save_root &

      endif

      # Remove log files: *YYMMDD-HHMMSS*.  
      $REMOVE  *$rm_log[$rm_slot]*  &
   endif

   # I'd like to remove the CAM .r. files, since we always use the .i. files to do a hybrid start,
   # but apparently CESM needs them to be there, even though it doesn't read fields from them.
   # $REMOVE  $rm_date[1].cam*.r.*${day_o_month}-${sec_o_day}.nc &

   # During the last cycle, hide the 2nd newest restart set 
   # so that it's not archived, but is available for debugging.
   # Tally the number of Posterior_Diag files to learn which cycle this is.
   set list = `ls *Post* | wc`
   @ cycle = $list[1] + 1
   # If it's the last cycle, hide the restart set.
   # This is assuming that DATA_ASSIMILATION_CYCLES has not been changed in env_run.xml
   # since the start (not submission) of this job.
   # Alternatively, and more robustly, modify case.run to pass 
   # $cycle and $config{DATA_ASSIMILATION_CYCLES} to DoDataAssimilation.
   if ($cycle == $DATA_ASSIMILATION_CYCLES) then
      set hide_date = `echo $re_list[2] | sed -e "s/-/ /g;s/\./ /g;"`
      @ day = $#hide_date - 2
      @ sec = $#hide_date - 1
      set day_o_month = `echo $hide_date[$day] | bc`
      set sec_o_day   = $hide_date[$sec]
      set hidedir = ../Hide_${day_o_month}-${sec_o_day}
      mkdir $hidedir
      $MOVE  $hide_date[1]*.[rhi]*${day_o_month}-${sec_o_day}*   $hidedir

      # Move log files: *YYMMDD-HHMMSS.  [2] means the 2nd newest restart set is being moved.
      set rm_log = `echo $log_list[2] | sed -e "s/\./ /g;"`
      # -1 skips the gz at the end of the names.
      set rm_slot = $#rm_log
      if ($rm_log[$#rm_log] == 'gz') @ rm_slot--
      echo '$rm_log['$rm_slot']='$rm_log[$rm_slot]
      $MOVE  *$rm_log[$rm_slot]*  $hidedir
   endif

endif
unset echo


#-------------------------------------------------------------------------
# Determine time of model state ... from file name of first member
# of the form "./${CASE}.cam_${ensemble_member}.i.2000-01-06-00000.nc"
#
# Piping stuff through 'bc' strips off any preceeding zeros.
#-------------------------------------------------------------------------

set FILE = `head -n 1 rpointer.atm_0001`
set FILE = $FILE:r
set ATM_DATE_EXT = `echo $FILE:e`
set ATM_DATE     = `echo $FILE:e | sed -e "s#-# #g"`
set ATM_YEAR     = `echo $ATM_DATE[1] | bc`
set ATM_MONTH    = `echo $ATM_DATE[2] | bc`
set ATM_DAY      = `echo $ATM_DATE[3] | bc`
set ATM_SECONDS  = `echo $ATM_DATE[4] | bc`
set ATM_HOUR     = `echo $ATM_DATE[4] / 3600 | bc`

echo "valid time of model is $ATM_YEAR $ATM_MONTH $ATM_DAY $ATM_SECONDS (seconds)"
echo "valid time of model is $ATM_YEAR $ATM_MONTH $ATM_DAY $ATM_HOUR (hours)"

#-------------------------------------------------------------------------
# Create temporary working directory for the assimilation and go there
#-------------------------------------------------------------------------

set temp_dir = assimilate_cam
echo "temp_dir is $temp_dir"

if ( -d $temp_dir ) then
   ${REMOVE} $temp_dir/*
else
   mkdir -p $temp_dir
endif
cd $temp_dir

#-----------------------------------------------------------------------------
# Get observation sequence file ... or die right away.
# The observation file names have a time that matches the stopping time of CAM.
#-----------------------------------------------------------------------------
# Make sure the file name structure matches the obs you will be using.
# PERFECT model obs output appends .perfect to the filenames

set YYYYMM   = `printf %04d%02d                ${ATM_YEAR} ${ATM_MONTH}`
if (! -d ${BASEOBSDIR}/${YYYYMM}_6H) then
#if (! -d ${BASEOBSDIR}/${YYYYMM}_6H_CESM) then
   echo "CESM+DART requires 6 hourly obs_seq files in directories of the form YYYYMM_6H_CESM"
   echo "The directory ${BASEOBSDIR}/${YYYYMM}_6H_CESM is not found.  Exiting"
   exit -10
endif

#set OBSFNAME = `printf obs_seq.%04d-%02d-%02d-%05d ${ATM_YEAR} ${ATM_MONTH} ${ATM_DAY} ${ATM_SECONDS}`
#set OBSFNAME = `printf obs_seq_loweratm_%04d%02d%02d%02d ${ATM_YEAR} ${ATM_MONTH} ${ATM_DAY} ${ATM_HOUR}` # NMP LOWER ATM ONLY
set OBSFNAME = `printf obs_seq_allobs_%04d%02d%02d%02d.biasfix ${ATM_YEAR} ${ATM_MONTH} ${ATM_DAY} ${ATM_HOUR}`  #     LA+S+A

set OBS_FILE = ${BASEOBSDIR}/${YYYYMM}_6H/${OBSFNAME}
#set OBS_FILE = ${BASEOBSDIR}/${YYYYMM}_6H_CESM/${OBSFNAME}
echo "OBS_FILE = $OBS_FILE"

if (  -e   ${OBS_FILE} ) then
   ${LINK} ${OBS_FILE} obs_seq.out
else
   echo "ERROR ... no observation file $OBS_FILE"
   echo "ERROR ... no observation file $OBS_FILE"
   exit -1
endif

#=========================================================================
# Block 1: Populate a run-time directory with the input needed to run DART.
#=========================================================================

echo "`date` -- BEGIN COPY BLOCK"

if (  -e   ${CASEROOT}/input.nml ) then
   # ${COPY} ${CASEROOT}/input.nml .
   sed -e "/#/d;/^\!/d;/^[ ]*\!/d" ${CASEROOT}/input.nml >! input.nml  || exit 39
else
   echo "ERROR ... DART required file ${CASEROOT}/input.nml not found ... ERROR"
   echo "ERROR ... DART required file ${CASEROOT}/input.nml not found ... ERROR"
   exit -2
endif

echo "`date` -- END COPY BLOCK"

# If possible, use the round-robin approach to deal out the tasks.
# Since the ensemble manager is not used by cam_to_dart or dart_to_cam,
# it is OK to set it here and have it used by all routines.

# if ($?TASKS_PER_NODE) then
#    if ($#TASKS_PER_NODE > 0) then
#       ${COPY} input.nml input.nml.$$
#       sed -e "s#layout.*#layout = 2#" \
#           -e "s#tasks_per_node.*#tasks_per_node = $TASKS_PER_NODE#" \
#           input.nml.$$ >! input.nml || exit 40
#       ${REMOVE} input.nml.$$
#    endif
# endif

#=========================================================================
# Block 2: Stage the files needed for SAMPLING ERROR CORRECTION
#
# The sampling error correction is a lookup table.
# The tables were originally in the DART distribution, but should
# have been staged to $CASEROOT at setup time.
# Each ensemble size has its own (static) file.
# It is only needed if
# input.nml:&assim_tools_nml:sampling_error_correction = .true.,
#=========================================================================

set  MYSTRING = `grep 'sampling_error_correction' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  MYSTRING = `echo $MYSTRING | sed -e 's#"# #g'`
set SECSTRING = `echo $MYSTRING[2] | tr '[:upper:]' '[:lower:]'`

if ( $SECSTRING == true ) then
   set SAMP_ERR_FILE = ${CASEROOT}/final_full.${ensemble_size}
   if (  -e   ${SAMP_ERR_FILE} ) then
      ${COPY} ${SAMP_ERR_FILE} .
   else
      echo "ERROR: no sampling error correction file for this ensemble size."
      echo "ERROR: looking for ${SAMP_ERR_FILE}"
      exit -3
   endif
else
   echo "Sampling Error Correction not requested for this assimilation."
endif

#=========================================================================
# Block 3: DART INFLATION
# This stages the files that contain the inflation values.
# The inflation values change through time and should be archived.
#
# This file is only relevant if 'inflation' is turned on -
# i.e. if inf_flavor(:) /= 0 AND inf_initial_from_restart = .TRUE.
#
# filter_nml
# inf_flavor                  = 2,                       0,
# inf_initial_from_restart    = .true.,                  .false.,
# inf_in_file_name            = 'prior_inflate_ics',     'post_inflate_ics',
# inf_out_file_name           = 'prior_inflate_restart', 'post_inflate_restart',
# inf_diag_file_name          = 'prior_inflate_diag',    'post_inflate_diag',
#
# NOTICE: the archiving scripts more or less require the names of these
# files to be as listed above. When being archived, the filenames get a
# unique extension (describing the assimilation time) appended to them.
#
# The inflation file is essentially a duplicate of the DART model state ...
# For the purpose of this script, they are the output of a previous assimilation,
# so they should be named something like prior_inflate_restart.YYYY-MM-DD-SSSSS
#
# NOTICE: inf_initial_from_restart and inf_sd_initial_from_restart are somewhat
# problematic. During the bulk of an experiment, these should be TRUE, since
# we want to read existing inflation files. However, the first assimilation
# might need these to be FALSE and then subsequently be set to TRUE.
# There are two ways to handle this:
#
# 1) Create the initial files offline (perhaps with 'fill_inflation_restart')
#    and stage them with the appropriate names in the RUNDIR.
#    You must manually remove the cam_inflation_cookie file
#    from the RUNDIR in this case.
#    - OR -
# 2) create a cookie file called RUNDIR/cam_inflation_cookie
#    The existence of this file will cause this script to set the
#    namelist appropriately. This script will 'eat' the cookie file
#    to prevent this from happening for subsequent executions. If the
#    inflation file does not exist for them, and it needs to, this script
#    should die. The CESM_DART_config script automatically creates a cookie
#    file to support this option.
#
# The strategy is to use the LATEST inflation file from the CESM 'rundir'.
# After an assimilation, the new inflation values/files will be moved to
# the CESM rundir to be used for subsequent assimilations. If the short-term
# archiver has worked correctly, only the LATEST files will available. Of
# course, it is not required to have short-term archiving turned on, so ...
#=========================================================================

set  MYSTRING = `grep 'inf_flavor' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  PRIOR_INF = $MYSTRING[2]
set  POSTE_INF = $MYSTRING[3]

set  MYSTRING = `grep 'inf_initial_from_restart' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  PRIOR_TF = `echo $MYSTRING[2] | tr '[:upper:]' '[:lower:]'`
set  POSTE_TF = `echo $MYSTRING[3] | tr '[:upper:]' '[:lower:]'`

# its a little tricky to remove both styles of quotes from the string.

set  MYSTRING = `grep 'inf_in_file_name' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  MYSTRING = `echo $MYSTRING | sed -e 's#"# #g'`
set  PRIOR_INF_IFNAME = $MYSTRING[2]
set  POSTE_INF_IFNAME = $MYSTRING[3]

set  MYSTRING = `grep 'inf_out_file_name' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  MYSTRING = `echo $MYSTRING | sed -e 's#"# #g'`
set  PRIOR_INF_OFNAME = $MYSTRING[2]
set  POSTE_INF_OFNAME = $MYSTRING[3]

set  MYSTRING = `grep 'inf_diag_file_name' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  MYSTRING = `echo $MYSTRING | sed -e 's#"# #g'`
set  PRIOR_INF_DIAG = $MYSTRING[2]
set  POSTE_INF_DIAG = $MYSTRING[3]

# IFF we want PRIOR inflation:

if ( $PRIOR_INF > 0 ) then

   if ($PRIOR_TF == false) then
      # we are not using an existing inflation file.
      echo "inf_flavor(1) = $PRIOR_INF, using namelist values."

   else if ( -e ../cam_inflation_cookie ) then
      # We want to use an existing inflation file, but this is
      # the first assimilation so there is no existing inflation
      # file. This is the signal we need to to coerce the namelist
      # to have different values for this execution ONLY.
      # Since the local namelist comes from CASEROOT each time, we're golden.

      set PRIOR_TF = FALSE

ex input.nml <<ex_end
g;inf_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
g;inf_sd_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
wq
ex_end

   else
      # Look for the output from the previous assimilation
      (ls -rt1 ../cam_${PRIOR_INF_OFNAME}.* | tail -n 1 >! latestfile) > & /dev/null
      set nfiles = `cat latestfile | wc -l`

      # If one exists, use it as input for this assimilation
      if ( $nfiles > 0 ) then
         set latest = `cat latestfile`
         ${LINK} $latest ${PRIOR_INF_IFNAME}
      else
         echo "ERROR: Requested PRIOR inflation but specified no incoming inflation file."
         echo "ERROR: expected something like ../cam_${PRIOR_INF_OFNAME}.YYYY-MM-DD-SSSSS"
         exit -4
      endif

   endif
else
   echo "Prior Inflation           not requested for this assimilation."
endif

# POSTERIOR: We look for the 'newest' and use it - IFF we need it.

if ( $POSTE_INF > 0 ) then

   if ($POSTE_TF == false) then
      # we are not using an existing inflation file.
      echo "inf_flavor(2) = $POSTE_INF, using namelist values."

   else if ( -e ../cam_inflation_cookie ) then
      # We want to use an existing inflation file, but this is
      # the first assimilation so there is no existing inflation
      # file. This is the signal we need to to coerce the namelist
      # to have different values for this execution ONLY.
      # Since the local namelist comes from CASEROOT each time, we're golden.

      set POSTE_TF = FALSE

ex input.nml <<ex_end
g;inf_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
g;inf_sd_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
wq
ex_end

   else
      # Look for the output from the previous assimilation
      (ls -rt1 ../cam_${POSTE_INF_OFNAME}.* | tail -n 1 >! latestfile) > & /dev/null
      set nfiles = `cat latestfile | wc -l`

      # If one exists, use it as input for this assimilation
      if ( $nfiles > 0 ) then
         set latest = `cat latestfile`
         ${LINK} $latest ${POSTE_INF_IFNAME}
      else
         echo "ERROR: Requested POSTERIOR inflation but specified no incoming inflation file."
         echo "ERROR: expected something like ../cam_${POSTE_INF_OFNAME}.YYYY-MM-DD-SSSSS"
         exit -5
      endif
   endif
else
   echo "Posterior Inflation       not requested for this assimilation."
endif

# Eat the cookie regardless
${REMOVE} ../cam_inflation_cookie

#=========================================================================
# Block 4: Convert N CAM initial files to DART initial condition files.
# cam_to_dart is serial code, we can do all of these at the same time
# as long as we can have unique namelists for each of them.
#
# At the end of the block, we have DART initial condition files  filter_ics.[1-N]
# that came from pointer files ../rpointer.atm_[1-N]
#
# REQUIRED DART namelist settings:
# &filter_nml:           restart_in_file_name    = 'filter_ics'
#                        restart_out_file_name   = 'filter_restart'
# &ensemble_manager_nml: single_restart_file_in  = '.false.'
# &cam_to_dart_nml:      cam_to_dart_output_file = 'dart_ics',
# &dart_to_cam_nml:      dart_to_cam_input_file  = 'dart_restart',
#                        advance_time_present    = .false.
#
# NOTE: when starting an OSSE by perturbing a single file, use
# &filter_nml
#   start_from_restart        = .false.,
#   output_restart            = .true.,
#   restart_in_file_name      = "filter_ics.0001",
#   restart_out_file_name     = "filter_restart", 
# &ensemble_manager_nml
#   single_restart_file_in    = .true.,
#   single_restart_file_out   = .false.,
# &model_nml
#   pert_names          = 'T'
#   pert_sd             = 1.0e-11,
#   pert_base_vals      = -888888.0d0,
#=========================================================================

echo "`date` -- BEGIN CAM-TO-DART"

# CAM-SE: DART needs a SEMapping_cs_grid.nc file for cubed-sphere grid mapping.
# Use an existing file (given in the namelist), or DART will create one the
# first time it runs.  To create one it needs an existing SEMapping.nc file,
# which should be output from CAM-SE every forecast. CESM 1_1_1 called this
# HommeMapping.nc but we require that the DART namelist use 'SEMapping.nc'
# so we can rename it here.

if ( $CAM_DYCORE == 'se' || $CAM_DYCORE == 'homme') then
   # set the default filenames, and then check the input namelist to
   # see if the user has specified a different cs grid filename.
   set CS_GRID_FILENAME = 'SEMapping_cs_grid.nc'

   if ( $CAM_DYCORE == 'homme') then
      set MAPPING_FILENAME = 'HommeMapping.nc'
   else
      set MAPPING_FILENAME = 'SEMapping.nc'
   endif

   set MYSTRING = `grep 'cs_grid_file' input.nml`
   if ($#MYSTRING == 3) then
      set MYSTRING = `echo $MYSTRING | sed -e "s#'# #g"`
      set CS_GRID_FILENAME = $MYSTRING[3]
   endif

   # Grid file needs to be in run directory, or cam_to_dart will create one
   # based on information from the MAPPING file (which was created by CAM).
   if ( -f ../$CS_GRID_FILENAME ) then
      ${LINK} ../$CS_GRID_FILENAME .
   else
      ${LINK} ../$MAPPING_FILENAME SEMapping.nc
   endif
endif

set member = 1
while ( ${member} <= ${ensemble_size} )

   # Each member will do its job in its own directory.
   # That way, we can do N of them simultaneously -

   set MYTEMPDIR = member_${member}
   mkdir -p $MYTEMPDIR
   cd $MYTEMPDIR

   # make sure there are no old output logs hanging around
   $REMOVE output.${member}.cam_to_dart

   set ATM_INITIAL_FILENAME = `printf ${CASE}.cam_%04d.i.${ATM_DATE_EXT}.nc  ${member}`
   set ATM_HISTORY_FILENAME = `printf ${CASE}.cam_%04d.h0.${ATM_DATE_EXT}.nc ${member}`
   set     DART_IC_FILENAME = `printf filter_ics.%04d     ${member}`
   set    DART_RESTART_FILE = `printf filter_restart.%04d ${member}`

   sed -e "s#dart_ics#../${DART_IC_FILENAME}#" \
       -e "s#dart_restart#../${DART_RESTART_FILE}#" \
       < ../input.nml >! input.nml  || exit 41

   ${LINK} ../../$ATM_INITIAL_FILENAME caminput.nc
   ${LINK} ../../$ATM_HISTORY_FILENAME cam_phis.nc

   if ( $CAM_DYCORE == 'se') then
      # Grid file needs to be in current directory, or cam_to_dart will create one
      # based on information from the MAPPING file (which was created by CAM).
      if ( -f ../../$CS_GRID_FILENAME) then
         ${LINK} ../../$CS_GRID_FILENAME .
      else
         ${LINK} ../../$MAPPING_FILENAME .
      endif
   endif

   echo "starting cam_to_dart for member ${member} at "`date`
   #${EXEROOT}/cam_to_dart >! output.${member}.cam_to_dart &
   ${EXEROOT}/cam_to_dart >! output.${member}.cam_to_dart # NMP - don't run in background

   cd ..

   @ member++
end

wait
sleep 10

set nsuccess = `fgrep 'Finished ... at YYYY' member*/output.[0-9]*.cam_to_dart | wc -l`
if (${nsuccess} != ${ensemble_size}) then
   echo "ERROR ... DART died in 'cam_to_dart' ... ERROR"
   echo "ERROR ... DART died in 'cam_to_dart' ... ERROR"
   exit -6
endif

if ( $CAM_DYCORE == 'se') then
   # CAM-SE: if a new grid file was created, copy it to both the run dir and
   # the case dir for future use.
   if (! -f ../$CS_GRID_FILENAME)         ${COPY} member_1/$CS_GRID_FILENAME   ..
   if (! -f $CS_GRID_FILENAME)            ${LINK} ../$CS_GRID_FILENAME         .
   if (! -f $CASEROOT/$CS_GRID_FILENAME)  ${COPY} ../$CS_GRID_FILENAME         $CASEROOT
endif

echo "`date` -- END CAM-TO-DART for all ${ensemble_size} members."

#=========================================================================
# Block 5: Actually run the assimilation.
# Will result in a set of files : 'filter_restart.xxxx'
#
# DART namelist settings required:
# &filter_nml:           async                   = 0,
# &filter_nml:           adv_ens_command         = "no_advance_script",
# &filter_nml:           restart_in_file_name    = 'filter_ics'
# &filter_nml:           restart_out_file_name   = 'filter_restart'
# &filter_nml:           obs_sequence_in_name    = 'obs_seq.out'
# &filter_nml:           obs_sequence_out_name   = 'obs_seq.final'
# &filter_nml:           init_time_days          = -1,
# &filter_nml:           init_time_seconds       = -1,
# &filter_nml:           first_obs_days          = -1,
# &filter_nml:           first_obs_seconds       = -1,
# &filter_nml:           last_obs_days           = -1,
# &filter_nml:           last_obs_seconds        = -1,
# &ensemble_manager_nml: single_restart_file_in  = .false.
# &ensemble_manager_nml: single_restart_file_out = .false.
#
#=========================================================================

# CAM:static_init_model() always needs a caminput.nc and a cam_phis.nc
# for geometry information, etc.

set ATM_INITIAL_FILENAME = ${CASE}.cam_0001.i.${ATM_DATE_EXT}.nc
set ATM_HISTORY_FILENAME = ${CASE}.cam_0001.h0.${ATM_DATE_EXT}.nc

${LINK} ../$ATM_INITIAL_FILENAME caminput.nc
${LINK} ../$ATM_HISTORY_FILENAME cam_phis.nc

echo "`date` -- BEGIN FILTER"


${LAUNCHCMD} ${EXEROOT}/filter || exit -7
echo "`date` -- END FILTER"

${MOVE} Prior_Diag.nc      ../cam_Prior_Diag.${ATM_DATE_EXT}.nc
${MOVE} Posterior_Diag.nc  ../cam_Posterior_Diag.${ATM_DATE_EXT}.nc
${MOVE} obs_seq.final      ../cam_obs_seq.${ATM_DATE_EXT}.final
${MOVE} dart_log.out       ../cam_dart_log.${ATM_DATE_EXT}.out

# Copy obs_seq.final files to a place that won't be archived,
# so that they don't need to be retrieved from the HPSS.
if (! -d ../../Obs_seqs) mkdir ../../Obs_seqs
cp ../cam_obs_seq.${ATM_DATE_EXT}.final ../../Obs_seqs &


# Accommodate any possible inflation files
# 1) rename file to reflect current date
# 2) move to RUNDIR so the DART INFLATION BLOCK works next time and
#    that they can get archived.

foreach FILE ( ${PRIOR_INF_OFNAME} ${POSTE_INF_OFNAME} ${PRIOR_INF_DIAG} ${POSTE_INF_DIAG} )
   if ( -e ${FILE} ) then
      ${MOVE} ${FILE} ../cam_${FILE}.${ATM_DATE_EXT}
   else
      echo "No ${FILE} for ${ATM_DATE_EXT}"
   endif
end

# Handle localization_diagnostics_files
set MYSTRING = `grep 'localization_diagnostics_file' input.nml`
set MYSTRING = `echo $MYSTRING | sed -e "s#[=,']# #g"`
set MYSTRING = `echo $MYSTRING | sed -e 's#"# #g'`
set loc_diag = $MYSTRING[2]
if (-f $loc_diag) then
   $MOVE $loc_diag ../cam_${loc_diag}.${ATM_DATE_EXT}
endif

# Handle regression diagnostics
set MYSTRING = `grep 'reg_diagnostics_file' input.nml`
set MYSTRING = `echo $MYSTRING | sed -e "s#[=,']# #g"`
set MYSTRING = `echo $MYSTRING | sed -e 's#"# #g'`
set reg_diag = $MYSTRING[2]
if (-f $reg_diag) then
   $MOVE $reg_diag ../cam_${reg_diag}.${ATM_DATE_EXT}
endif

# 
#=========================================================================
# Block 6: Update the cam restart files ... simultaneously ...
#
# Each member will do its job in its own directory, which already exists
# and has the required input files remaining from 'Block 4'
#=========================================================================

echo "`date` -- BEGIN DART-TO-CAM"
set member = 1
while ( $member <= $ensemble_size )

   cd member_${member}

   ${REMOVE} output.${member}.dart_to_cam

   echo "starting dart_to_cam for member ${member} at "`date`
   #${EXEROOT}/dart_to_cam >! output.${member}.dart_to_cam &
   ${EXEROOT}/dart_to_cam >! output.${member}.dart_to_cam # NMP - don't run in background

   cd ..

   @ member++
end

wait
sleep 10

set nsuccess = `fgrep 'Finished ... at YYYY' member*/output.[0-9]*.dart_to_cam | wc -l`
if (${nsuccess} != ${ensemble_size}) then
   echo "ERROR ... DART died in 'dart_to_cam' ... ERROR"
   echo "ERROR ... DART died in 'dart_to_cam' ... ERROR"
   exit -8
endif

echo "`date` -- END DART-TO-CAM for all ${ensemble_size} members."

#=========================================================================
# Block 7: The cam files have now been updated, move them into position.
#
# As implemented, the input filenames are static in the CESM namelists.
# Since the short-term archiver creates unique directories for these,
# we must link the uniquely-named files to static names. When the short-term
# archiver 'restores' the CESM files, the links will still be valid.
#
#=========================================================================

cd ${RUNDIR}

set member = 1
while ( ${member} <= ${ensemble_size} )

   set inst_string = `printf _%04d $member`

   set ATM_INITIAL_FILENAME = ${CASE}.cam${inst_string}.i.${ATM_DATE_EXT}.nc

   ${LINK} ${ATM_INITIAL_FILENAME} cam_initial${inst_string}.nc || exit -9

   @ member++

end

#-------------------------------------------------------------------------
# Cleanup
#-------------------------------------------------------------------------

echo "`date` -- END CAM_ASSIMILATE"


#-------------------------------------------------------------------------
# NMP - perform some clean up on the output/history fields
# This is mostly done due to the large file sizes of the atm/init/ and atm/rest/
# files. 
#-------------------------------------------------------------------------
rm ${archive}/atm/rest/*.nc
rm ${archive}/atm/init/*.nc
rm ${archive}/lnd/rest/*.nc

# Be sure that the removal of unneeded restart sets and copy of obs_seq.final are finished.
wait
sleep 10

exit 0

# <next few lines under version control, do not edit>
# $URL: https://proxy.subversion.ucar.edu/DAReS/DART/trunk/models/cam/shell_scripts/assimilate1_5.csh $
# $Revision: 9967 $
# $Date: 2016-03-16 14:28:24 -0600 (Wed, 16 Mar 2016) $

