#!/bin/csh

set n = 1

foreach file (pop.r00*)

   set fileout = `printf "%s%4.4d" filter_ics. $n`

   cp $file pop.r.nc 

   echo "converting $file to $fileout"
   ./pop_to_dart >& out.txt

   # rename the converted file to an the appropriate dart name
   cp dart_ics $fileout
   
   # if ($n == 3) then
   #    exit(0)
   # endif

   @ n = $n + 1

end


