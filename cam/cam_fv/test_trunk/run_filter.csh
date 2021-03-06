#!/bin/csh

#BSUB -J cam_fv
#BSUB -o cam_fv.%J.log
#BSUB -e cam_fv.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

time mpirun.lsf ./filter

exit 0
