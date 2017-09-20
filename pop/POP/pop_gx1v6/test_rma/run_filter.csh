#!/bin/csh

#BSUB -J gx1v6_rma
#BSUB -o gx1v6_rma.%J.log
#BSUB -e gx1v6_rma.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

module load job_memusage

mpirun.lsf job_memusage.exe ./filter

exit 0
