#!/bin/csh

set n = 1

foreach file (advance_temp*/wrfinput_d01)

   set fileout = `printf "%s%4.4d" filter_ics. $n`

   cp $file wrfinput_d01 

   echo "converting $file to $fileout"
   ./wrf_to_dart >& out.txt

   # rename the converted file to an the appropriate dart name
   cp dart_wrf_vector $fileout

   @ n = $n + 1

end


