#!/bin/csh

#PBS -N runall 
#PBS -A P86850054
#PBS -l walltime=05:00:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=1:ncpus=1

### Set TMPDIR as recommended

mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR /glade/scratch/hendric/temp

### Set TMPDIR as recommended
mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR /glade/scratch/hendric/temp

echo "                        "
echo " -- STARTING TESTING -- "
echo "                        "


### Run the executable
## dplace - command to pin processes to the CPU preventing
## them from migrating and adversely affecting performance.

set WORK='/glade/p/work/hendric/DART/clean_Manhattan/models/wrf/work'
set PWD=`pwd`

set DO_THESE_COMPILERS = ('i17')
# set intel = 'i16'
# set intel = 'i17'

set DO_THESE_MPI = ( impi )###'mpt' )###'openmpi' 'impi')

# set mpi = 'impi'
# set mpi = 'openmpi'
# set mpi = 'mpt'

set date=`date +%m_%d_%H_%M`
echo " This is the date compiled m_d_H_M :: $date"

# rm      dart_log.out
touch   dart_log.out
tail -f dart_log.out &
set TAIL_PID=$! 

foreach COMPILER ( $DO_THESE_COMPILERS)
   foreach MPI ( $DO_THESE_MPI )

      if      ( $COMPILER == 'i16' ) then
         module load intel/16.0.3
      else if ( $COMPILER == 'i17' ) then
         module load intel/17.0.1
      else
         echo "Unknown compiler, exiting."
         exit -2
      endif

      module load $MPI

      echo " "
      echo " **************************************** "
      echo " Making with : $COMPILER and $MPI         "
      echo " **************************************** "

      echo " "
      module list

      cd $WORK
      echo " **************** "
      echo " BUILIDING FILTER "
      echo " **************** "

      rm *.mod *.o
      ./mkmf_preprocess  || exit 12
      make               || exit 13
      ./preprocess       || exit 14
      ./mkmf_filter -mpi || exit 15
      make               || exit 16

      set PID=$!
      while (`ps -p $PID | wc -l >1`)
          sleep 5
          echo "sleeping ....."
      end

      set fout = "filter_${COMPILER}_${MPI}__$date"
      cp filter $fout

      cd $PWD 
      echo " ********************* "
      echo " LINKING FILTER '$fout'"
      echo " ********************* "
      cp $WORK/$fout $fout
      cp $WORK/$fout filter_cy 

      echo " ***************************************** "
      echo " Running with : '$COMPILER' and '$MPI'     "
      echo " ***************************************** "

      echo " "
      module list

      if      ($MPI == 'mpt') then
         qsub -W block=true run_mpt.csh
      else if ($MPI == 'impi') then
         qsub -W block=true run_impi.csh
      else if ($MPI == 'openmpi') then
         qsub -W block=true run_openmpi.csh
      else if ($MPI == 'openmpi' && $COMPILER = 'i17') then
         "Skipping this test"
      else
         echo "unknown compiler exiting"
         exit -1
      endif

   echo " "
   echo " ******************************************************* "
   echo " Finished Running test with : '$COMPILER' and '$MPI'     "
   echo " ******************************************************  "

   end
end
kill $TAIL_PID

echo "vi " `ls -1rt *.o1* | tail --lines 5` > open_files.csh

echo "                        "
echo " -- FINISHED TESTING -- "
echo "                        "

exit 0

