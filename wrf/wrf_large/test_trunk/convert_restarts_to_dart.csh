#!/bin/csh

if ($#argv == 1) then 
   set ens = "$1"
else
   echo "error your need a directory number"
endif

set work_dir = `pwd`
set dir = "../restarts/advance_temp$ens"

foreach dir (../restarts/advance_temp*)
   
   set fileout = `printf "%s%4.4d" filter_ics. $ens`
   cd $dir 

   cp $dir/wrfinput_d01 wrfinput_d01 
   cp $dir/wrfinput_d02 wrfinput_d02 

   echo "converting wrf restarts in $dir to $fileout"
   ./wrf_to_dart >& out.txt

   # rename the converted file to an the appropriate dart name
   cp dart_wrf_vector $fileout

   @ n = $n + 1

end


