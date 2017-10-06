#!/bin/tcsh

#PBS -N filter_cy
#PBS -A P86850054
#PBS -l walltime=00:10:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=2:ncpus=32:mpiprocs=32

### Set TMPDIR as recommended

mkdir -p /glade/scratch/hendric/temp

setenv TMPDIR  /glade/scratch/hendric/temp
setenv TEMPDIR /glade/scratch/hendric/temp
setenv TEMP    /glade/scratch/hendric/temp
setenv TMP     /glade/scratch/hendric/temp
setenv MPI_SHEPHERD true

source /glade/u/apps/ch/opt/Lmod/7.3.14/lmod/7.3.14/init/tcsh

echo "*******************************"
echo " PBS_JOB_ID  '$PBS_JOBID'"
echo " PBS_JOBNAME '$PBS_JOBNAME'"
echo " NCPUS       '`cat  $PBS_NODEFILE | wc -l`'"
echo " NODES       '`uniq $PBS_NODEFILE | wc -l`'"
echo "*******************************"

limit stacksize unlimited

echo "*****************************"
echo " --- mpiexec_mpt STARTED ----"
echo "*****************************"


module load mpt
module load peak_memusage

echo `module list`

mpiexec_mpt dplace -s 1 ./filter

echo "*****************************"
echo " --- mpiexec_mpt FINISHED ---"
echo "*****************************"

exit 0
