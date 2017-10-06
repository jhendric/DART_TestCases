#!/bin/csh -f

#PBS -N wrf_glen
#PBS -A P86850054
#PBS -l walltime=04:00:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=30:ncpus=36:mpiprocs=36

### Set TMPDIR as recommended
mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR /glade/scratch/hendric/temp

echo "                        "
echo " -- STARTING TESTING -- "
echo "                        "


### Run the executable
## dplace - command to pin processes to the CPU preventing
## them from migrating and adversely affecting performance.

### Allinea ###
## module load allinea-forge/7.0.4
## ddt --connect mpiexec_mpt dplace -s 1 ./filter

set WORK='/glade/p/work/hendric/DART/Manhattan/models/wrf/work'
set PWD=`pwd`

set intel = 'i16'
set intel = 'i17'

set mpi = 'impi'
set mpi = 'openmpi'
set mpi = 'mpt'

set date=`date +%m_%d_%H_%M`
echo " This is the date compiled m_d_H_M :: $date"

rm      dart_log.out
touch   dart_log.out
tail -f dart_log.out &

### intel 16.0.3 and mpt 2.15f ###
#if ( $intel == 'i16' && $mpi == 'mpt') then
   echo " "
   echo " **************************************** "
   echo " Making with : intel 16.0.3 and mpt 2.15f "
   echo " **************************************** "
   module load intel/16.0.3
   module load mpt/2.15f

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

   make
   set PID=$!
   while (`ps -p $PID | wc -l >1`)
       sleep 5
       echo "sleeping ....."
   end

   set fout = "filter_i16_mpt2.15f__$date"
   cp filter $fout

   cd $PWD 
   echo " ********************* "
   echo " LINKING FILTER '$fout'"
   echo " ********************* "
   ln -sf $WORK/$fout filter

   echo " ***************************************** "
   echo " Running with : intel 16.0.3 and mpt 2.15f "
   echo " ***************************************** "
   qsub -W block=true run_mpt.csh

   # set PID=$!
   # while (`ps -p $PID | wc -l >1`)
   #     sleep 5
   #     echo "q sleeping ....."
   # end

#endif

### intel 16.0.3 and impi 5.1.3.210 ###
#if ( $intel == 'i16' && $mpi == 'impi') then
   echo " "
   echo " ********************************************* "
   echo " Making with : intel 16.0.3 and impi 5.1.3.210 "
   echo " ********************************************* "
   module load intel/16.0.3
   module load impi/5.1.3.210

   echo " "
   module list

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess  || exit 22
   make               || exit 23
   ./preprocess       || exit 24
   ./mkmf_filter -mpi || exit 25
   make               || exit 26

   make
   set PID=$!
   while (`ps -p $PID | wc -l >1`)
       sleep 5
   end

   set fout = "filter_i16_2.15f_impi5.1.3.210__$date"
   cp filter $fout

   cd -
   echo " ********************* "
   echo " LINKING FILTER '$fout'"
   echo " ********************* "
   ln -sf $WORK/$fout filter

   echo " ********************************************** "
   echo " Running with : intel 16.0.3 and impi 5.1.3.210 "
   echo " ********************************************** "
   qsub -W block=true run_impi.csh

   # set PID=$!
   # while (`ps -p $PID | wc -l >1`)
   #     sleep 5
   # end

#endif

### intel 16.0.3 and openmpi 2.1.0 ###
#if ( $intel == 'i16' && $mpi == 'openmpi') then
   echo " "
   echo " ******************************************** "
   echo " Making with : intel 16.0.3 and openmpi 2.1.0 "
   echo " ******************************************** "
   module load intel/16.0.3
   module load openmpi/2.1.0

   echo " "
   module list

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess  || exit 32
   make               || exit 33
   ./preprocess       || exit 34
   ./mkmf_filter -mpi || exit 35
   make               || exit 36
   
   make
   set PID=$!
   while (`ps -p $PID | wc -l >1`)
       sleep 5
   end

   set fout = "filter_i16_openmpi2.1.0__$date"
   cp filter $fout

   cd $PWD
   echo " ********************* "
   echo " LINKING FILTER '$fout'"
   echo " ********************* "
   ln -sf $WORK/$fout filter

   echo " ******************************************** "
   echo " Running with : intel 16.0.3 and openmpi 2.1.0 "
   echo " ******************************************** "
   qsub -W block=true run_openmpi.csh 

   # set PID=$!
   # while (`ps -p $PID | wc -l >1`)
   #     sleep 5
   # end

#endif

### intel 17.0.1 and mpt 2.15f ###
# if ( $intel == 'i17' && $mpi == 'mpt') then
   echo " "
   echo " **************************************** "
   echo " Making with : intel 17.0.1 and mpt 2.15f "
   echo " **************************************** "

   module load intel/17.0.1
   module load mpt/2.15f

   echo " "
   module list

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess  || exit 42
   make               || exit 43
   ./preprocess       || exit 44
   ./mkmf_filter -mpi || exit 45
   make               || exit 46
   
   make
   set PID=$!
   while (`ps -p $PID | wc -l >1`)
       sleep 5
   end

   set fout = "filter_i17_mpt2.15f__$date"
   cp filter $fout

   cd $PWD
   echo " ********************* "
   echo " LINKING FILTER '$fout'"
   echo " ********************* "
   ln -sf $WORK/$fout filter

   echo " ***************************************** "
   echo " Running with : intel 17.0.1 and mpt 2.15f "
   echo " ***************************************** "

   qsub -W block=true run_mpt.csh

   # set PID=$!
   # while (`ps -p $PID | wc -l >1`)
   #     sleep 5
   # end

   #mpiexec_mpt dplace -s 1 ./filter
#endif

### intel 17.0.1 and openmpi 2.0.2 ###
#if ( $intel == 'i17' && $mpi == 'openmpi') then
   echo " "
   echo " ******************************************** "
   echo " Making with : intel 17.0.1 and openmpi 2.0.2 "
   echo " ******************************************** "

   module load intel/17.0.1
   module load openmpi/2.0.2

   cd $WORK
   echo " **************** "
   echo " BUILDING FILTER  "
   echo " **************** "
   rm *.mod *.o
   ./mkmf_preprocess  || exit 52
   make               || exit 53
   ./preprocess       || exit 54
   ./mkmf_filter -mpi || exit 55
   make               || exit 56

   make
   set PID=$!
   while (`ps -p $PID | wc -l >1`)
       sleep 5
   end

   set fout = "filter_i17_openmpi2.02__$date"
   cp filter $fout

   cd $PWD
   echo " ********************* "
   echo " LINKING FILTER '$fout'  "
   echo " ********************* "
   ln -sf $WORK/$fout filter

   echo " ***************************************** "
   echo " Running with : intel 17.0.1 and mpt 2.15f "
   echo " ***************************************** "

   qsub -W block=true run_openmpi.csh

   # set PID=$!
   # while (`ps -p $PID | wc -l >1`)
   #     sleep 5
   # end

#endif

#  ### intel 17.0.3 and impi 2017.1.132 ###
#  #if ( $intel == 'i17' && $mpi == 'impi') then
#     ### DOES NOT COMPILE                ###
#     echo " ****************************************** "
#     echo " Making with : intel 17.0.1 and impi 2017.1.132 "
#     echo " ****************************************** "
#     module load intel/17.0.1
#     module load impi/2017.1.132
#  
#     cd $WORK
#     rm *.mod *.o
#     ./mkmf_preprocess  || exit 62
#     make               || exit 63
#     ./preprocess       || exit 64
#     ./mkmf_filter -mpi || exit 65
#     make               || exit 66
#  
#     set fout = "filter_i17_impi.2017.1.132__$date"
#     cp filter $fout
#     set PID=$!
#     wait $PID
#  
#     cd -
#     echo " **************** "
#     echo " LINKING FILTER "
#     echo " **************** "
#     #ln -sf $WORK/$fout filter
#  
#     #mpiexec dplace -s 1 ./filter
#  #endif

echo "vi " `ls -1rt *.o1* | tail --lines 5` > open_files.csh

echo "                        "
echo " -- FINISHED TESTING -- "
echo "                        "

exit 0
