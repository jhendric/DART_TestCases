#!/bin/csh

#BSUB -J wrf_lg 	
#BSUB -o wrf_lg.%J.log
#BSUB -e wrf_lg.%J.err
#BSUB -q regular 
#BSUB -n 512 
#BSUB -R "span[ptile=14]"
#BSUB -P P86850054
#BSUB -W 0:45


# pin tasks to processors
setenv TARGET_CPU_LIST "-1"

module load job_memusage

mpirun.lsf job_memusage.exe ./filter

exit 0

