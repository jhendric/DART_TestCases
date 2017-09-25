#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_filter.csh 11626 2017-05-11 17:27:50Z nancy@ucar.edu $
#
# Script to assimilate observations using DART and the POP ocean model.
# This presumes two directories exists that contain all the required bits
# for POP and for DART.

### Set TMPDIR as recommended
mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR  /glade/scratch/hendric/temp
setenv TEMPDIR /glade/scratch/hendric/temp
setenv TEMP    /glade/scratch/hendric/temp
setenv TMP     /glade/scratch/hendric/temp

echo "--------------------------------------------------------------------------"
echo "Linking POP files "
echo "--------------------------------------------------------------------------"

csh link_programs.csh
while (`ps -p $PID | wc -l >1`)
    sleep 5
    echo "sleeping ....."
end

echo "--------------------------------------------------------------------------"
echo "Staging POP files "
echo "--------------------------------------------------------------------------"

csh stage_restarts.csh
while (`ps -p $PID | wc -l >1`)
    sleep 5
    echo "sleeping ....."
end

echo "--------------------------------------------------------------------------"
echo "Submitting to queue"
echo "--------------------------------------------------------------------------"

csh submit.csh

cp -p *.log *.err LOGS/

