#!/bin/tcsh

# IN RMA

# dart_to_clm is expecting a clm_missing_r8.nc file to 
# convert the data to.

set n = 1

# need an inital list for initializing clm
set rest_in =   'restart_files.txt'

foreach clm_rest (`ls clm_restart.*.nc`)
   set num         = `printf "%04d " $n`
   set clm_missing = "clm_missing_r8.$num.nc"

   echo "**************************************************************************"
   echo " Converting $clm_rest to $clm_missing"
   echo "**************************************************************************"
   
   ## We might need to convert values in some of the other clm files
   # cp clm4_121_hybrid_test.clm2_$num.h2.* clm_vector_history.nc
   # cp clm4_121_hybrid_test.clm2_$num.h1.* clm_history.nc
   
   # clm_restart_filename is specified as 'clm_restart.nc' from the model_mod nml`
   # It is also the input file for clm_to_dart
   echo "copying ::    '$clm_rest'  'clm_restart.nc' for conversion"
   cp $clm_rest  clm_restart.nc

   # clm_to_dart_filename is specified in the clm_to_dart namelist as 'clm_missing_r8.nc'
   # This file must exist already before clm_to_dart runs, otherwise it will die.
   echo "making  ::    a template file 'clm_missing_r8.nc'    to stage the conversion"
   cp $clm_rest  clm_missing_r8.nc 

   echo "running ::    'clm_to_dart'. Converting '$clm_rest' to '$clm_missing'"
   ./clm_to_dart >& my_convert_clm.$$.log

   # renaming file to clm_missing_r8.#.nc, so it havs the ensemble number in it
   echo "moving  ::    'clm_missing_r8.nc' to '$clm_missing'"
   mv clm_missing_r8.nc $clm_missing 

   echo "**************************************************************************"
   echo " Finished converting $clm_rest "
   echo "**************************************************************************"

   @ n = $n + 1

end

echo "making  ::   restart_file_list for input to filter '$rest_in'"

ls -1 clm_missing_r8.*.nc > $rest_in

echo "contents of $rest_in files :: "
cat $rest_in

exit 0
