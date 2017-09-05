#!/bin/csh

#BSUB -J gx1v6_trunk
#BSUB -o gx1v6_trunk.%J.log
#BSUB -e gx1v6_trunk.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

time mpirun.lsf ./filter

