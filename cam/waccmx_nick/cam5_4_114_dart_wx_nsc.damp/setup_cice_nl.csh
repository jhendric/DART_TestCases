#!/bin/csh
@ n = 1
set stop_n = 6
set cesm_datadir = /glade/p/cesmdata/inputdata
while ($n <= 40)
  set inst_string = `printf _%04d $n`
  set fname = user_nl_cice$inst_string
  echo $fname

  echo "ice_ic = 'waccmx_gen_oct_ens_fxrefc1.cice${inst_string}.r.2008-10-04-00000.nc'" >! $fname

  @ n = $n + 1

end
