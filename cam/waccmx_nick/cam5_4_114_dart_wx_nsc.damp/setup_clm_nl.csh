#!/bin/csh
@ n = 1
set stop_n = 6
set cesm_datadir = /glade/p/cesmdata/inputdata
while ($n <= 40)
  set inst_string = `printf _%04d $n`
  set fname = user_nl_clm$inst_string
  echo $fname

  echo "finidat = 'waccmx_gen_oct_ens_fxrefc1.clm2${inst_string}.r.2008-10-04-00000.nc'" >! $fname
  echo "hist_empty_htapes = .true." >> $fname
  echo "hist_fincl1 = 'TSA'" >> $fname
  echo " hist_nhtfrq = -6" >> $fname
  echo "hist_mfilt  = 1" >> $fname
  echo "hist_avgflag_pertape = 'I'" >> $fname

  @ n = $n + 1

end
