#!/bin/csh
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
#BSUB -J pop_gx1v6_ys:64:16
#BSUB -o pop_gx1v6_ys:64:16.%J.log
#BSUB -e pop_gx1v6_ys:64:16.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10
#=============================================================================
#PBS -N pop_gx1v6_cy:2:36:36
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

#----------------------------------------------------------------------
# Turns out the scripts are a lot more flexible if you don't rely on 
# the queuing-system-specific variables -- so I am converting them to
# 'generic' names and using the generics throughout the remainder.
#----------------------------------------------------------------------

if ($?LSF_QUEUE) then

   #-------------------------------------------------------------------
   # This is used by LSF
   #-------------------------------------------------------------------

   module load job_memusage
   
   setenv ORIGINALDIR `pwd`
   setenv JOBNAME     "pop_gx1v6"       ##$LSB_JOBNAME
   setenv JOBID       "??????"          ##$LSB_JOBID
   setenv MYQUEUE     "regular"         ##$LSB_QUEUE
   setenv MYHOST      "??????"          ##$LSB_SUB_HOST
   setenv MPI         mpirun.lsf
   set NCPUS      = "UNKNOWN"
   set NODES      = "UNKNOWN"
   set FILTER     = 'filter -K job_memusage.exe'

else if ($?PBS_QUEUE) then

   #-------------------------------------------------------------------
   # This is used by PBS
   #-------------------------------------------------------------------

   module load mpt
   module load peak_memusage

   setenv ORIGINALDIR $PBS_O_WORKDIR
   setenv JOBNAME     $PBS_JOBNAME
   setenv JOBID       $PBS_JOBID
   setenv MYQUEUE     $PBS_QUEUE
   setenv MYHOST      $PBS_O_HOST
   setenv MPI         mpiexec_mpt dplace peak_memusage.exe # would like to use omplace
   setenv NCPUS       `cat  $PBS_NODEFILE | wc -l`
   setenv NODES       `uniq $PBS_NODEFILE | wc -l`
   setenv MPI_SHEPHERD true
   set    FILTER      'filter dplace peak_memusage.exe' # would like to use omplace
else

   #-------------------------------------------------------------------
   # You can run this interactively to check syntax, file motion, etc.
   #-------------------------------------------------------------------

   setenv ORIGINALDIR `pwd`
   setenv JOBNAME     POP
   setenv JOBID       $$
   setenv MYQUEUE     Interactive
   setenv MYHOST      $HOST
   setenv MPI         csh
   setenv NCPUS       "UNKNOWN"
   setenv NODES       "UNKNOWN"
   setenv FILTER      filter

endif

#----------------------------------------------------------------------
# Just an echo of the job attributes
#----------------------------------------------------------------------

echo
echo "${JOBNAME} ($JOBID) submitted   from $ORIGINALDIR"
echo "${JOBNAME} ($JOBID) submitted   from $MYHOST"
echo "${JOBNAME} ($JOBID) running in queue $MYQUEUE"
echo "${JOBNAME} ($JOBID) running       on $HOST"
echo "${JOBNAME} ($JOBID) started       at `date`"
echo
   
#-----------------------------------------------------------------------------
# A common strategy for the beginning is to check for the existence of
# some variables that get set by the different queuing mechanisms.
# This way, we know which queuing mechanism we are working with,
# and can set 'queue-independent' variables for use for the remainder
# of the script.

if ($?LSB_QUEUE || $?PBS_QUEUE) then

   # Must be using LSF or PBS as the queueing system.
   echo "Using ${MPI} for execution"

   echo "*******************************"
   echo " PBS_JOB_ID  '$JOBID'"
   echo " PBS_JOBNAME '$JOBNAME'"
   echo " NCPUS       '$NCPUS'"
   echo " NODES       '$NODES'"
   echo "*******************************"
   
   echo `module list`
   
   echo "--------------------------------------------------------------------------"
   echo "Running filter"
   echo "--------------------------------------------------------------------------"

   ${MPI} ./${FILTER}

else

    # If you have a linux cluster with no queuing software, use this
    # section. The list of computational nodes is given to the mpirun
    # command and it assigns them as they appear in the file. In some
    # cases it seems to be necessary to wrap the command in a small
    # script that changes to the current directory before running.

    echo "running with no queueing system"
    echo "This is untested for POP -- ending now."
    exit


endif

#-----------------------------------------------------------------------------
# Move the output to storage after filter completes.
# At this point, all the restart,diagnostic files are in the CENTRALDIR
# and need to be moved to the 'experiment permanent' directory.
# We have had problems with some, but not all, files being moved
# correctly, so we are adding bulletproofing to check to ensure the filesystem
# has completed writing the files, etc. Sometimes we get here before
# all the files have finished being written.
#-----------------------------------------------------------------------------

echo "${JOBNAME} ($JOBID) finished at "`date`
echo "Listing contents of CENTRALDIR before archiving"
ls -l

exit 0

