#!/bin/csh

#BSUB -J clm_trunk
#BSUB -o clm_trunk.%J.log
#BSUB -e clm_trunk.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

csh stage_restarts.csh

echo "Converting CLM files to DART files "

csh convert_clm_to_dart.csh

echo "Running filter"

time mpirun.lsf ./filter >& filter.$$.log

echo "Converting DART files to CLM files "

csh  convert_dart_to_clm.csh

cd ..

#echo "Comparing restarts ::  test_trunk/clm_out.0001.nc test_branch/clm_out.0001.nc"
#
#echo test_trunk/clm_out.0001.nc test_branch/clm_out.0001.nc | ./compare_states >& compare.$$.log

cd -

exit 0
