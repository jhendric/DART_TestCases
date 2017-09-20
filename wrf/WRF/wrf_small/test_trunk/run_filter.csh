#!/bin/csh

#BSUB -J wrf_sm
#BSUB -o wrf_sm.%J.log
#BSUB -e wrf_sm.%J.err
#BSUB -q small 
#BSUB -n 16
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054
#BSUB -W 0:10

time mpirun.lsf ./filter
