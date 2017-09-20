
#--------------------------------------------------------------------------
The EXPERIMENT directory is /glade/scratch/thoar/roms_cycling_test
The DART parts came from    /glade/p/work/thoar/DART/rma_output_files
The ROMS parts came from    /glade/p/work/thoar/roms/test
#--------------------------------------------------------------------------

    NtileI*NtileJ must equal the task count

    NtileI == 4            1 yellowstone node has 16 procs, use them all
    NtileJ == 4

    NTIMES == 48           \
        DT == 1800.0d0     ---  these two will advance ROMS for 1 day
      NRST == 48           write out a restart file after 1 day

    NTIMES == 24           \
        DT == 3600.0d0     ---  these two will advance ROMS for 1 day
      NRST == 24           write out a restart file after 1 day

#--------------------------------------------------------------------------
The following settings MUST be made to input.nml.template for the logic
in cycle.csh to work correctly.  There are many more that you _may_ want
to change or set to impact the performance of the assimilation.

&filter_nml:
   input_state_file_list        = 'restart_files.txt'
   output_state_file_list       = 'restart_files.txt'
   obs_sequence_in_name         = 'obs_seq.out'
   obs_sequence_out_name        = 'obs_seq.final'
   ens_size                     = <YOUR ACTUAL ENSEMBLE SIZE>

&convert_roms_obs_nml
   roms_mod_obs_filelist        = 'precomputed_files.txt'
   dart_output_obs_file         = 'obs_seq.out'
   append_to_existing           = .false.
   use_precomputed_values       = .true.

&model_nml
   assimilation_period_days     = <something bigger than NTIMES*DT>
   assimilation_period_seconds  = 0
   vert_localization_coord      = 3

#--------------------------------------------------------------------------

After these files are confirmed, it should be possible to
run/submit the /glade/scratch/thoar/roms_cycling_test/cycle.csh script.

