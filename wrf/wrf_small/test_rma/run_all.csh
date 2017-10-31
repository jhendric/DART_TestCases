#!/bin/csh

set job_name       = "wrf_small "
set account_string = "P86850054 "
set destination    = "regular"
set join           = "oe" 
set resource_list  = "select=2:ncpus=36:mpiprocs=36"
set user_list      = "hendric@ucar.edu"
set wall_time      = "walltime=00:10:00"

# I am sure there is a more elegant way to do this
set build = TRUE
set stage = TRUE

if ( $#argv > 0 ) then
   if (("$1" == "-nobuild") || ("$2" == "-nobuild")) then
      set build = FALSE
   endif 

   if (("$1" == "-nostage") || ("$2" == "-nostage")) then
      set stage = FALSE
   endif 
endif

echo "--------------------------------------------------------------------------"
echo "Run All Scripts"
echo "--------------------------------------------------------------------------"

if ("$build" == "TRUE") then
   echo "--------------------------------------------------------------------------"
   echo "Build and linking WRF files "
   echo "--------------------------------------------------------------------------"

   csh build_and_link.csh          || exit 1
endif

if ("$stage" == "TRUE") then
   echo "--------------------------------------------------------------------------"
   echo "Staging WFR files "
   echo "--------------------------------------------------------------------------"
   
   csh stage_restarts.csh         || exit 2
endif

echo "--------------------------------------------------------------------------"
echo "Running pmo"
echo "--------------------------------------------------------------------------"

# if     (`hostname | grep ch` != "") then
#    echo " running on cheyenne "
# 
#    qsub -W block=true \
#         -N $job_name \
#         -A $account_string \
#         -q $destination \
#         -j $join \
#         -m "abe" \
#         -M $user_list \
#         -l $wall_time
#         -l $resource_list run_cy.csh
# 
# else if (`hostname | grep ye`!= "") then
#    echo "running on yellowstone "
# else
   echo "running interactively "
   mpirun -n 1 ./perfect_model_obs
# endif

echo "--------------------------------------------------------------------------"
echo "Running filter"
echo "--------------------------------------------------------------------------"

# if     (`hostname | grep ch` != "") then
#    echo " running on cheyenne "
# 
#    qsub -W block=true \
#         -N $job_name \
#         -A $account_string \
#         -q $destination \
#         -j $join \
#         -m "abe" \
#         -M $user_list \
#         -l $wall_time
#         -l $resource_list run_cy.csh
# 
# else if (`hostname | grep ye`!= "") then
#    echo "running on yellowstone "
# else
   echo "running interactively "
   mpirun -n 4 ./filter
# endif

echo "---------------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

exit 0
