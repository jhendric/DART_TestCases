#!/bin/csh

set n = 1

foreach file (advance_tmp*/*.restart.*)

   set fileout = `printf "%s%4.4d" filter_ics. $n`

   cp $file . 

   echo "converting $file to $fileout"
   ./model_to_dart >& out.txt

   # rename the converted file to an the appropriate dart name
   cp dart.ud $fileout

   if ($n == 3) then
      exit(0) 
   endif

   @ n = $n + 1

end


