#!/bin/csh

set n = 1

set CAM_DIR = '/glade/p/image/DART_test_cases/cam/cam_fv' 

foreach file ($CAM_DIR/restarts/*.nc)

   set fout = `printf "%s%4.4d%s" cam_out. $n .nc`

   echo "linking '$file' here "
   ln -sf $file .
   
   echo "copying '$file' to '$fout'"
   cp $file  $fout 
   chmod u+w $fout

   @ n = $n + 1

end

ln -sf $CAM_DIR/test_rma/camfile.nc   . 
ln -sf $CAM_DIR/test_rma/caminput.nc  . 
ln -sf $CAM_DIR/test_rma/cam_phis.nc  . 
