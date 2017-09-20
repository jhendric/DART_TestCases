#!/bin/csh -f
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# $Id: $

# This exercises just a single instance of wrf_to_dart

# set    DARTDIR = /glade/scratch/thoar/wrf_chem_dart/models/wrf_chem/work
set      DARTDIR = /glade/p/work/thoar/DART/mizzi/models/wrf_chem/work
set GOLDSTANDARD = /glade/p/image/DART_test_cases/wrf_chem/FRAPPE_CPSR_VARLOC

set TESTCASE = /glade/scratch/thoar/wrf_chem_test

echo "GOLD STANDARD is  $GOLDSTANDARD"
echo "Comparing $TESTCASE"
echo "date is "`date`
echo " "

mkdir -p $TESTCASE
cd $TESTCASE


cp $GOLDSTANDARD/input.nml .  || exit 1

set LOGFILE = differences_log.$$.txt
\rm -f $LOGFILE

foreach FILE ( Posterior_Diag.nc  \
               Prior_Diag.nc  )

   echo "Testing $FILE"
   echo "Testing $FILE" >> $LOGFILE
   echo $TESTCASE/$FILE $GOLDSTANDARD/$FILE | $DARTDIR/compare_states >! log.$$.txt

   grep 'arrays differ' log.$$.txt
   cat log.$$.txt >> $LOGFILE

   echo "" >> $LOGFILE
   \rm log.$$.txt

end


foreach FILE ( prior_inflate_ic_new \
               assim_model_state_ic.0001  \
               assim_model_state_ic.0002  \
               assim_model_state_ic.0003  \
               assim_model_state_ic.0004  \
               assim_model_state_ic.0005  \
               assim_model_state_ic.0006  \
               assim_model_state_ic.0007  \
               assim_model_state_ic.0008  \
               assim_model_state_ic.0009  \
               assim_model_state_ic.0010  \
               assim_model_state_ic.0011  \
               assim_model_state_ic.0012  \
               assim_model_state_ic.0013  \
               assim_model_state_ic.0014  \
               assim_model_state_ic.0015  \
               assim_model_state_ic.0016  \
               assim_model_state_ic.0017  \
               assim_model_state_ic.0018  \
               assim_model_state_ic.0019  \
               assim_model_state_ic.0020 )

   echo "Testing $FILE"
   echo "Testing $FILE" >> $LOGFILE
   cmp $TESTCASE/$FILE $GOLDSTANDARD/$FILE >! log.$$.txt

   grep 'differ' log.$$.txt
   cat log.$$.txt >> $LOGFILE

   echo "" >> $LOGFILE
   \rm log.$$.txt
end


foreach FILE ( obs_seq.final )

   echo "Testing $FILE"
   echo "Testing $FILE" >> $LOGFILE

   cmp $TESTCASE/$FILE $GOLDSTANDARD/$FILE >! log.$$.txt
   set cmpstat = $status

   if ($cmpstat != 0) then
      diff $TESTCASE/$FILE $GOLDSTANDARD/$FILE >> log.$$.txt
      cat log.$$.txt
   endif

   cat log.$$.txt >> $LOGFILE
   echo ""        >> $LOGFILE
   \rm log.$$.txt

end

exit 0

# <next few lines under version control, do not edit>
# $URL: $
# $Revision: $
# $Date: $

