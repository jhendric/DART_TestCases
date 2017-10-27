#!/bin/tcsh

rm *.nc *.txt dart_log.*

unlink filter
unlink perfect_model_obs
unlink clm_to_dart
unlink dart_to_clm

mkdir -p logs
mv *.o[0-9]* *.log *.err logs

rm rf *.nc *.txt dart_log.*

find . -type l -exec unlink {} \;
