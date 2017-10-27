#!/bin/csh

echo "##########################################################################"
echo "# Running a bitwise test between the current rma_trunk and rma_branch     "
echo "##########################################################################"

set CAM = `pwd`
set BRANCH = test_rma_branch
set TRUNK  = test_rma

cd $TRUNK

csh run_all.csh || exit 1

cd $CAM/$BRANCH

csh run_all.csh || exit 2

cd $CAM

xxdiff $TRUNK/obs_seq.final $BRANCH/obs_seq.final
