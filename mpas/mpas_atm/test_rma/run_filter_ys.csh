#!/bin/csh

#BSUB -J mpas_atm
#BSUB -o mpas_atm.%J.log
#BSUB -e mpas_atm.%J.err
#BSUB -q regular 
#BSUB -n 512 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 1:00

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

time mpirun.lsf ./filter

mkdir -p LOGS
mv *.log *.err LOGS

exit 0
