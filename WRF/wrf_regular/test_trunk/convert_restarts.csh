#!/bin/tcsh

set n = 1

foreach file (`ls filter_ic.00*`)

   echo "converting $file to wrfinput_d01"

   mv $file dart_wrf_vector
   ./dart_to_wrf
   mv dart_wrf_vector $file

   set outdir = "advance_tmp$n"

   mkdir -p $outdir

   cp wrfinput_d01 $outdir

   @ n = $n + 1

end
