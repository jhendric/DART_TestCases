#!/bin/csh

set n = 1

# set CAM_DIR = '/glade/p/image/DART_test_cases/cam/cam_fv' 
set CAM_DIR = '/Users/hendric/DART/DART_TestCases/cam/cam_fv/' 

if (-d $CAM_DIR/restarts) then
   echo "found $CAM_DIR !"
else
   echo "need to specify a restart directory in stage_restarts.csh"
endif

foreach cam_restart ($CAM_DIR/restarts/fv_testcase.i.*.nc)

   set dart_output = `printf "%s%4.4d%s" cam_out. $n .nc`
   set base = `basename $cam_restart`

   if ( -f $cam_restart) then
      echo "$cam_restart already exists"
      set DIFF = `diff $cam_restart $base`
      #echo "$DIFF"
   else
      echo "copying '$cam_restart' . "
      cp $cam_restart .
   endif

   if ( -f $dart_output) then
      echo "$cam_restart already exists checking diff"
      set DIFF = `diff $cam_restart $base`
      #echo "$DIFF"
   else
      echo "copying '$cam_restart' to '$dart_output'"
      cp $cam_restart  $dart_output 
      chmod u+w $dart_output
   endif

   @ n = $n + 1

end

cp $CAM_DIR/restarts/camfile.nc   .
cp $CAM_DIR/restarts/caminput.nc  . 
cp $CAM_DIR/restarts/cam_phis.nc  . 

ls -1 $CAM_DIR/restarts/fv_testcase.i.*.nc > restart_files_in.txt
ls -1 cam_out.*.nc       > restart_files_out.txt
