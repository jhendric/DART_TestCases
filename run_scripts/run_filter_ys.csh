#!/bin/tcsh

#BSUB -J ys_wrf 
#BSUB -o ys_wrf.%J.log
#BSUB -e ys_wrf.%J.err
#BSUB -q regular 
#BSUB -n 256 
#BSUB -R "span[ptile=14]"
#BSUB -P P86850054 
#BSUB -W 1:00

# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

module load job_memusage

mpirun.lsf job_memusage.exe ./filter_ys

exit 0

