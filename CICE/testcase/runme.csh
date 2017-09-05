#!/bin/csh
#=============================================================================
#                yellowstone        bsub < runme.csh
#BSUB -J cice
#BSUB -o cice_filter.%J.log
#BSUB -P P86850054
#BSUB -q small
#BSUB -n 6
#BSUB -R "span[ptile=16]"
#BSUB -W 0:30
#BSUB -N -u ${USER}@ucar.edu
#=============================================================================
#                cheyenne           qsub runme.csh
#PBS -N cice
#PBS -e cice_filter.err
#PBS -o cice_filter.log
#PBS -A P86850054
#PBS -l select=1:ncpus=18:mpiprocs=18
#PBS -l walltime=00:20:00
#PBS -q regular
#PBS -r n
#### Select X nodes with N CPUs/node and T MPI processes/node
#### -l select=X:ncpus=N:mpiprocs=T
#### -l select=10:ncpus=36:mpiprocs=18
#### so this is 10 nodes, with 18 mpi processes per node for a total of 180 tasks

echo "uname -a is "`uname -a`
echo "hostname is "`hostname`
echo "HOSTNAME is "$HOSTNAME

switch ("`hostname`")
   case ys*:
      # yellowstone
      set LAUNCHCMD = 'mpirun.lsf'
      set RUNDIR = /glade/scratch/${USER}/cice_yellowstone
   breaksw

   case r*:
      # cheyenne has nodes like r1i0n14
      set LAUNCHCMD = 'mpiexec_mpt omplace'
      set RUNDIR = /glade/scratch/${USER}/cice_cheyenne18
   breaksw

   default:
      # everybody else
      set LAUNCHCMD = 'mpirun'
      set RUNDIR = /glade/scratch/${USER}/cice_other
   breaksw
endsw

echo ""
env | sort 
echo ""

\rm  -rf ${RUNDIR}
mkdir -p ${RUNDIR}
cd       ${RUNDIR}

ln -s /glade/u/home/thoar/svn/DART/rma_trunk/models/cice/work/input.nml      .            || exit 1
ln -s /glade/u/home/thoar/svn/DART/rma_trunk/models/cice/work/filter         .            || exit 1
ln -s /glade/u/home/thoar/svn/DART/rma_trunk/models/cice/work/dart_to_cice   .            || exit 1

cp -v /glade/p/image/DART_test_cases/cice/goldstandard/drv_in                .            || exit 1
cp -v /glade/p/image/DART_test_cases/cice/goldstandard/cice_in               .            || exit 1
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

${LAUNCHCMD} ./filter || exit 4

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

