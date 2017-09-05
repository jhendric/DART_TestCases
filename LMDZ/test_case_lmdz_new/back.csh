#!/bin/csh
set n = 1
while( $n < 6)

  \rm temp_ic start.nc

  set from = `printf "../data/test_case_lmdz_new/filter_ic_new.%04d" $n`
  set from = `printf "filter_ic_new.%04d" $n`
  cp -v $from temp_ic || exit 1

  cp -v ../data/test_case_lmdz_new/start_$n.nc start.nc || exit 2

  ./dart_to_lmdz || exit 3

  mv start.nc start_new_$n.nc

 @ n ++
end
