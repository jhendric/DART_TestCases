#!/bin/csh

echo "##########################################################################"
echo "# Staging Files "
echo "##########################################################################"

set WRF_DIR = '/glade/p/image/DART_test_cases/wrf/wrf_regular' 

######################### restart files #########################

set n = 1
set out_stub = 'wrf_out'

foreach dir (`find $WRF_DIR/restarts -name 'advance_tmp*' | sort -V | sed 's/://g'`)
   
   echo "DIR $dir "

   set dart_out = `printf "%s%4.4d%s" $out_stub.    $n .nc`
   set wrf_out = `printf "%s%4.4d%s" wrf_restart. $n .nc`


   echo "filling restart directory with '$dir'"
   cp -r $dir ../restarts/ || exit 1

   echo "copying wrf_restart :: '$dir/wrfinput_d01' to '$dart_out'"
   echo "copying wrf_restart :: '$dir/wrfinput_d01' to '$wrf_out'"
   
   set base = `basename $dir`
   cp ../restarts/$base/wrfinput_d01 $dart_out || exit 2
   cp ../restarts/$base/wrfinput_d01 $wrf_out  || exit 3

   @ n = $n + 1

end

ls -1 $out_stub.*                           | sort -V > restart_files_out.txt || exit 4
ls -1 ../restarts/advance_tmp*/wrfinput_d01 | sort -V > restart_files_in.txt  || exit 5

cp ../restarts/advance_tmp1/wrfinput_d01 . || exit 6
