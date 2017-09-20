#!/bin/csh

echo "##########################################################################"
echo "# Staging Files "
echo "##########################################################################"

set CLM_DIR = '/glade/p/image/DART_test_cases/clm/clm_new' 

######################### restart files #########################

set n = 1
set out_stub = 'clm_restart_out'
foreach file ($CLM_DIR/restarts/*.r.*)

   set dart_out = `printf "%s%4.4d%s" $out_stub.   $n .nc`
   set clm_out  = `printf "%s%4.4d%s" clm_restart. $n .nc`

   echo "copying clm_restart :: '$file' to '$dart_out'"
   echo "copying clm_restart :: '$file' to '$clm_out' "

   cp $file $dart_out 
   cp $file $clm_out 
   cp $file ../restarts

   @ n = $n + 1

end

ls -1 $out_stub.*       > restart_files_out.txt
ls -1 $CLM_DIR/restarts/*.r.* > restart_files.txt

cp $file clm_restart.nc

######################### history files #########################
set n = 1
set out_stub = 'clm_history_out'
foreach file ($CLM_DIR/restarts/*.h1.*)

   set dart_out = `printf "%s%4.4d%s" $out_stub. $n .nc`

   echo "copying clm_history :: '$file' to '$dart_out'"
   cp $file $dart_out 
   cp $file ../restarts

   @ n = $n + 1

end

ls -1 $out_stub.*     > history_files_out.txt
ls -1 $CLM_DIR/restarts/*.h1.* > history_files.txt

cp $file clm_history.nc

######################### history vector files #########################

set n = 1
set out_stub = 'clm_vector_history_out'
foreach file ($CLM_DIR/restarts/*.h2.*)

   set dart_out = `printf "%s%4.4d%s" $out_stub. $n .nc`

   echo "copying clm_vectory_history file :: '$file' to '$dart_out'"
   cp $file $dart_out 
   cp $file ../restarts
 
   @ n = $n + 1

end

ls -1 $out_stub.*     > vector_history_files_out.txt
ls -1 $CLM_DIR/restarts/*.h2.* > vector_history_files.txt

cp $file clm_vector_history.nc

chmod 666 *.nc

######################### tower history files ##########################

foreach file ($CLM_DIR/tower_history_files/*.h1.*)

   echo "copying tower_history files :: '$file' to '$dart_out'"
   cp $file ../tower_history_files/ 
 
end

echo "##########################################################################"
echo "# Finished Staging Files "
echo "##########################################################################"
