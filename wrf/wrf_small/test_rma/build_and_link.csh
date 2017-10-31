#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/Users/hendric/DART/rma_dox/models/wrf/work'

cd $DART_DIR

svn update ../../.. >! log.$$.txt

csh quickbuild.csh -mpi || exit 1

cd $PWD

ln -sf $DART_DIR/filter            .
ln -sf $DART_DIR/perfect_model_obs .
