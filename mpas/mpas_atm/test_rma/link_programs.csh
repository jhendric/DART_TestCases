#!/bin/csh

set PWD      = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/rma_timing/models/mpas_atm/work'

cd $DART_DIR

csh quickbuild.csh -mpi || exit 1

cd $PWD

ln -sf $DART_DIR/filter .
ln -sf $DART_DIR/perfect_model_obs .
