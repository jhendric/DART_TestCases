#!/bin/tcsh

<<<<<<< HEAD
rm *.nc *.txt dart_log.*

unlink filter
unlink perfect_model_obs
unlink clm_to_dart
unlink dart_to_clm
=======
mv *.o[0-9]* *.log *.err logs

rm rf *.nc *.txt dart_log.*

find . -type l -exec unlink {} \;
>>>>>>> master
