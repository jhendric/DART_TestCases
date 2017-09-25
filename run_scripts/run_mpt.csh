#!/bin/tcsh

#PBS -N mpt_wrf_omplace_vv_np:16:32:32 
#PBS -A P86850054
#PBS -l walltime=00:10:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=16:ncpus=32:mpiprocs=32

### Set TMPDIR as recommended

mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR  /glade/scratch/hendric/temp
setenv TEMPDIR /glade/scratch/hendric/temp
setenv TEMP    /glade/scratch/hendric/temp
setenv TMP     /glade/scratch/hendric/temp

setenv MPI_SHEPHERD true
setenv MPI_DSM_CPULIST 0:31:allhosts
setenv MPI_DSM_VERBOSE 1
setenv OMP_NUM_THREADS 0

 #0-31:32-63:64-95:96-127:128-159:160-191:192-233:234-255:256-287:288-319:320-351:352-383:384-415:416-447:447-479:480-512 


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

# mpiexec_mpt dplace -s 1 ./filter_cy
# mpiexec_mpt omplace -vv -c 0,31,63,95,127,159,191,233,255,287,319,351,383,415,447,479 ./filter_cy
mpiexec_mpt omplace -vv -nt 0 -c 0-31:allhosts ./filter_cy

# mpiexec_mpt omplace peak_memusage.exe ./filter_cy
# mpiexec_mpt peak_memusage.exe omplace ./filter_cy
# mpiexec_mpt omplace ./filter_cy

echo "*****************************"
echo " --- mpiexec_mpt FINISHED ---"
echo "*****************************"

exit 0
