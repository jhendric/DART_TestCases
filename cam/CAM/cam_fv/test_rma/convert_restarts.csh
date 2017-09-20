#!/bin/csh

set n = 1

foreach file (`ls fv_testcase*.i.*`)

   set fileout = `printf "%s%4.4d" filter_ics. $n`

   echo "converting $file to $fileout"

   # rename file for &cam_to_dart_nml
   cp $file camfile.nc

   # convert the file
   ./cam_to_dart

   # rename the converted file to an the appropriate dart name
   cp dart_ics $fileout

   # move the file back to its original location
   #mv caminput.nc $file
   if ($n == 3) then
      exit(0)
   endif

   @ n = $n + 1

end
