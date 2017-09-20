#!/bin/tcsh

set n = 1

set mpas_restart = "x1.40962.restart.nc"

foreach file (`ls filter_ics.00*`)

   set outdir = "advance_tmp$n"

   echo "converting $file to $outdir/$mpas_restart"

   cp $file dart.ic
   ./dart_to_model

   mkdir -p $outdir

   cp $mpas_restart $outdir
   
   @ n = $n + 1

end
