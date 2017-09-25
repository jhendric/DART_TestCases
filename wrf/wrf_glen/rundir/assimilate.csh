#!/bin/csh
#=================================================================
#PBS -N assimilate_2016052312
#PBS -j oe
#PBS -A NMMM0044
#PBS -l walltime=00:30:00
#PBS -q regular
#PBS -m a
#PBS -M romine@ucar.edu
#PBS -l select=15:ncpus=36:mpiprocs=36
#=================================================================

set datea     = 2016052312
set paramfile = /glade2/scratch2/romine/visitors/mikec/scripts/param.csh

source $paramfile

set start_time = `date +%s`
echo "host is " `hostname`

cd $RUN_DIR
echo $start_time >& ${RUN_DIR}/filter_started

#  run data assimilation system
if ( $SUPER_PLATFORM == 'yellowstone' ) then
## Yellowstone
 setenv TARGET_CPU_LIST -1
 setenv FORT_BUFFERED true
 mpirun.lsf ./filter
else if ( $SUPER_PLATFORM == 'cheyenne' ) then
## Cheyenne
 mpiexec_mpt dplace -s 1 ./filter
endif

if ( -e ${RUN_DIR}/obs_seq.final )  touch ${RUN_DIR}/filter_done

set end_time = `date  +%s`
@ length_time = $end_time - $start_time
echo "duration = $length_time"
