#!/bin/tcsh

echo "`date` -- BEGIN DART-TO-CLM"

set n = 1
foreach FILTER_RESTART (filter_restart.*)

   # prepare the output files for updating
   set clm_restart         = `printf "%s%04d%s" clm_restart.            $n .nc`
   set clm_history         = `printf "%s%04d%s" clm_history_out.        $n .nc`
   set clm_vector_history  = `printf "%s%04d%s" clm_vector_history_out. $n .nc`

   ln -sf $clm_restart        clm_restart.nc
   ln -sf $clm_history        clm_history.nc
   ln -sf $clm_vector_history clm_vector_history.nc

   echo "Running dart_to_clm"
   
   # unique to the unique input file
   cp $FILTER_RESTART dart_restart 

   # dart_to_clm will update clm_restart.nc clm_history.nc and clm_vector_history.nc
   # as implied by the namelist, could use Tim's sed stuff
   ./dart_to_clm >! convert_dart.$n.log
   

   @ n = $n + 1

end

echo "`date` -- END DART-TO-CLM"

exit 0

# set n = 1
# foreach FILTER_RESTART (filter_restart.*)
# 
#    set clm_restart         = `printf "%s%04d%s" clm_restart.            $n .nc`
#    set clm_history         = `printf "%s%04d%s" clm_history_out.        $n .nc`
#    set clm_vector_history  = `printf "%s%04d%s" clm_vector_history_out. $n .nc`
# 
#    echo "Running dart_to_clm"
#    
#    cp $FILTER_RESTART dart_restart 
# 
#    ln -sf $clm_restart        clm_restart.nc
#    ln -sf $clm_history        clm_history.nc
#    ln -sf $clm_vector_history clm_vector_history.nc
# 
#    ./dart_to_clm >! convert_dart.$n.log
#    
#    # dart_to_clm will update clm_restart.nc clm_history.nc and clm_vector_history.nc
# 
#    @ n = $n + 1
# 
# end
# 
