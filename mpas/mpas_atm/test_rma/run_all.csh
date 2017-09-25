#!/bin/csh

#BSUB -J mpas_atm
#BSUB -o mpas_atm.%J.log
#BSUB -e mpas_atm.%J.err
#BSUB -q regular 
#BSUB -n 256 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:30

echo "--------------------------------------------------------------------------"
echo "Linking CLM files"
echo "--------------------------------------------------------------------------"

csh link_programs.csh  || exit 1

echo "--------------------------------------------------------------------------"
echo "Staging Restarts"
echo "--------------------------------------------------------------------------"

csh stage_restarts.csh ||exit 2

echo "--------------------------------------------------------------------------"
echo "Running filter"
echo "--------------------------------------------------------------------------"

mpirun.lsf -K ./filter

echo "--------------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

mv *.log *.err LOGS/

exit 0