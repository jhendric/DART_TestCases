#!/bin/tcsh

# IN THE TRUNK

echo "`date` -- BEGIN CLM-TO-DART"
set n = 1
set member = 1
set ensemble_size = 1

foreach CLM_FILE (clm_restart.*.nc)
   # Each member will do its job in its own directory.
   # That way, we can do N of them simultaneously -

   set     LND_RESTART_FILENAME = $CLM_FILE
   set     LND_HISTORY_FILENAME = `echo $CLM_FILE | sed 's#restart#history_out#'`
   set LND_VEC_HISTORY_FILENAME = `echo $CLM_FILE | sed 's#restart#vector_history_out#'`
   set         DART_IC_FILENAME = `printf filter_ics.%04d     ${member}`
   set        DART_RESTART_FILE = `printf filter_restart.%04d ${member}`
   
   ln -sf $LND_RESTART_FILENAME clm_restart.nc
   ln -sf $LND_HISTORY_FILENAME clm_history.nc

   if (  -e   $LND_VEC_HISTORY_FILENAME ) then
      ln -sf $LND_VEC_HISTORY_FILENAME clm_vector_history.nc
   endif

   echo "starting clm_to_dart for member ${member} at "`date`
   ./clm_to_dart >! output.${member}.clm_to_dart 
   
   mv dart_ics ${DART_IC_FILENAME}

   @ member++
end

