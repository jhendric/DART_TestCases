#!/bin/tcsh

mv *.o[0-9]* *.log *.err logs

rm rf *.nc *.txt dart_log.*

find . -type l -exec unlink {} \;
