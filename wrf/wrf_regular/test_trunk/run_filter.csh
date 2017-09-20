#!/bin/csh

#BSUB -J wrf_reg
#BSUB -o wrf_reg.%J.log
#BSUB -e wrf_reg.%J.err
#BSUB -q small 
#BSUB -n 256 
#BSUB -R "span[ptile=8]"
#BSUB -P P86850054 
#BSUB -W 0:30

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

time mpirun.lsf ./filter

exit 0
