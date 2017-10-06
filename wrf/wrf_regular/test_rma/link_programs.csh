#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/rma_timing/models/wrf/work'

cd $DART_DIR

svn update

csh quickbuild.csh -mpi || exit 1

cd $PWD

ln -sf $DART_DIR/filter            .
ln -sf $DART_DIR/perfect_model_obs .
