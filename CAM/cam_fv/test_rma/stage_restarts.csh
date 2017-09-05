#!/bin/csh

set n = 1

foreach file (../restarts/fv_testcase.i.000[1..2..3].nc)

   set fileout = `printf "%s%4.4d%s" cam_out. $n .nc`

   echo "linking $file to test_rma run directory"
   ln -sf $file .
   
   touch $fileout
   
   echo "copying $file to $fileout in test_rma run directory"
   cp $file $fileout 
   chmod u+w $fileout

   @ n = $n + 1

end


