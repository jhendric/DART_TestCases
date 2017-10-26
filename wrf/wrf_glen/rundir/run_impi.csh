#!/bin/tcsh

#PBS -N impi_wrf:32:16:16
#PBS -A P86850054
#PBS -l walltime=00:30:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=32:ncpus=16:mpiprocs=16

### Set TMPDIR as recommended

mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR  /glade/scratch/hendric/temp
setenv TEMPDIR /glade/scratch/hendric/temp
setenv TEMP    /glade/scratch/hendric/temp
setenv TMP     /glade/scratch/hendric/temp

source /glade/u/apps/ch/opt/Lmod/7.3.14/lmod/7.3.14/init/tcsh

echo "*******************************"
echo " PBS_JOB_ID  '$PBS_JOBID'"
echo " PBS_JOBNAME '$PBS_JOBNAME'"
echo " NCPUS       '$NCPUS'"
echo " NODES       '`uniq $PBS_NODEFILE | wc -l`'"
echo "*******************************"

limit stacksize unlimited

echo "************************"
echo " --- mpirun STARTED ----"
echo "************************"

setenv TARGET_CPU_LIST "-1"

module load impi
module load peak_memusage

echo `module list`

setenv MPI_USE_ARRAY false

# mpiexec ./filter_cy
mpirun peak_memusage.exe ./filter_cy

# mpiexec omplace peak_memusage.exe ./filter_cy
# mpiexec peak_memusage.exe omplace ./filter_cy
# mpiexec omplace ./filter_cy

echo "************************"
echo " --- mpirun FINISHED ---"
echo "************************"

exit 0
