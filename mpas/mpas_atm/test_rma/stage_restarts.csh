#!/bin/csh

echo "##########################################################################"
echo "# Staging Files "
echo "##########################################################################"

set MPAS_DIR = '/glade/p/image/DART_test_cases/mpas' 

######################### restart files #########################

set n = 1
set out_stub = 'mpas_out'

foreach dir (`find $MPAS_DIR/restarts -name 'advance_tmp*' | sort -V | sed 's/://g'`)
   
   echo "DIR $dir "

   set dart_out = `printf "%s%4.4d%s" $out_stub.    $n .nc`
   set mpas_out = `printf "%s%4.4d%s" mpas_restart. $n .nc`


   echo "filling restart directory with '$dir'"
   cp -r $dir ../restarts/

   echo "copying mpas_restart :: '$dir/x1.40962.restart.nc' to '$dart_out'"
   echo "copying mpas_restart :: '$dir/x1.40962.restart.nc' to '$mpas_out'"
   
   set base = `basename $dir`
   cp ../restarts/$base/*restart*.nc $dart_out
   cp ../restarts/$base/*restart*.nc $mpas_out

   @ n = $n + 1

end

ls -1 $out_stub.*                                  | sort -V > restart_files_out.txt
ls -1 ../restarts/advance_tmp*/x1.40962.restart.nc | sort -V > restart_files_in.txt

cp ../restarts/advance_tmp1/x1.40962.mesh.nc   .
cp ../restarts/advance_tmp1/x1.40962.restart.nc .
