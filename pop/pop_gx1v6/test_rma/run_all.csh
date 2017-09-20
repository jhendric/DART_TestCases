#!/bin/csh

#BSUB -J pop_gx1v6
#BSUB -o pop_gx1v6.%J.log
#BSUB -e pop_gx1v6.%J.err
#BSUB -q small 
#BSUB -n 64 
#BSUB -R "span[ptile=16]"
#BSUB -P P86850054 
#BSUB -W 0:10

echo "--------------------------------------------------------------------------"
echo "Linking POP files "
echo "--------------------------------------------------------------------------"

csh link_programs.csh

echo "--------------------------------------------------------------------------"
echo "Staging POP files "
echo "--------------------------------------------------------------------------"

csh stage_restarts.csh

echo "--------------------------------------------------------------------------"
echo "Running filter"
echo "--------------------------------------------------------------------------"

mpirun.lsf -K ./filter

echo "--------------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

mv *.log *.err LOGS/

exit 0
