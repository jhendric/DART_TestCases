#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/rma_timing/models/clm/work'

cd $DART_DIR

svn update >! log.$$.txt

csh quickbuild.csh -mpi >! build_log.$$.txt || exit 1

cd $PWD

ln -sf $DART_DIR/filter            .
ln -sf $DART_DIR/perfect_model_obs .
ln -sf $DART_DIR/clm_to_dart       .
ln -sf $DART_DIR/dart_to_clm       .
