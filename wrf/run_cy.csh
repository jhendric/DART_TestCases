#!/bin/tcsh

###=============================================================================
## DART software - Copyright UCAR. This open source software is provided
## by UCAR, "as is", without charge, subject to all terms of use at
## http://www.image.ucar.edu/DAReS/DART/DART_download
##
## $Id: runme_filter 10998 2017-02-03 22:23:13Z thoar@ucar.edu $
##
## start at a generic run script for the mpi version.  this should probably
## end up in the shell scripts directory - but it is here for now.  nsc.
###=============================================================================
#BSUB -J clm_rma_cy
#BSUB -o clm_rma_cy.%J.log
#BSUB -e clm_rma_cy.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10
###=============================================================================
##PBS -N clm_rma_cy
##PBS -A P86850054
##PBS -l walltime=00:10:00
##PBS -q regular
##PBS -j oe
##PBS -m abe
##PBS -M hendric@ucar.edu
##PBS -l select=2:ncpus=36:mpiprocs=36
###=============================================================================

### Set TMPDIR as recommended

mkdir -p /glade/scratch/$USER/temp

setenv TMPDIR  /glade/scratch/$USER/temp
setenv TEMPDIR /glade/scratch/$USER/temp
setenv TEMP    /glade/scratch/$USER/temp
setenv TMP     /glade/scratch/$USER/temp

source /glade/u/apps/ch/opt/Lmod/7.3.14/lmod/7.3.14/init/tcsh

limit stacksize unlimited

# A common strategy for the beginning is to check for the existence of
# some variables that get set by the different queuing mechanisms.
# This way, we know which queuing mechanism we are working with,
# and can set 'queue-independent' variables for use for the remainder
# of the script.

if      ($?LS_SUBCWD) then

   # LSF has a list of processors already in a variable (LSB_HOSTS)
   #  alias submit 'bsub < \!*'
   echo "*******************************"
   echo " running with LSF"
   echo "*******************************"
   # echo " PBS_JOB_ID  '$PBS_JOBID'"
   # echo " PBS_JOBNAME '$PBS_JOBNAME'"
   # echo " NCPUS       '`cat  $PBS_NODEFILE | wc -l`'"
   # echo " NODES       '`uniq $PBS_NODEFILE | wc -l`'"
   # echo "*******************************"
   
   module load job_memusage
   set MEMEXE = 'job_memusage.exe'   

else if ($?PBS_JOBNAME) then

   # PBS has a list of processors in a file whose name is (PBS_NODEFILE)
   #  alias submit 'qsub \!*'
   echo "*******************************"
   echo " running with PBS"
   echo "*******************************"
   echo " PBS_JOB_ID  '$PBS_JOBID'"
   echo " PBS_JOBNAME '$PBS_JOBNAME'"
   echo " NCPUS       '`cat  $PBS_NODEFILE | wc -l`'"
   echo " NODES       '`uniq $PBS_NODEFILE | wc -l`'"
   echo "*******************************"

   module load peak_memusage
   
   set MEMEXE = 'peak_memusage.exe'   
      
else

   # interactive - assume you are using 'lam-mpi' and that you have
   # already run 'lamboot' once to start the lam server, or that you
   # are running with a machine that has mpich installed.

   echo " running interactively"
   # mpirun -n 4 ./filter
   set MEMEXE = ' '   

endif
  

echo "*************************"
echo " --- filter Started -----"
echo "*************************"
   
if ($?NCAR_LDFLAGS_MPT) then
   echo " running with mpt"

   setenv MPI_SHEPHERD true

   set LAUNCHCMD = "mpiexec_mpt dplace -s 1 "

else if ($?NCAR_LDFLAGS_INTEL)
   echo " running with impi"

   setenv TARGET_CPU_LIST "-1"
   setenv MPI_USE_ARRAY false
   
   set LAUNCHCMD = 'mpirun '
   
else
   echo " running with openmpi"
   
   set LAUNCHCMD 'mpirun '

endif

echo `module list`

${LAUNCHCMD} ${MEMEXE} ./filter

echo "*************************"
echo " --- filter Finished ----"
echo "*************************"
   


exit 0
