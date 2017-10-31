#!/bin/csh

set n = 1

foreach wrf_restart_dir (../restarts/advance_temp*)

   set dart_wrf_d01 = `printf "%s%4.4d%s" wrf_out_d01. $n .nc`
   set dart_wrf_d02 = `printf "%s%4.4d%s" wrf_out_d02. $n .nc`

   echo "linking $wrf_restart_dir to test_rma run directory"
   ln -sf $wrf_restart_dir .
   
   touch $dart_wrf_d01
   touch $dart_wrf_d02
   
   echo "copying $wrf_restart_dir to $dart_wrf_d01 and $dart_wrf_d02 in test_rma run directory"
   cp $wrf_restart_dir/wrfinput_d01 $dart_wrf_d01 
   cp $wrf_restart_dir/wrfinput_d02 $dart_wrf_d02 

   chmod u+w $dart_wrf_d01
   chmod u+w $dart_wrf_d02

   @ n = $n + 1

end

echo "copying 'wrfinput_d01' and 'wrfinput_d02 to test_rma run directory"
cp ../restarts/advance_temp1/wrfinput_d01  .
cp ../restarts/advance_temp1/wrfinput_d02  .

echo "outputing restart file lists for filter"
ls -1 ../restarts/advance_temp*/wrfinput_d01 > restart_files_in_d01.txt
ls -1 ../restarts/advance_temp*/wrfinput_d02 > restart_files_in_d02.txt

ls -1 wrf_out_d01.*.nc > restart_files_out_d01.txt
ls -1 wrf_out_d02.*.nc > restart_files_out_d02.txt
