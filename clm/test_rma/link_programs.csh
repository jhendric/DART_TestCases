#!/bin/csh

set PWD = `pwd`
set DART_DIR = '/glade/p/work/hendric/DART/rma_timing/models/clm/work'

cd $DART_DIR

<<<<<<< HEAD
csh quickbuild.csh -mpi
=======
svn update >! log.$$.txt

csh quickbuild.csh -mpi >! build_log.$$.txt || exit 1
>>>>>>> d2cde3c6e3d40213b1ade2e3debb551f60f8fd19

cd $PWD

ln -sf $DART_DIR/filter            .
ln -sf $DART_DIR/perfect_model_obs .
ln -sf $DART_DIR/clm_to_dart       .
ln -sf $DART_DIR/dart_to_clm       .
