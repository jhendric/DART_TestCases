#!/bin/tcsh

mkdir -p logs

mv *.o[0-9]* *.log *.err logs

rm rf *.nc *.txt dart_log.*

rm rf ../resarts/advane_tmp*/wrfinput_*

find . -type l -exec unlink {} \;
