#!/bin/csh

set n = 1

foreach file (../restarts/advance_tmp[1..2..3])

   set fileout = `printf "%s%4.4d%s" wrf_out. $n .nc`

   echo "linking $file to test_trunk run directory"
   ln -sf $file .

   touch $fileout
   chmod u+w $fileout

   echo "copying $file to $fileout in test_trunk directory"
   cp $file/wrfinput_d01 $fileout 

   if ($n == 3) then
      exit(0)
   endif

   @ n = $n + 1

end


