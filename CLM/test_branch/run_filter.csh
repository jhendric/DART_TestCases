#!/bin/csh

#BSUB -J clm_rma
#BSUB -o clm_rma.%J.log
#BSUB -e clm_rma.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

csh stage_restarts.csh

echo "--------------------------------------------------------------------------"
echo "Converting CLM files to DART files "
echo "--------------------------------------------------------------------------"

csh convert_clm_to_dart.csh

echo "--------------------------------------------------------------------------"
echo "Running filter"
echo "--------------------------------------------------------------------------"

time mpirun.lsf ./filter >& filter.$$.log

echo "--------------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

echo "--------------------------------------------------------------------------"
echo "Converting DART files to CLM files "
echo "--------------------------------------------------------------------------"

csh  convert_dart_to_clm.csh

exit 0
