#!/bin/tcsh

#PBS -N wrf_glen
#PBS -A P86850054
#PBS -l walltime=04:00:00
#PBS -q regular
#PBS -j oe
#PBS -m abe
#PBS -M hendric@ucar.edu
#PBS -l select=2:ncpus=36:mpiprocs=36

### Set TMPDIR as recommended
mkdir -p /glade/scratch/hendric/temp
setenv TMPDIR /glade/scratch/hendric/temp


### Run the executable
## dplace - command to pin processes to the CPU preventing
## them from migrating and adversely affecting performance.

### Allinea ###
## module load allinea-forge/7.0.4
## ddt --connect mpiexec_mpt dplace -s 1 ./filter

set WORK='/glade/p/work/hendric/DART/Manhattan/models/wrf/work'
set PWD=`pwd`

set intel = 'i16'

set mpi = 'impi'
set mpi = 'openmpi'
set mpi = 'mpt'

set date=`date +%m_%d_%H_%M`
echo " This is the date compiled m_d_H_M :: $date"

### intel 16.0.3 and mpt 2.15f ###
if ( $intel == 'i16' && $mpi == 'mpt') then
   echo " Running with : intel 16.0.3 and mpt 2.15f "
   module load intel/16.0.3
   module load mpt/2.15f
   module list

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess  || exit 2
   make               || exit 3
   set PID=$!
   wait $PID
   ./preprocess       || exit 4
   ./mkmf_filter -mpi || exit 5
   make

   set fout = "filter_i16_mpt2.15f__$date"
   cp filter $fout

   cd $PWD 
   ln -sf $WORK/filter filter

   mpiexec_mpt dplace -s 1 ./filter
endif

### intel 16.0.3 and impi 5.1.3.210 ###
if ( $intel == 'i16' && $mpi == 'impi') then
   echo " Running with : intel 16.0.3 and impi 5.1.3.210 "
   module load intel/16.0.3
   module load impi/5.1.3.210

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess
   make
   ./preprocess
   ./mkmf_filter -mpi
   make

   set fout = "filter_i16_2.15f_impi5.1.3.210__$date"
   cp filter $fout

   cd -
   ln -sf $WORK/$fout filter

   mpirun dplace -s 1 ./filter
endif

### intel 16.0.3 and openmpi 2.1.0 ###
if ( $intel == 'i16' && $mpi == 'openmpi') then
   echo " Running with : intel 16.0.3 and openmpi 2.1.0 "
   module load intel/16.0.3
   module load openmpi/2.1.0

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess
   make
   ./preprocess
   ./mkmf_filter -mpi
   make

   set fout = "filter_i16_openmpi2.1.0__$date"
   cp filter $fout

   cd -
   ln -sf $WORK/$fout filter

   mpiexec dplace -s 1 ./filter
endif

### intel 17.0.1 and mpt 2.15f ###
if ( $intel == 'i17' && $mpi == 'mpt') then
   echo " Running with : intel 17.0.1 and mpt 2.15f "
   module load intel/17.0.1
   module load mpt/2.15f

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess
   make
   ./preprocess
   ./mkmf_filter -mpi
   make

   set fout = "filter_i17_mpt2.15f__$date"
   cp filter $fout

   cd -
   ln -sf $WORK/$fout filter

   mpiexec_mpt dplace -s 1 ./filter
endif

### intel 17.0.1 and openmpi 2.0.2 ###
if ( $intel == 'i17' && $mpi == 'openmpi') then
   echo " Running with : intel 17.0.1 and openmpi 2.0.2 "
   module load intel/17.0.1
   module load openmpi/2.0.2

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess
   make
   ./preprocess
   ./mkmf_filter -mpi
   make

   set fout = "filter_i17_openmpi2.02__$date"
   cp filter $fout

   cd -
   ln -sf $WORK/$fout filter

   mpiexec dplace -s 1 ./filter
endif

### intel 17.0.3 and impi 2017.1.132 ###
if ( $intel == 'i17' && $mpi == 'impi') then
   ### DOES NOT COMPILE                ###
   echo " Running with : intel 17.0.1 and impi 2.0.2 "
   module load intel/17.0.1
   module load impi/2017.1.132

   cd $WORK
   rm *.mod *.o
   ./mkmf_preprocess
   make
   ./preprocess
   ./mkmf_filter -mpi
   make

   set fout = "filter_i17_impi.2017.1.132__$date"
   cp filter $fout

   cd -
   ln -sf $WORK/$fout filter

   mpiexec dplace -s 1 ./filter
endif

exit 0
