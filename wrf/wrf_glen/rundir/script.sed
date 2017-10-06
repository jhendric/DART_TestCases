2i\
#=================================================================\
#PBS -N assimilate_2016052312\
#PBS -j oe\
#PBS -A NMMM0044\
#PBS -l walltime=00:30:00\
#PBS -q regular\
#PBS -m a\
#PBS -M romine@ucar.edu\
#PBS -l select=15:ncpus=36:mpiprocs=36\
#=================================================================
s%${1}%2016052312%g
s%${3}%/glade2/scratch2/romine/visitors/mikec/scripts/param.csh%g
