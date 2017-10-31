#!/bin/csh

# for running on Cheyenne
set job_name       = "clm_rma "
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
   echo "Build and linking CAM files "
   echo "--------------------------------------------------------------------------"
   
   csh build_and_link.csh || exit 1
   
endif

if ("$stage" == "TRUE") then
   echo "--------------------------------------------------------------------------"
   echo "Staging CAM files "
   echo "--------------------------------------------------------------------------"

   csh stage_restarts.csh || exit 2
   
endif

echo "--------------------------------------------------------------------------"
echo "Running filter"
echo "--------------------------------------------------------------------------"

set host = `hostname`
if     (`echo "$host" | grep ch` != "") then
   echo "running on cheyenne "

   # qsub -W block=true -N cam_run  -A P86850054  -q regular -j oe -m 'abe' -M hendric@ucar.edu -l walltime=00:10:00 -l select=2:ncpus=36:mpiprocs=36 run_cy.csh
   echo "qsub -W block=true "
   echo "     -N $job_name "
   echo "     -A $account_string "
   echo "     -q $destination "
   echo "     -j $join "
   echo "     -m 'abe' "
   echo "     -M $user_list "
   echo "     -l $wall_time"
   echo "     -l $resource_list run_cy.csh"

   cp ../../run_scripts/run_cy.csh .

   qsub -W block=true \
        -N $job_name \
        -A $account_string \
        -q $destination \
        -j $join \
        -m "abe" \
        -M $user_list \
        -l $wall_time
        -l $resource_list run_cy.csh

else if     (`echo "$host" | grep ye` != "") then
   echo "running on yellowstone not working at the moment"
else 
   echo "running interactivly "
   if (-f filter) then
      mpirun -n 4 ./filter |& tee cam_run.$$.log 
   else
      echo "no filter in working directory"
      exit 3
   endif
endif

# move log files to log directory
set run_num = $$

mv dart_log.out dart_log.$run_num.out
mv dart_log.nml dart_log.$run_num.nml

mv cam_run.*.log dart_log.* logs/

echo "---------------------------------------------------------------------------"
echo "Finished running filter"
echo "--------------------------------------------------------------------------"

exit 0
