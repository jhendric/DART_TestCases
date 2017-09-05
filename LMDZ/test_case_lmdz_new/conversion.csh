#!/bin/csh
set n = 1
while( $n < 6)

  rm start.nc dart_ics
  cp start_$n.nc start.nc

  ./lmdz_to_dart

  set from = 'dart_ics'
  set to   = `printf "%s.%04d" filter_ic_old    $n`
  echo moving $from to $to
  mv $from $to

 @ n ++
end
