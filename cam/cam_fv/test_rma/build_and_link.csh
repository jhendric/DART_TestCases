#!/bin/csh

set CAM_DIR = '/Users/hendric/DART/rma_dox/models/cam-fv/work/'
set RUN_DIR = `pwd`

cd $CAM_DIR

csh quickbuild.csh -mpi

cd $RUN_DIR 

ln -sf $CAM_DIR/filter .
ln -sf $CAM_DIR/perfect_model_obs .
