The initial conditions files come from
/glade2/scratch2/yfzhang/openloop_branch/run/openloop_branch.cice_*.r.2001-02-01-00000.nc

The observation sequence files came come from:
/glade/p/work/yfzhang/observations/syn/cice5/member10/aggre/aice/obs_seq.2001-02-01-00000

Fei's yellowstone binaries are:
/glade/p/work/yfzhang/rma_trunk/models/cice/work
[ Intel compiler, FFLAGS  = -O -vec-report0 -assume buffered_io $(INCS) ] 


# Copy Yongfei's stuff to the goldstandard directory.
# There were some changes to the drv_in and cice_in namelist to match that from the
# /glade2/scratch2/yfzhang/openloop_branch/run directory - only the namelists that
# dart_cice_mod.f90 reads were modified.

foreach FILE ( drv_in cice_in input.nml filter dart_to_cice )
  cp /glade/p/work/yfzhang/rma_trunk/models/cice/work/$FILE goldstandard/$FILE
end

cp /glade2/scratch2/yfzhang/openloop_branch/run/openloop_branch.cice_000[1-6].r.2001-02-01-00000.nc input_data/

cp /glade/p/work/yfzhang/observations/syn/cice5/member10/aggre/aice/obs_seq.2001-02-01-00000 input_obs/

