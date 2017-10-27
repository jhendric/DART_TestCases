#!/bin/csh

set RMA_DIR = '/Users/hendric/DART/rma_trunk'
set CAM_DIR = '/Users/hendric/DART/DART_TestCases/cam/cam_fv'

cd $RMA_DIR/assimilation_code/programs/compare_states/work/
csh quickbuild.csh
cp compare_states $CAM_DIR/ 

cd $CAM_DIR

echo "**************************************************************************"
echo "COMPARING clm_restart"
echo "**************************************************************************"
echo " " 
echo $CAM_DIR/test_rma/cam_out.0001.nc $CAM_DIR/test_rma_branch/cam_out.0001.nc          | ./compare_states
 
