#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/rma_timing'

cd $DART_DIR/models/POP/work
rm *.mod *.o

   module list

cp $DART_DIR/build_templates/mkmf.template.intel.linux $DART_DIR/build_templates/mkmf.template 

./mkmf_preprocess        || exit 1
make
./preprocess
./mkmf_filter -mpi       || exit 2
make
./mkmf_perfect_model_obs || exit 3

cd $PWD

ln -sf $DART_DIR/models/POP/work/filter            .
ln -sf $DART_DIR/models/POP/work/perfect_model_obs .

