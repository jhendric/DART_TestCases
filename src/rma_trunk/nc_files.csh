#!/bin/csh

foreach file(`find . -name "*.nc"`)
   echo $file
   set cdl_file = "`basename $file | cut -d'.' -f1`".cdl
   set cdl = `dirname $file`"/"$cdl_file
   ncdump $file > $cdl
   rm $file
end
