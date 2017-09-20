#!/bin/csh
set n = 1

set POP_DIR = '/glade/p/image/DART_test_cases/pop/pop_gx1v6' 

if ( 1 == 0) then

foreach file ($POP_DIR/restarts/pop.r00*)

   set fileout = `printf "%s%4.4d%s" pop_out. $n .nc`

   echo "copying $file here"
   cp $file .
   
   echo "copying '$file' to '$fileout' here"
   cp $file $fileout

   echo "filling restart directory with '$file'"
   cp $file ../restarts/
   
   @ n = $n + 1

end

cp $file pop.r.nc
endif

foreach file ($POP_DIR/inputdata/*)
   echo "filling pop input data with '$file'"
   cp -v $file ../inputdata/
end


exit 0
