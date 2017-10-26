#!/bin/csh

set num_ens = 80
set input_file_name_01  = "input_list_d01.txt"
set output_file_name_01 = "output_list_d01.txt"
set input_file_name_02  = "input_list_d02.txt"
set output_file_name_02 = "output_list_d02.txt"

set n = 1

if ( -e $input_file_name_01 )  rm $input_file_name_01
if ( -e $output_file_name_01 ) rm $output_file_name_01
if ( -e $input_file_name_02 )  rm $input_file_name_02
if ( -e $output_file_name_02 ) rm $output_file_name_02

while ($n <= $num_ens)

 set ensstring = `echo $n + 10000 | bc | cut -b2-5`
 set in_file_name = "./advance_temp"$n"/wrfinput_d01"
 set out_file_name = "filter_restart_d01."$ensstring
 echo $in_file_name  >> $input_file_name_01
 echo $out_file_name >> $output_file_name_01

 @ n++
end

set n = 1
while ($n <= $num_ens)

 set ensstring = `echo $n + 10000 | bc | cut -b2-5`
 set in_file_name = "./advance_temp"$n"/wrfinput_d02"
 set out_file_name = "filter_restart_d02."$ensstring
 echo $in_file_name  >> $input_file_name_02
 echo $out_file_name >> $output_file_name_02

 @ n++
end


