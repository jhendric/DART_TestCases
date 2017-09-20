#!/bin/csh

set n = 1

foreach file (../restarts/advance_tmp*)

   set fileout = `printf "%s%4.4d%s" mpas_out. $n .nc`

   echo "test_rma : linking $file to test_rma run directory"
   ln -sf $file .

   touch $fileout
   chmod u+w $fileout

   echo "test_rma : copying $file to $fileout"
   cp $file/x1.40962.restart.nc $fileout 

   if ($n == 3) then
      exit(0) 
   endif

   @ n = $n + 1

end


