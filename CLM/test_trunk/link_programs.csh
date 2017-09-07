#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/trunk/models/clm/work'

cd $DART_DIR

# csh quickbuild.csh -mpi

cd $PWD

ln -sf $DART_DIR/filter            .
ln -sf $DART_DIR/perfect_model_obs .
ln -sf $DART_DIR/clm_to_dart       .
ln -sf $DART_DIR/dart_to_clm       .
