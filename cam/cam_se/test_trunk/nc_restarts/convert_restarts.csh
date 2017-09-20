#!/bin/csh

set n = 1

set cam_file = "caminput.nc"

foreach file (`ls cam_se.i00*`)

   set fileout = `printf "%s%4.4d" filter_ics. $n`

   echo "converting $cam_file to $fileout"

   mv $file $cam_file

   ./cam_to_dart

   mv dart_ics $fileout
   mv $cam_file $file

   @ n = $n + 1

end
