#!/bin/ksh -aeux
#BSUB -P P86850054
#BSUB -n 40
#BSUB -R "span[ptile=8]"
#BSUB -J wrf_chem
#BSUB -o wrf_chem.out
#BSUB -e wrf_chem.err
#BSUB -W 4:00
#BSUB -q regular

mpirun.lsf ./filter > index_filter 2>&1 
export RC=$?     
rm -rf FILTER_SUCCESS     
rm -rf FILTER_FAILED          
if [[ $RC = 0 ]]; then
   touch FILTER_SUCCESS
else
   touch FILTER_FAILED 
   exit
fi
