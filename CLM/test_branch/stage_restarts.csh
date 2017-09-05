#!/bin/csh

echo "##########################################################################"
echo "# Staging Files "
echo "##########################################################################"


######################### restart files #########################

set n = 1
set out_stub = 'clm_restart_out'
foreach file (../restarts/*.r.*)

   set dart_out = `printf "%s%4.4d%s" $out_stub.   $n .nc`
   set clm_out  = `printf "%s%4.4d%s" clm_restart. $n .nc`

   # echo "copying restart :: $file to run working directory"
   # cp -f $file . 

   echo "copying clm_restart :: '$file' to '$dart_out' in working directory"
   echo "copying clm_restart :: '$file' to '$clm_out'  in working directory"

   cp $file $dart_out 
   cp $file $clm_out 

   @ n = $n + 1

end

ls -1 $out_stub.*       > restart_files_out.txt
ls -1 ../restarts/*.r.* > restart_files.txt

cp $file clm_restart.nc

######################### history files #########################
set n = 1
set out_stub = 'clm_history_out'
foreach file (../restarts/*.h1.*)

   set dart_out = `printf "%s%4.4d%s" $out_stub. $n .nc`

   # echo "copying history :: $file to run working directory"
   # cp -f $file .

   echo "copying clm_history :: '$file' to '$dart_out' in working directory"
   cp $file $dart_out 

   @ n = $n + 1

end

ls -1 $out_stub.*        > history_files_out.txt
ls -1 ../restarts/*.h1.* > history_files.txt

cp $file clm_history.nc

######################### history vector files #########################

set n = 1
set out_stub = 'clm_vector_history_out'
foreach file (../restarts/*.h2.*)

   set dart_out = `printf "%s%4.4d%s" $out_stub. $n .nc`

   # echo "linking history_vector :: $file to run working directory"
   # cp -f $file .

   echo "copying clm_vectory_history file :: '$file' to '$dart_out' in working directory"
   cp $file $dart_out 
 
   @ n = $n + 1

end

echo "##########################################################################"
echo "# Finished Staging Files "
echo "##########################################################################"

ls -1 $out_stub.*        > vector_history_files_out.txt
ls -1 ../restarts/*.h2.* > vector_history_files.txt

cp $file clm_vector_history.nc

chmod 666 *.nc
