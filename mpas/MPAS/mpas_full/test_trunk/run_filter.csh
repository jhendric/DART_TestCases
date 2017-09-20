#!/bin/csh

#BSUB -J mpas_reg
#BSUB -o mpas_reg.%J.log
#BSUB -e mpas_reg.%J.err
#BSUB -q regular 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

time mpirun.lsf ./filter

exit 0
