#!/bin/csh

set DART_DIR = '/Users/hendric/DART/rma_dox/models/cam-fv/work/'

cd $DART_DIR

csh quickbuild.csh -mpi

cd --

ln -sf $DART_DIR/filter .
ln -sf $DART_DIR/perfect_model_obs .
