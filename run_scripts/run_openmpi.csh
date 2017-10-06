#!/bin/tcsh

#PBS -N openmpi_wrf:32:30:30
#PBS -A P86850054
#PBS -l walltime=00:30:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=32:ncpus=30:mpiprocs=30 

### Set TMPDIR as recommended

mkdir -p       /glade/scratch/hendric/temp
setenv TMPDIR  /glade/scratch/hendric/temp
setenv TEMPDIR /glade/scratch/hendric/temp
setenv TEMP    /glade/scratch/hendric/temp
setenv TMP     /glade/scratch/hendric/temp

source /glade/u/apps/ch/opt/Lmod/7.3.14/lmod/7.3.14/init/tcsh

echo "*******************************"
echo " PBS_JOB_ID  '$PBS_JOBID'"
echo " PBS_JOBNAME '$PBS_JOBNAME'"
echo " NCPUS       '`cat  $PBS_NODEFILE | wc -l`'"
echo " NODES       '`uniq $PBS_NODEFILE | wc -l`'"
echo "*******************************"

limit stacksize unlimited

echo "*************************"
echo " --- mpiexec STARTED ----"
echo "*************************"

module load openmpi
module load peak_memusage

echo `module list`

### mpirun dplace -s 1 ./filter_cy
mpirun peak_memusage.exe ./filter_cy

### mpirun omplace peak_memusage.exe ./filter_cy
### mpirun peak_memusage.exe omplace ./filter_cy
### mpirun omplace ./filter_cy

echo "*************************"
echo " --- mpiexec FINISHED ---"
echo "*************************"

exit 0
