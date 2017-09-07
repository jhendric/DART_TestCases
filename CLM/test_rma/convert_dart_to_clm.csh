#!/bin/tcsh

# dart_to_clm has namelist variable clm_output_restart='model_restart.nc'
# this file will be WRITTEN to.

set n = 1

# we are looping over all of the original clm restart files
foreach original_clm (clm_restart.*.nc)

   # this is what came out of filter
   # these still have the missing r8 values
   set filter_output = `printf "%s%4.4d%s" clm_restart_out. $n .nc`

   echo "**************************************************************************"
   echo " Updating $original_clm with $filter_output data."
   echo "**************************************************************************"

   # This is the updated DART state. The input.nml &model_nml clm_restart.nc
   # This is the file that contains the DART state that the converter reads.
   ln -sf $filter_output clm_restart.nc 
   ln -sf $original_clm  model_restart.nc
  
   # this writes out 'model_restart.nc'
   ./dart_to_clm >& my_convert_dart.$$.log || exit 1

   echo "**************************************************************************"
   echo " Finished updating '$original_clm'"
   echo "**************************************************************************"

   @ n = $n + 1
end

rm -f model_restart.nc clm_restart.nc

exit 0
