#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/rma_timing/models/POP/work'

cd $DART_DIR

./mkmf_preprocess        || exit 1
make
./preprocess
./mkmf_filter -mpi       || exit 2
make
./mkmf_perfect_model_obs || exit 3

cd $PWD

ln -sf $DART_DIR/filter            .
ln -sf $DART_DIR/perfect_model_obs .
