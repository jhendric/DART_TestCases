#!/bin/csh
#=============================================================================
#                yellowstone
#BSUB -J cice
#BSUB -o cice_filter.%J.log
#BSUB -P P86850054
#BSUB -q small
#BSUB -n 6
#BSUB -R "span[ptile=16]"
#BSUB -W 0:30
#BSUB -N -u ${USER}@ucar.edu
#=============================================================================
#                cheyenne
#PBS -N cice
#PBS -e cice_filter.err
#PBS -o cice_filter.log
#PBS -l nodes=1:ppn=16
#PBS -r n

set RUNDIR = /glade/scratch/${USER}/cice_regression
mkdir -p $RUNDIR
cd $RUNDIR

cp -v /glade/p/image/DART_test_cases/cice/goldstandard/drv_in                .            || exit 1
cp -v /glade/p/image/DART_test_cases/cice/goldstandard/cice_in               .            || exit 1
cp -v /glade/p/image/DART_test_cases/cice/goldstandard/input.nml             .            || exit 1
cp -v /glade/p/image/DART_test_cases/cice/goldstandard/filter                .            || exit 1
cp -v /glade/p/image/DART_test_cases/cice/goldstandard/dart_to_cice          .            || exit 1
cp -v /glade/p/image/DART_test_cases/cice/input_obs/obs_seq.2001-02-01-00000 obs_seq.out  || exit 2
cp -v /glade/p/image/DART_test_cases/cice/input_data/openloop_branch*nc      .            || exit 3

#-----------------------------------------------------------------------
# create the list of restart files and a set of 'priors'.
# The priors normally point to the day before and are used in part
# of the 'dart_to_model' massaging of the posterior state.
#-----------------------------------------------------------------------

ls  -1 openloop_branch*nc >! cice_restarts.txt

set ensemble_size = `cat cice_restarts.txt | wc -l`

set member = 1
while ( ${member} <= ${ensemble_size} )

   set  PRIOR_FILE = `printf cice_prior.r.%04d.nc ${member}`

   set MYFILE = `head -n $member cice_restarts.txt | tail -n 1`
   set ICE_FILENAME = `echo $MYFILE:t`

   cp -v ${ICE_FILENAME} ${PRIOR_FILE} &

   @ member++
end

#-----------------------------------------------------------------------
# run filter
#-----------------------------------------------------------------------

ln -s openloop_branch.cice_0001.r.2001-02-01-00000.nc cice.r.nc

mpirun.lsf ./filter || exit 4

#-----------------------------------------------------------------------
# run dart_to_model on each posterior
#-----------------------------------------------------------------------

set member = 1
while ( ${member} <= ${ensemble_size} )

   set inst_string = `printf       _%04d $member`
   set  member_dir = `printf member_%04d $member`

   if (! -d ${member_dir}) mkdir ${member_dir}
   cd ${member_dir}

   rm -f output.${member}.dart_to_ice

   set ICE_FILENAME = `head -n $member ../cice_restarts.txt | tail -n 1`

   ln -sf ../${ICE_FILENAME} dart_restart.nc
   set PRIOR_FILENAME = `printf cice_prior.r.%04d.nc $member`
   ln -sf ../${PRIOR_FILENAME} cice_restart.nc

   ln -sf ../input.nml .

   echo "starting dart_to_ice for member ${member} at "`date`
   ../dart_to_cice >! output.${member}.dart_to_ice &

   cd ..

   @ member++
end

