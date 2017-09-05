#!/bin/tcsh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# $Id: cycle.csh.template 11542 2017-04-27 17:16:14Z thoar@ucar.edu $
#
#=============================================================================
# This block of directives constitutes the preamble for the LSF queuing system
#
# the normal way to submit to the queue is:    bsub < roms_ensemble.csh
#
# an explanation of the most common directives follows:
# -J Job_name
# -o STDOUT_filename
# -e STDERR_filename
# -P account_code_number
# -q queue    cheapest == [standby, economy, (regular,debug), premium] == $$$$
# -n number of MPI processes (not nodes)
# -W hh:mm  wallclock time (required on some systems)
#=============================================================================
#BSUB -J roms_ensemble
#BSUB -o roms_ensemble.%J.log
#BSUB -P P86850054
#BSUB -q small
#BSUB -n 16
#BSUB -R "span[ptile=16]"
#BSUB -W 1:00
#BSUB -N -u ${USER}@ucar.edu
#
#=============================================================================
## This block of directives constitutes the preamble for the PBS queuing system
##
## the normal way to submit to the queue is:    qsub run_roms_ensemble.csh
##
## an explanation of the most common directives follows:
## -N     Job name
## -r n   Declare job non-rerunable
## -e <arg>  filename for standard error
## -o <arg>  filename for standard out
## -q <arg>   Queue name (small, medium, long, verylong)
## -l nodes=xx:ppn=2   requests BOTH processors on the node. On both bangkok
##                     and calgary, there is no way to 'share' the processors
##                     on the node with another job, so you might as well use
##                     them both. (ppn == Processors Per Node)
#=============================================================================
#PBS -N roms_ensemble
#PBS -r n
#PBS -e roms_ensemble.err
#PBS -o roms_ensemble.log
#PBS -q dedicated
#PBS -l nodes=10:ppn=2

cd /glade/scratch/thoar/roms_cycling_test

#=========================================================================
# STEP 1: Advance the ocean ensemble ... one after another.
#=========================================================================

@ instance = 0
foreach INSTANCE_DIRECTORY ( instance_???? )

   @ instance++

   cd ${INSTANCE_DIRECTORY}

   rm -f log_$instance.txt

   echo "advancing instance $instance at ..."`date`

   mpirun.lsf ../oceanM ocean.in >& log_$instance.txt

   # Check for successful completion - log file should NOT have something like:
   # Blowing-up: Saving latest model state into  RESTART file
   grep -i blow log_$instance.txt > /dev/null
   if ($status == 0) then
      echo "ROMS instance $instance FAILED."
      echo "ROMS instance $instance FAILED."
      echo "ROMS instance $instance FAILED."
      exit 1
   endif

   # sometimes we need the full name, sometimes we need it without the extension
   set RST_FILE = roms_rst.nc
   set DAI_FILE = roms_dai.nc
   set OBS_FILE = roms_mod_obs.nc
   set RST_ROOT = $RST_FILE:r
   set DAI_ROOT = $DAI_FILE:r
   set OBS_ROOT = $OBS_FILE:r

   # The ROMS restart file will be treated as the DART prior.
   # Create a ROMS POSTERIOR file that will be updated by DART and
   # tag the output with the model time.

   set OCEAN_TIME_STRING = `ncdump -v ocean_time ${DAI_FILE} | grep '^ ocean_time = '`
   set OCEAN_TIME = `echo $OCEAN_TIME_STRING | sed -e "s#[=;a-z_ ]##g"`

   set ROMS_PRIOR     = `printf %s_%04d_%d.nc ${RST_ROOT} $instance $OCEAN_TIME`
   set ROMS_POSTERIOR = `printf roms_posterior_%04d_%d.nc $instance $OCEAN_TIME`
   set ROMS_OBSFILE   = `printf %s_%04d_%d.nc ${OBS_ROOT} $instance $OCEAN_TIME`
   set SAFETY         = `printf roms_dai_original_%04d_%d.nc $instance $OCEAN_TIME`

   # THE SAFETY FILE COPY IS NOT FOR PRODUCTION RUNS AND SHOULD BE REMOVED.

   \cp -v ${DAI_FILE} ${SAFETY}          || exit 1
   \mv -v ${RST_FILE} ${ROMS_PRIOR}      || exit 1
   \mv -v ${DAI_FILE} ${ROMS_POSTERIOR}  || exit 1
   \mv -v ${OBS_FILE} ${ROMS_OBSFILE}    || exit 1

   echo
   echo "#---------------------------------------------------------------------"
   echo "# ROMS instance $instance completed at "`date`
   echo "#---------------------------------------------------------------------"
   echo

   cd ..

end

#=========================================================================
# STEP 2: prepare for DART INFLATION
# This stages the files that contain the inflation values.
# The inflation values change through time and should be archived.
#
# This file is only relevant if 'inflation' is turned on -
# i.e. if inf_flavor(:) /= 0 AND inf_initial_from_restart = .TRUE.
#
# filter_nml
# inf_flavor                  = 2,                 0,
# inf_initial_from_restart    = .true.,            .false.,
# inf_in_file_name            = 'input_priorinf',  'input_postinf',
# inf_out_file_name           = 'output_priorinf', 'output_postinf',
# inf_diag_file_name          = 'preassim',        'postassim',
#
# NOTICE: the archiving scripts require the names of these
# files to be as listed above. When being archived, the filenames get a
# unique extension (describing the assimilation time) appended to them.
#
# The inflation file is essentially a duplicate of the DART model state ...
# For the purpose of this script, they are the output of a previous assimilation,
# so they should be named something like output_priorinf_[mean,sd].SSSSS.nc
#
# NOTICE: inf_initial_from_restart and inf_sd_initial_from_restart are somewhat
# problematic. During the bulk of an experiment, these should be TRUE, since
# we want to read existing inflation files. However, the first assimilation
# might need these to be FALSE and then subsequently be set to TRUE.
# There is now only one way to handle this:
#
# 1) create a cookie file called /glade/scratch/thoar/roms_cycling_test/roms_inflation_cookie
#    The existence of this file will cause this script to set the
#    namelist appropriately. This script will 'eat' the cookie file
#    to prevent this from happening for subsequent executions. If the
#    inflation file does not exist for them, and it needs to, this script
#    should die. The stage_experiment.csh script automatically creates a cookie
#    file to support this option.
#
# The strategy is to use the LATEST (last) inflation file.
#=========================================================================

# The input.nml may be modified differently for each assimilation cycle.
# (for example, inflation files for the first cycle)

\cp input.nml.template input.nml

# These are used to determine IF we are doing inflation.

set  MYSTRING = `grep 'inf_flavor' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  PRIOR_INF = $MYSTRING[2]
set  POSTE_INF = $MYSTRING[3]

# These are used to determine if we HAVE BEEN doing inflation.
# Do we read from a namelist or a file?

set  MYSTRING = `grep 'inf_initial_from_restart' input.nml`
set  MYSTRING = `echo $MYSTRING | sed -e "s#[=,'\.]# #g"`
set  PRIOR_TF = `echo $MYSTRING[2] | tr '[:upper:]' '[:lower:]'`
set  POSTE_TF = `echo $MYSTRING[3] | tr '[:upper:]' '[:lower:]'`

# IFF we want PRIOR inflation:

if ( $PRIOR_INF > 0 ) then

   if ($PRIOR_TF == false) then
      # We are not using an existing inflation file.
      echo "inf_flavor(1) = $PRIOR_INF, using namelist values."

   else if ( -e roms_inflation_cookie ) then
      # We want to use an existing inflation file, but this is
      # the first assimilation so there is no existing inflation
      # file. This is the signal we need to to coerce the namelist
      # to have different values for this execution ONLY.
      # Since the local namelist comes from /glade/scratch/thoar/roms_cycling_test each time, we're golden.

      set PRIOR_TF = FALSE

ex input.nml <<ex_end
g;inf_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
g;inf_sd_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
wq
ex_end

   else

      # Checking for a prior inflation mean file from the previous assimilation.

      (ls -rt1 output_priorinf_mean.* | tail -n 1 >! latestfile) > & /dev/null
      set nfiles = `cat latestfile | wc -l`

      if ( $nfiles > 0 ) then
         set latest = `cat latestfile`
         \ln -vs $latest input_priorinf_mean.nc
      else
         echo "ERROR: Requested PRIOR inflation but specified no incoming inflation MEAN file."
         echo "ERROR: expected something like output_priorinf_mean.SSSSS.nc"
         exit 2
      endif

      # Checking for a prior inflation sd file from the previous assimilation.

      (ls -rt1 output_priorinf_sd.* | tail -n 1 >! latestfile) > & /dev/null
      set nfiles = `cat latestfile | wc -l`

      if ( $nfiles > 0 ) then
         set latest = `cat latestfile`
         \ln -vs $latest input_priorinf_sd.nc
      else
         echo "ERROR: Requested PRIOR inflation but specified no incoming inflation SD file."
         echo "ERROR: expected something like output_priorinf_sd.SSSSS.nc"
         exit 2
      endif

   endif
else
   echo "Prior Inflation           not requested for this assimilation."
endif

# POSTERIOR: We look for the 'newest' and use it - IFF we need it.

if ( $POSTE_INF > 0 ) then

   if ($POSTE_TF == false) then
      # We are not using an existing inflation file.
      echo "inf_flavor(2) = $POSTE_INF, using namelist values."

   else if ( -e roms_inflation_cookie ) then
      # We want to use an existing inflation file, but this is
      # the first assimilation so there is no existing inflation
      # file. This is the signal we need to to coerce the namelist
      # to have different values for this execution ONLY.
      # Since the local namelist comes from /glade/scratch/thoar/roms_cycling_test each time, we're golden.

      set POSTE_TF = FALSE

ex input.nml <<ex_end
g;inf_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
g;inf_sd_initial_from_restart ;s;= .*;= .${PRIOR_TF}., .${POSTE_TF}.,;
wq
ex_end

   else

      # Checking for a posterior inflation mean file from the previous assimilation.

      (ls -rt1 output_postinf_mean.* | tail -n 1 >! latestfile) > & /dev/null
      set nfiles = `cat latestfile | wc -l`

      if ( $nfiles > 0 ) then
         set latest = `cat latestfile`
         \ln -vs $latest input_postinf_mean.nc
      else
         echo "ERROR: Requested POSTERIOR inflation but specified no incoming inflation MEAN file."
         echo "ERROR: expected something like output_postinf_mean.SSSSS.nc"
         exit 2
      endif

      # Checking for a posterior inflation sd file from the previous assimilation.

      (ls -rt1 output_postinf_sd.* | tail -n 1 >! latestfile) > & /dev/null
      set nfiles = `cat latestfile | wc -l`

      if ( $nfiles > 0 ) then
         set latest = `cat latestfile`
         \ln -vs $latest input_postinf_sd.nc
      else
         echo "ERROR: Requested POSTERIOR inflation but specified no incoming inflation SD file."
         echo "ERROR: expected something like output_postinf_sd.SSSSS.nc"
         exit 2
      endif

   endif
else
   echo "Posterior Inflation       not requested for this assimilation."
endif

# Eat the cookie regardless
\rm -f roms_inflation_cookie

#==============================================================================
# STEP 3:  Then we run DART on the ensemble of new states
#==============================================================================

# Remove the last set of DART run-time logs - if they exist.

\rm -f dart_log.out dart_log.nml

# Because convert_roms_obs and filter need bits from the ROMS model_mod,
# a (single) ROMS input file is required to satisfy 'static_init_model()'.
# Any one will do.

ln -sf instance_0001/roms_posterior_????_${OCEAN_TIME}.nc roms_dai.nc

# 1) Collect all the ROMS_OBSFILEs into a list of input files
#    and then convert them to a single DART observation sequence file.

ls -1 instance_*/${OBS_ROOT}*_${OCEAN_TIME}.nc  >! precomputed_files.txt

./convert_roms_obs  || exit 2

# 2) collect all the ROMS_RESTARTs into a list of input files for filter
#    The io module will error out if the file_list.txt is too short.
#    (make sure all instances of ROMS advanced successfully)
#    DART (filter) will modify these files in-place.

ls -1 instance_*/roms_posterior_????_${OCEAN_TIME}.nc  >! restart_files.txt

mpirun.lsf ./filter || exit 3

# Tag the output with the valid time of the model state.

foreach FILE ( input_*mean.nc     input_*sd.nc \
            preassim_*mean.nc  preassim_*sd.nc \
           postassim_*mean.nc postassim_*sd.nc \
            analysis_*mean.nc  analysis_*sd.nc \
              output_*mean.nc    output_*sd.nc \
           preassim_member_????.nc \
           postassim_member_????.nc )

   if (  -e $FILE ) then
      set FEXT  = $FILE:e
      set FBASE = $FILE:r
      \mv -v $FILE ${FBASE}.${OCEAN_TIME}.${FEXT}
   else
      echo "$FILE does not exist, no need to take action."
   endif

end

# Tag the observation file with the valid time of the model state.

\mv -v obs_seq.final             obs_seq.final.${OCEAN_TIME}

#==============================================================================
# STEP 4: Prepare for the next model advance
#==============================================================================
# Rename the existing files to have their future names.
# Sometime soon, the base filenames will not need to be changed.

# 1) filter creates a 'new_dstart.txt' file with the new DSTART
#    that must be inserted into the CENTRALDIR/ocean.in

set DSTART = `grep DSTART new_dstart.txt | sed -e 's/[A-Z, ]//g'`

# 2) the input.nml:&filter_nml:restart_out_file_name specifies the base
#    filename for the updated (the posterior) model state. This base gets
#    appended with a 4-digit instance number and then ".nc"
#    This file must be pushed back into the appropriate directory.

@ instance = 0
foreach INSTANCE_DIRECTORY ( instance_???? )
   @ instance++

   cd ${INSTANCE_DIRECTORY}

   set posterior = `head -n $instance ../restart_files.txt | tail -n 1`
   set ROMS_INI = $posterior:t

   # use new state as starting point for next advance.
   # We want to preserve the unique posterior but want ROMS
   # to read from the (single) filename in ocean.in INIFILE

   # Update the ocean.in file with the new DSTART value

   \cp ../ocean.in.template ocean.in

   /glade/p/work/thoar/roms/trunk/ROMS/Bin/substitute ocean.in MyDSTART   $DSTART
   /glade/p/work/thoar/roms/trunk/ROMS/Bin/substitute ocean.in MyININAME  $ROMS_INI

   cd ..

end

#==============================================================================
# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_output_files/models/ROMS/shell_scripts/cycle.csh.template $
# $Revision: 11542 $
# $Date: 2017-04-27 11:16:14 -0600 (Thu, 27 Apr 2017) $
