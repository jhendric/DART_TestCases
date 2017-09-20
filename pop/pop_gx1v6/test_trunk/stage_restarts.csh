#!/bin/csh

set n = 1

foreach file (../restarts/pop.r00*)

   set fileout = `printf "%s%4.4d%s" pop_out. $n .nc`

   echo "linking $file to test_trunk run directory"
   ln -sf $file .

   touch $fileout
   chmod u+w $fileout

   echo "copying $file to $fileout in test_trunk directory"
   cp $file $fileout 

   if ($n == 3) then
      exit(0)
   endif

   @ n = $n + 1

end


