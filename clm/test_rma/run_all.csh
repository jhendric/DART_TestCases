#!/bin/csh

##=============================================================================
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# $Id: runme_filter 10998 2017-02-03 22:23:13Z thoar@ucar.edu $
#
# start at a generic run script for the mpi version.  this should probably
# end up in the shell scripts directory - but it is here for now.  nsc.
##=============================================================================
#BSUB -J clm_rma_cy
#BSUB -o clm_rma_cy.%J.log
#BSUB -e clm_rma_cy.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10
##=============================================================================
#PBS -N clm_rma_cy
#PBS -A P86850054
#PBS -l walltime=00:10:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=2:ncpus=36:mpiprocs=36
##=============================================================================

module list

echo "--------------------------------------------------------------------------"
echo "Linking CLM files "
echo "--------------------------------------------------------------------------"

csh link_programs.csh          || exit 1

echo "--------------------------------------------------------------------------"
echo "Staging CLM files "
echo "--------------------------------------------------------------------------"

csh stage_restarts.csh         || exit 2
set PID=$!
while(`ps -p $PID`)
   sleep 1
end

echo "--------------------------------------------------------------------------"
echo "Converting CLM files to DART files "
echo "--------------------------------------------------------------------------"

csh convert_clm_to_dart.csh    || exit 3
set PID=$!
while(`ps -p $PID`)
   sleep 1
end

echo "--------------------------------------------------------------------------"
echo "Running filter"
echo "--------------------------------------------------------------------------"

cp ../../run_scripts/run_cy.csh .

if      ($?LS_SUBCWD) then 
   bsub -k < run_cy.csh           || exit 4
else if ($?PBS_NODE_FILE) then 
   qsub -W block=true run_cy.csh  || exit 5
else
   csh run_cy.csh                 && exit 6
endif

echo "--- -----------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

echo "--------------------------------------------------------------------------"
echo "Converting DART files to CLM files "
echo "--------------------------------------------------------------------------"

csh  convert_dart_to_clm.csh   || exit 7

exit 0
