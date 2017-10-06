#!/bin/csh
set CLM_DIR = '/glade/scratch/hendric/test_dart/clm'

echo "**************************************************************************"
echo "COMPARING PREASSIM"
echo "**************************************************************************"
echo " " 
echo $CLM_DIR/test_branch/preassim_member_0001_d01.nc $CLM_DIR/test_trunk/clm_restart.0001.nc  | ./compare_states

echo "**************************************************************************"
echo "COMPARING POSTASSIM"
echo "**************************************************************************"
echo " " 
echo $CLM_DIR/test_branch/postassim_member_0001_d01.nc $CLM_DIR/test_trunk/clm_restart.0001.nc | ./compare_states

echo "**************************************************************************"
echo "COMPARING FORECAST"
echo "**************************************************************************"
echo " " 
echo $CLM_DIR/test_branch/forecast_member_0001_d01.nc $CLM_DIR/test_trunk/clm_restart.0001.nc  | ./compare_states

echo "**************************************************************************"
echo "COMPARING ANALYSIS"
echo "**************************************************************************"
echo " " 
echo $CLM_DIR/test_branch/analysis_member_0001_d01.nc $CLM_DIR/test_trunk/clm_restart.0001.nc  | ./compare_states

echo "**************************************************************************"
echo "COMPARING clm_restart"
echo "**************************************************************************"
echo " " 
echo $CLM_DIR/test_branch/clm_restart.0001.nc $CLM_DIR/test_trunk/clm_restart.0001.nc          | ./compare_states
 
