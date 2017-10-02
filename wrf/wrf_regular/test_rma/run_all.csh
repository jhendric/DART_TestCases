#!/bin/csh

set job_name       = "wrf_regular "
set account_string = "P86850054 "
set destination    = "regular"
set join           = "oe" 
set resource_list  = "select=14:ncpus=36:mpiprocs=36"
set user_list      = "hendric@ucar.edu"
set wall_time      = "walltime=00:50:00"

# module list
# 
# echo "--------------------------------------------------------------------------"
# echo "Linking CLM files "
# echo "--------------------------------------------------------------------------"
# 
# csh link_programs.csh          || exit 1
# 
# echo "--------------------------------------------------------------------------"
# echo "Staging CLM files "
# echo "--------------------------------------------------------------------------"
# 
# csh stage_restarts.csh         || exit 2
# set PID=$!
# while(`ps -p $PID`)
#    sleep 1
# end
# 
# echo "--------------------------------------------------------------------------"
# echo "Converting CLM files to DART files "
# echo "--------------------------------------------------------------------------"
# 
# csh convert_clm_to_dart.csh    || exit 3
# set PID=$!
# while(`ps -p $PID`)
#    sleep 1
# end
# 
# echo "--------------------------------------------------------------------------"
# echo "Running filter"
# echo "--------------------------------------------------------------------------"

if     (`hostname | grep ch` != "") then
   echo "qsub -W block=true "
   echo "     -N $job_name "
   echo "     -A $account_string "
   echo "     -q $destination "
   echo "     -j $join "
   echo "     -m 'abe' "
   echo "     -M $user_list "
   echo "     -l $wall_time"
   echo "     -l $resource_list run_cy.csh"

   echo " running on cheyenne "

   qsub -W block=true \
        -N $job_name \
        -A $account_string \
        -q $destination \
        -j $join \
        -m "abe" \
        -M $user_list \
        -l $wall_time \
        -l $resource_list run_cy.csh

else if (`hostname | grep ye`!= "") then
   echo " running on yellowstone "
else 
   echo " running on interactive "
endif

#cp ../../run_scripts/run_cy.csh .

# if      ($?LS_SUBCWD) then 
#    bsub -k < run_cy.csh           || exit 4
# else if ($?PBS_NODE_FILE) then 
#    qsub -W block=true run_cy.csh  || exit 5
# else
#    csh run_cy.csh                 || exit 6
# endif


echo "--- -----------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

exit 0
